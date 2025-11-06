# Ring Service Usage Guide

## Overview

The `RingService` simulates Bluetooth communication with the Mira smart ring. It provides realistic behaviors including connection states, data synchronization, battery monitoring, and error scenarios.

## Quick Start

```dart
import 'package:smartring_demo/services/ring_service.dart';

// Get the singleton instance
final ringService = RingService.instance;

// Connect to ring
try {
  await ringService.connect();
  print('Connected! Battery: ${ringService.batteryLevel}%');
} catch (e) {
  print('Connection failed: $e');
}

// Sync data
final data = await ringService.syncData(
  onProgress: (progress) => print('Syncing: $progress%'),
);
print('Synced ${data.length} data points');
```

## Connection States

The service uses a state machine with these states:

```
disconnected → scanning → connecting → connected → syncing → connected
                  ↓           ↓
               error       error
```

### State Descriptions

- **`disconnected`**: Initial state, no connection
- **`scanning`**: Searching for ring via Bluetooth (2 seconds)
- **`connecting`**: Establishing connection (1.5 seconds)
- **`connected`**: Ring is connected and ready
- **`syncing`**: Downloading data from ring
- **`error`**: Connection or sync failure occurred

## Core Features

### 1. Connection Management

```dart
// Connect to ring
await ringService.connect();

// Check connection status
if (ringService.isConnected) {
  print('Ring is connected');
}

// Get current state
final state = ringService.currentState;

// Disconnect
await ringService.disconnect();
```

### 2. State Monitoring with Streams

Use streams to react to state changes in real-time:

```dart
class _MyScreenState extends State<MyScreen> {
  late StreamSubscription<RingConnectionState> _stateSubscription;
  RingConnectionState _currentState = RingConnectionState.disconnected;

  @override
  void initState() {
    super.initState();

    // Listen to connection state changes
    _stateSubscription = RingService.instance.connectionState.listen(
      (state) {
        if (mounted) {
          setState(() {
            _currentState = state;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Ring: $_currentState');
  }
}
```

### 3. Data Synchronization

```dart
Future<void> _syncRingData() async {
  try {
    setState(() {
      _syncProgress = 0;
      _isSyncing = true;
    });

    // Sync with progress callback
    final dataPoints = await RingService.instance.syncData(
      onProgress: (progress) {
        setState(() {
          _syncProgress = progress;
        });
      },
    );

    // Process synced data
    for (final data in dataPoints) {
      // Save to database or process
      await DatabaseService.instance.saveRingData(data);
    }

    print('Synced ${dataPoints.length} readings');

    setState(() {
      _isSyncing = false;
    });
  } catch (e) {
    setState(() {
      _isSyncing = false;
      _errorMessage = e.toString();
    });
  }
}
```

### 4. Real-time Data Reading

```dart
// Get current sensor values without full sync
final currentData = await ringService.getCurrentReading();
print('Current temp: ${currentData.temperature}°C');
print('Current steps: ${currentData.stepCount}');
```

### 5. Battery Monitoring

```dart
// Get current battery level
final battery = ringService.batteryLevel;

// Listen to battery changes
ringService.batteryLevelStream.listen((level) {
  if (level < 20) {
    showLowBatteryAlert();
  }
});
```

## Simulated Behaviors

### Realistic Delays

- **Scanning**: 2 seconds
- **Connecting**: 1.5 seconds
- **Syncing**: 2 seconds per day of data (up to 7 days)

### Failure Simulation

The service simulates realistic failures:

- **Connection failures**: 20% chance (configurable)
- **Sync failures**: 10% chance (configurable)

```dart
// Adjust failure rates for testing
ringService.connectionFailureRate = 0.5; // 50% failure
ringService.syncFailureRate = 0.0; // Never fail
```

### Battery Simulation

- Starts at 75%
- Decreases 1% per day (simulated time)
- Use `simulateTimePassing()` to test battery drain

```dart
// Simulate 3 days passing
ringService.simulateTimePassing(days: 3);
print('Battery now: ${ringService.batteryLevel}%');

// Recharge battery
ringService.chargeBattery(100);
```

## Data Generated

The service generates realistic sensor data:

### Daily Patterns

**Steps**:
- Day (8am-8pm): 50-350 steps per 15 minutes
- Night: 0-20 steps per 15 minutes

**Temperature**:
- Night (10pm-6am): 36.1-36.5°C (lower during sleep)
- Day: 36.4-37.0°C (higher when active)

**HRV (Heart Rate Variability)**:
- Night: 80-120ms (higher during rest)
- Day: 40-90ms (lower during activity)

**Heart Rate**:
- Night: 55-65 BPM (resting heart rate)
- Day: 65-85 BPM (active heart rate)

### Data Frequency

- One reading every 15 minutes
- 96 readings per day
- Up to 7 days stored on ring (672 readings max)

## Error Handling

### Exception Types

```dart
try {
  await ringService.connect();
} on RingConnectionException catch (e) {
  // Handle connection errors
  print('Connection error: $e');
} on RingNotConnectedException catch (e) {
  // Handle "not connected" errors
  print('Ring not connected: $e');
} on RingSyncException catch (e) {
  // Handle sync errors
  print('Sync error: $e');
} catch (e) {
  // Handle unexpected errors
  print('Unexpected error: $e');
}
```

### Retry Logic

```dart
Future<void> _connectWithRetry() async {
  int attempts = 0;
  const maxAttempts = 3;

  while (attempts < maxAttempts) {
    try {
      await RingService.instance.connect();
      return; // Success!
    } on RingConnectionException catch (e) {
      attempts++;
      if (attempts >= maxAttempts) {
        rethrow; // Give up after max attempts
      }
      print('Attempt $attempts failed, retrying...');
      await Future.delayed(Duration(seconds: 2));
    }
  }
}
```

## Complete Example: Ring Status Widget

```dart
import 'package:flutter/material.dart';
import 'package:smartring_demo/services/ring_service.dart';

class RingStatusWidget extends StatefulWidget {
  const RingStatusWidget({Key? key}) : super(key: key);

  @override
  State<RingStatusWidget> createState() => _RingStatusWidgetState();
}

class _RingStatusWidgetState extends State<RingStatusWidget> {
  late StreamSubscription<RingConnectionState> _stateSubscription;
  late StreamSubscription<int> _batterySubscription;

  RingConnectionState _state = RingConnectionState.disconnected;
  int _batteryLevel = 0;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();

    final ringService = RingService.instance;

    // Listen to state changes
    _stateSubscription = ringService.connectionState.listen((state) {
      if (mounted) {
        setState(() {
          _state = state;
          _isConnecting = state == RingConnectionState.scanning ||
                         state == RingConnectionState.connecting;
        });
      }
    });

    // Listen to battery changes
    _batterySubscription = ringService.batteryLevelStream.listen((level) {
      if (mounted) {
        setState(() {
          _batteryLevel = level;
        });
      }
    });

    // Initialize current values
    _state = ringService.currentState;
    _batteryLevel = ringService.batteryLevel;
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    _batterySubscription.cancel();
    super.dispose();
  }

  Future<void> _toggleConnection() async {
    final ringService = RingService.instance;

    if (ringService.isConnected) {
      // Disconnect
      await ringService.disconnect();
    } else {
      // Connect
      setState(() {
        _isConnecting = true;
      });

      try {
        await ringService.connect();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ring connected!')),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connection failed: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isConnecting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bluetooth,
                  color: _state == RingConnectionState.connected
                      ? Colors.blue
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mira Ring',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (RingService.instance.isConnected)
                  Row(
                    children: [
                      Icon(
                        Icons.battery_full,
                        color: _batteryLevel < 20 ? Colors.red : Colors.green,
                      ),
                      Text('$_batteryLevel%'),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_getStateText()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isConnecting ? null : _toggleConnection,
              child: Text(
                RingService.instance.isConnected
                    ? 'Disconnect'
                    : 'Connect Ring',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStateText() {
    switch (_state) {
      case RingConnectionState.disconnected:
        return 'Not connected';
      case RingConnectionState.scanning:
        return 'Scanning for ring...';
      case RingConnectionState.connecting:
        return 'Connecting...';
      case RingConnectionState.connected:
        final lastSync = RingService.instance.lastSyncTime;
        if (lastSync != null) {
          final diff = DateTime.now().difference(lastSync);
          return 'Connected • Last sync ${_formatDuration(diff)} ago';
        }
        return 'Connected';
      case RingConnectionState.syncing:
        return 'Syncing data...';
      case RingConnectionState.error:
        return 'Connection error';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inHours}h';
  }
}
```

## Testing Tips

### Test Connection Failures

```dart
// Increase failure rate to test error handling
RingService.instance.connectionFailureRate = 0.8; // 80% failure

// Try connecting multiple times
for (int i = 0; i < 5; i++) {
  try {
    await RingService.instance.connect();
    print('Connected on attempt ${i + 1}');
    break;
  } catch (e) {
    print('Attempt ${i + 1} failed');
  }
}
```

### Test Battery Drain

```dart
// Simulate days passing
for (int day = 0; day < 10; day++) {
  RingService.instance.simulateTimePassing(days: 1);
  print('Day $day: ${RingService.instance.batteryLevel}% battery');
}
```

### Test Long Sync

```dart
// Simulate 7 days of data (max storage)
RingService.instance.simulateTimePassing(days: 7);

// This will take ~14 seconds (2 sec per day)
await RingService.instance.syncData(
  onProgress: (p) => print('Progress: $p%'),
);
```

## Next Steps for UI Integration

1. **Home Screen**: Add ring connection status badge
2. **Settings Screen**: Add "Sync Ring" button with progress
3. **Ring Setup Screen**: First-time pairing flow
4. **Battery Indicator**: Show battery level when connected
5. **Sync History**: Display last sync time

## Transitioning to Real Hardware

When you get the actual Mira ring hardware:

1. Replace `RingService` with `flutter_blue_plus` implementation
2. Keep the same public API (same method signatures)
3. UI code doesn't need to change!
4. Use feature flag to switch between mock and real:

```dart
// In main.dart or config
const bool USE_MOCK_RING = false;

final ringService = USE_MOCK_RING
    ? MockRingService.instance
    : RealRingService.instance;
```

---

**For Students**: This mock service teaches you:
- State machine patterns
- Async programming with Futures and Streams
- Error handling and retry logic
- Progress tracking with callbacks
- Resource management (battery, memory)
- Realistic data generation
- How to design testable code

Study the implementation in `services/ring_service.dart` to understand these patterns!
