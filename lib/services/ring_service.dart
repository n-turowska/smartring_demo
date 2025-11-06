// services/ring_service.dart

import 'dart:async';
import 'dart:math';
import '../models/ring_data.dart';

/// Connection states for the Mira ring
///
/// State transitions:
/// disconnected → scanning → connecting → connected → syncing → connected
///                    ↓           ↓
///                 error       error
enum RingConnectionState {
  /// Ring is not connected
  disconnected,

  /// Searching for Mira ring via Bluetooth
  scanning,

  /// Found ring, establishing connection
  connecting,

  /// Ring is connected and ready
  connected,

  /// Currently syncing data from ring
  syncing,

  /// Connection or sync error occurred
  error,
}

/// Mock Bluetooth service for the Mira smart ring
///
/// This service simulates Bluetooth Low Energy (BLE) communication with
/// a smart ring. It provides realistic behaviors including:
/// - Connection state management
/// - Realistic delays and occasional failures
/// - Data synchronization with progress
/// - Battery level simulation
/// - Realistic sensor data generation
///
/// **FOR STUDENTS**: This is a mock implementation. The real implementation
/// would use the flutter_blue_plus package to communicate with actual hardware.
/// The mock allows us to:
/// 1. Develop the UI without hardware
/// 2. Test error scenarios easily
/// 3. Demonstrate proper architecture
/// 4. Learn state management patterns
///
/// Example usage:
/// ```dart
/// final ringService = RingService.instance;
///
/// // Listen to connection status
/// ringService.connectionState.listen((state) {
///   print('Ring state: $state');
/// });
///
/// // Connect to ring
/// try {
///   await ringService.connect();
///   print('Connected! Battery: ${ringService.batteryLevel}%');
/// } catch (e) {
///   print('Failed to connect: $e');
/// }
///
/// // Sync data
/// await ringService.syncData(
///   onProgress: (progress) => print('Sync: $progress%'),
/// );
/// ```
class RingService {
  // ============ SINGLETON PATTERN ============
  // Only one RingService instance should exist (one ring connection)

  RingService._(); // Private constructor
  static final RingService instance = RingService._();

  // ============ STATE ============

  /// Current connection state
  RingConnectionState _state = RingConnectionState.disconnected;

  /// Battery level (0-100%)
  int _batteryLevel = 75;

  /// Last successful sync time
  DateTime? _lastSyncTime;

  /// Ring device name (for UI display)
  final String _ringName = 'Mira Ring';

  /// Simulated days of stored data on ring (max 7 days)
  int _daysOfStoredData = 3;

  // ============ STREAMS ============
  // Streams allow UI to react to state changes in real-time

  /// Stream controller for connection state
  final _stateController = StreamController<RingConnectionState>.broadcast();

  /// Stream of connection state changes
  ///
  /// UI can listen to this to update connection status displays
  Stream<RingConnectionState> get connectionState => _stateController.stream;

  /// Get current connection state (synchronous)
  RingConnectionState get currentState => _state;

  /// Stream controller for battery level
  final _batteryController = StreamController<int>.broadcast();

  /// Stream of battery level changes
  Stream<int> get batteryLevelStream => _batteryController.stream;

  // ============ GETTERS ============

  /// Current battery level (0-100%)
  int get batteryLevel => _batteryLevel;

  /// Last successful sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Ring device name
  String get ringName => _ringName;

  /// Is ring currently connected?
  bool get isConnected =>
      _state == RingConnectionState.connected ||
      _state == RingConnectionState.syncing;

  /// Days of data stored on ring (not yet synced)
  int get daysOfStoredData => _daysOfStoredData;

  // ============ CONFIGURATION ============
  // These can be adjusted to simulate different scenarios

  /// Simulate connection failures (0.0 = never fail, 1.0 = always fail)
  double connectionFailureRate = 0.2; // 20% failure rate

  /// Simulate sync failures
  double syncFailureRate = 0.1; // 10% failure rate

  /// Delay for scanning (milliseconds)
  int scanDelayMs = 2000;

  /// Delay for connecting (milliseconds)
  int connectDelayMs = 1500;

  /// Delay per day of data during sync (milliseconds)
  int syncDelayPerDayMs = 2000;

  // ============ PUBLIC API ============

  /// Connect to the Mira ring
  ///
  /// Simulates Bluetooth connection process:
  /// 1. Scan for ring (2 seconds)
  /// 2. Connect to ring (1.5 seconds)
  /// 3. Discover services (included in connect time)
  ///
  /// Throws [RingConnectionException] if connection fails
  ///
  /// Returns: true if connection successful
  Future<bool> connect() async {
    // Can't connect if already connected
    if (isConnected) {
      throw RingConnectionException('Ring is already connected');
    }

    try {
      // Step 1: Scanning
      _updateState(RingConnectionState.scanning);
      await Future.delayed(Duration(milliseconds: scanDelayMs));

      // Simulate scan failure (ring not found)
      if (_shouldSimulateFailure(connectionFailureRate)) {
        throw RingConnectionException('Ring not found. Make sure ring is nearby and charged.');
      }

      // Step 2: Connecting
      _updateState(RingConnectionState.connecting);
      await Future.delayed(Duration(milliseconds: connectDelayMs));

      // Simulate connection failure
      if (_shouldSimulateFailure(connectionFailureRate)) {
        throw RingConnectionException('Failed to connect to ring. Please try again.');
      }

      // Success!
      _updateState(RingConnectionState.connected);
      _updateBattery(_batteryLevel); // Notify battery level
      return true;
    } catch (e) {
      _updateState(RingConnectionState.error);
      rethrow;
    }
  }

  /// Disconnect from the ring
  ///
  /// Safe to call even if not connected
  Future<void> disconnect() async {
    if (_state == RingConnectionState.disconnected) {
      return; // Already disconnected
    }

    // Small delay to simulate cleanup
    await Future.delayed(const Duration(milliseconds: 200));

    _updateState(RingConnectionState.disconnected);
  }

  /// Sync data from the ring
  ///
  /// Downloads all unsynced data from the ring (up to 7 days).
  /// Calls [onProgress] callback with percentage (0-100) during sync.
  ///
  /// Parameters:
  ///   - onProgress: Optional callback for sync progress updates
  ///
  /// Returns: List of [RingData] collected from ring
  ///
  /// Throws:
  ///   - [RingNotConnectedException] if ring not connected
  ///   - [RingSyncException] if sync fails
  Future<List<RingData>> syncData({
    Function(int progress)? onProgress,
  }) async {
    // Verify connected
    if (!isConnected) {
      throw RingNotConnectedException('Ring must be connected before syncing');
    }

    try {
      _updateState(RingConnectionState.syncing);

      // Simulate reading data from ring
      final dataPoints = <RingData>[];
      final totalDays = _daysOfStoredData;

      for (int day = 0; day < totalDays; day++) {
        // Simulate time to download one day of data
        await Future.delayed(Duration(milliseconds: syncDelayPerDayMs));

        // Generate mock data for this day
        final dayData = _generateDayData(DateTime.now().subtract(Duration(days: totalDays - day - 1)));
        dataPoints.addAll(dayData);

        // Update progress
        final progress = ((day + 1) / totalDays * 100).round();
        onProgress?.call(progress);

        // Simulate random sync failure midway
        if (day == totalDays ~/ 2 && _shouldSimulateFailure(syncFailureRate)) {
          throw RingSyncException('Connection lost during sync. Please try again.');
        }
      }

      // Sync complete
      _lastSyncTime = DateTime.now();
      _daysOfStoredData = 0; // Ring memory cleared
      _updateState(RingConnectionState.connected);

      return dataPoints;
    } catch (e) {
      _updateState(RingConnectionState.error);
      rethrow;
    }
  }

  /// Get current sensor readings from ring (real-time)
  ///
  /// This simulates reading current values without full sync.
  /// Useful for displaying current metrics on demand.
  ///
  /// Throws [RingNotConnectedException] if not connected
  Future<RingData> getCurrentReading() async {
    if (!isConnected) {
      throw RingNotConnectedException('Ring not connected');
    }

    // Small delay to simulate BLE read
    await Future.delayed(const Duration(milliseconds: 300));

    return _generateRingData(DateTime.now());
  }

  /// Simulate time passing (for testing/demo)
  ///
  /// This advances the simulated time, affecting:
  /// - Battery level (decreases)
  /// - Stored data (increases)
  ///
  /// Useful for testing UI updates over time.
  void simulateTimePassing({int days = 1}) {
    // Battery drains ~1% per day
    _batteryLevel = max(0, _batteryLevel - days);
    _updateBattery(_batteryLevel);

    // Ring accumulates data (max 7 days)
    _daysOfStoredData = min(7, _daysOfStoredData + days);
  }

  /// Charge ring battery (for testing)
  void chargeBattery(int percentage) {
    _batteryLevel = max(0, min(100, percentage));
    _updateBattery(_batteryLevel);
  }

  // ============ PRIVATE METHODS ============

  /// Update connection state and notify listeners
  void _updateState(RingConnectionState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  /// Update battery level and notify listeners
  void _updateBattery(int level) {
    _batteryLevel = level;
    _batteryController.add(level);
  }

  /// Determine if we should simulate a failure
  bool _shouldSimulateFailure(double failureRate) {
    return Random().nextDouble() < failureRate;
  }

  // ============ MOCK DATA GENERATION ============

  /// Generate realistic sensor data for one day
  ///
  /// Creates ~96 readings per day (every 15 minutes)
  List<RingData> _generateDayData(DateTime day) {
    final dataPoints = <RingData>[];
    final startOfDay = DateTime(day.year, day.month, day.day, 0, 0);

    // Generate reading every 15 minutes
    for (int i = 0; i < 96; i++) {
      final timestamp = startOfDay.add(Duration(minutes: i * 15));
      dataPoints.add(_generateRingData(timestamp));
    }

    return dataPoints;
  }

  /// Generate realistic sensor reading for a specific time
  RingData _generateRingData(DateTime timestamp) {
    final random = Random(timestamp.millisecondsSinceEpoch);
    final hour = timestamp.hour;

    // Realistic patterns based on time of day

    // Steps: More during day (8am-8pm), less at night
    int steps;
    if (hour >= 8 && hour <= 20) {
      steps = random.nextInt(300) + 50; // 50-350 steps per 15 min
    } else {
      steps = random.nextInt(20); // 0-20 steps at night
    }

    // Temperature: Lower at night (sleep), higher during day
    // Normal range: 36.1-37.2°C
    double temperature;
    if (hour >= 22 || hour <= 6) {
      // Night: Lower (36.1-36.5°C)
      temperature = 36.1 + random.nextDouble() * 0.4;
    } else {
      // Day: Higher (36.4-37.0°C)
      temperature = 36.4 + random.nextDouble() * 0.6;
    }

    // HRV: Higher at night (rest), lower during activity
    // Normal range: 20-200ms
    double hrv;
    if (hour >= 22 || hour <= 6) {
      // Night: Higher HRV (80-120ms)
      hrv = 80 + random.nextDouble() * 40;
    } else {
      // Day: Lower HRV (40-90ms)
      hrv = 40 + random.nextDouble() * 50;
    }

    // Heart Rate: Lower at night, higher during day
    int heartRate;
    if (hour >= 22 || hour <= 6) {
      heartRate = 55 + random.nextInt(10); // 55-65 BPM at night
    } else {
      heartRate = 65 + random.nextInt(20); // 65-85 BPM during day
    }

    return RingData(
      timestamp: timestamp,
      stepCount: steps,
      temperature: temperature,
      batteryLevel: _batteryLevel,
      hrv: hrv,
      heartRate: heartRate,
    );
  }

  // ============ CLEANUP ============

  /// Dispose of resources
  ///
  /// Call this when the service is no longer needed
  void dispose() {
    _stateController.close();
    _batteryController.close();
  }
}

// ============ EXCEPTIONS ============

/// Base exception for ring service errors
class RingException implements Exception {
  final String message;
  RingException(this.message);

  @override
  String toString() => message;
}

/// Thrown when ring connection fails
class RingConnectionException extends RingException {
  RingConnectionException(super.message);
}

/// Thrown when data sync fails
class RingSyncException extends RingException {
  RingSyncException(super.message);
}

/// Thrown when operation attempted while ring not connected
class RingNotConnectedException extends RingException {
  RingNotConnectedException(super.message);
}
