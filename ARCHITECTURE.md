# ARCHITECTURE.md

**Mira Smart Ring Companion App - Architecture Documentation**

**Version:** 1.0
**Last Updated:** November 5, 2025
**Target Audience:** Development Team (Students)

---

## Table of Contents

1. [Introduction](#introduction)
2. [Architecture Overview](#architecture-overview)
3. [Project Structure](#project-structure)
4. [Core Architectural Patterns](#core-architectural-patterns)
5. [Layer Descriptions](#layer-descriptions)
6. [Data Flow](#data-flow)
7. [Key Components](#key-components)
8. [Database Design](#database-design)
9. [ML Integration](#ml-integration)
10. [Error Handling](#error-handling)
11. [Testing Strategy](#testing-strategy)
12. [Common Pitfalls & Best Practices](#common-pitfalls--best-practices)
13. [Development Workflow](#development-workflow)

---

## Introduction

### Purpose of This Document

This document describes the architecture of the Mira smart ring companion app. It's designed to help you (the development team) understand:

- **How the app is organized** - where to find things and where to add new code
- **Why we made these choices** - the reasoning behind architectural decisions
- **How to work together** - patterns and conventions to keep the codebase clean
- **How to extend the app** - add new features without breaking existing code

### Design Philosophy

Our architecture prioritizes:

1. **Simplicity** - Easy to understand for developers new to Flutter
2. **Separation of Concerns** - UI, business logic, and data are separated
3. **Testability** - Code can be tested without running the full app
4. **Maintainability** - Easy to find bugs and add features
5. **Privacy** - All sensitive processing happens locally on-device

### Technology Stack

- **Framework**: Flutter 3.x (Dart 3.x)
- **Platform**: iOS 15+ and Android 9+
- **Database**: SQLite via `sqflite` package (with `sqflite_common_ffi` for desktop)
- **Encryption**: `sqflite_sqlcipher` for database encryption
- **Bluetooth**: `flutter_blue_plus` for BLE communication with ring
- **ML**: `tflite_flutter` for on-device TensorFlow Lite models
- **Charts**: `fl_chart` (already in use)
- **Calendar**: `table_calendar` (already in use)
- **State Management**: `StatefulWidget` with `setState` + `ChangeNotifier` for shared state
- **Authentication**: `local_auth` for biometric authentication

---

## Architecture Overview

### High-Level Architecture

The Mira app follows a **simplified layered architecture** (similar to MVC):

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  (Screens + Widgets - What the user sees and touches)   │
│                                                           │
│  - HomeScreen, CycleScreen, ActivityScreen, etc.         │
│  - Reusable widgets (MainShape, charts, buttons)         │
└─────────────────────┬───────────────────────────────────┘
                      │
                      │ setState() / ChangeNotifier
                      ↓
┌─────────────────────────────────────────────────────────┐
│                     SERVICE LAYER                        │
│      (Business Logic - How the app works)                │
│                                                           │
│  - RingService (BLE communication)                       │
│  - DatabaseService (data persistence)                    │
│  - MLService (cycle predictions)                         │
│  - NotificationService (alerts)                          │
└─────────────────────┬───────────────────────────────────┘
                      │
                      │ Models (data classes)
                      ↓
┌─────────────────────────────────────────────────────────┐
│                      DATA LAYER                          │
│         (Where data comes from and goes to)              │
│                                                           │
│  - SQLite Database (local storage)                       │
│  - Bluetooth LE (ring communication)                     │
│  - TensorFlow Lite (ML models)                           │
│  - File System (exports, backups)                        │
└─────────────────────────────────────────────────────────┘
```

### Why This Architecture?

**Separation of Concerns**: Each layer has a clear responsibility:
- **Presentation** doesn't know about databases or Bluetooth details
- **Services** don't know about Flutter widgets
- **Data** layer is just about reading/writing data

**Benefits for your team:**
- Person working on UI doesn't break Bluetooth code
- Can test business logic without running the app
- Easy to find where things are
- Can replace parts independently (e.g., swap database)

### Key Architectural Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **State Management** | `StatefulWidget` + `ChangeNotifier` | Simple for beginners, no dependency injection required |
| **Navigation** | Named routes | Already familiar from demo, sufficient for app size |
| **Dependency Injection** | Constructor injection (manual) | Teaches DI concepts without framework complexity |
| **Async Pattern** | `Future` + `async/await` | Simpler than Streams for most operations |
| **Error Handling** | Try-catch with user messages | Straightforward, easy to debug |
| **Database** | SQLite (sqflite) | Standard, students know SQL, industry-relevant |
| **ML Execution** | Service wrapper around TFLite | Abstraction allows testing and development without trained model |

---

## Project Structure

### Directory Organization

```
smartring_demo/
├── lib/
│   ├── main.dart                        # App entry point
│   │
│   ├── screens/                         # Full-screen views
│   │   ├── home_screen.dart             # Main dashboard
│   │   ├── cycle_screen.dart            # Calendar & cycle tracking
│   │   ├── activity_screen.dart         # Steps, exercise tracking
│   │   ├── health_screen.dart           # Temperature, HRV, sleep
│   │   ├── settings_screen.dart         # App configuration
│   │   └── onboarding_screen.dart       # First-time user setup
│   │
│   ├── widgets/                         # Reusable UI components
│   │   ├── main_shape.dart              # Neumorphic container (existing)
│   │   ├── charts/                      # Data visualizations
│   │   │   ├── histogram.dart           # Bar chart (existing)
│   │   │   ├── hrv_chart.dart           # HRV trend chart (existing as wykres1)
│   │   │   ├── temperature_chart.dart   # Temperature line chart
│   │   │   └── cycle_chart.dart         # Cycle phase visualization
│   │   ├── common/                      # Generic widgets
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   └── loading_indicator.dart
│   │   └── calendar/                    # Calendar-specific widgets
│   │       ├── event_marker.dart
│   │       └── cycle_day_widget.dart
│   │
│   ├── models/                          # Data structures
│   │   ├── cycle_data.dart              # Period, ovulation, phase info
│   │   ├── health_metrics.dart          # Temperature, HRV, steps
│   │   ├── ring_data.dart               # Raw sensor data from ring
│   │   ├── user_profile.dart            # User settings, preferences
│   │   ├── symptom.dart                 # Symptom logs
│   │   ├── prediction.dart              # ML prediction results
│   │   └── event.dart                   # Calendar events (existing)
│   │
│   ├── services/                        # Business logic
│   │   ├── ring_service.dart            # Bluetooth communication
│   │   ├── database_service.dart        # SQLite operations
│   │   ├── ml_service.dart              # Cycle prediction ML
│   │   ├── notification_service.dart    # Local notifications
│   │   ├── export_service.dart          # Data export (CSV, JSON, PDF)
│   │   ├── backup_service.dart          # Cloud backup (optional)
│   │   └── analytics_service.dart       # Health insights & correlations
│   │
│   ├── utils/                           # Helper functions
│   │   ├── constants.dart               # App-wide constants
│   │   ├── date_helpers.dart            # Date formatting, calculations
│   │   ├── validators.dart              # Input validation
│   │   ├── encryption_helpers.dart      # Encryption utilities
│   │   └── logger.dart                  # Debug logging
│   │
│   └── core/                            # Core app configuration
│       ├── app_config.dart              # Configuration constants
│       ├── theme.dart                   # App theme (colors, text styles)
│       └── routes.dart                  # Route definitions
│
├── assets/                              # Static assets
│   ├── images/
│   │   ├── backgrounds/                 # Screen backgrounds
│   │   │   ├── tlo_glowna.jpg
│   │   │   ├── tlo_aktywnosc.jpg
│   │   │   ├── tlo_niebieskie.jpg
│   │   │   └── tlo_tel_cykl.png
│   │   └── icons/                       # App icons
│   │       └── kropelka.jpg
│   └── models/                          # ML model files
│       ├── cycle_prediction.tflite      # TensorFlow Lite model
│       └── model_metadata.json          # Model version, info
│
├── test/                                # Tests
│   ├── unit/                            # Unit tests (services, utils)
│   │   ├── services/
│   │   │   ├── database_service_test.dart
│   │   │   ├── ml_service_test.dart
│   │   │   └── ring_service_test.dart
│   │   └── utils/
│   │       └── date_helpers_test.dart
│   ├── widget/                          # Widget tests
│   │   └── widgets/
│   │       └── main_shape_test.dart
│   └── integration/                     # Integration tests
│       └── app_test.dart
│
├── pubspec.yaml                         # Dependencies
├── analysis_options.yaml                # Linter rules
├── README.md                            # Project overview
├── CLAUDE.md                            # Claude Code guidance
├── PRD.md                               # Product requirements
└── ARCHITECTURE.md                      # This file
```

### File Naming Conventions

- **Files**: `snake_case.dart` (Flutter convention)
  - ✅ `cycle_screen.dart`
  - ❌ `CycleScreen.dart`
  - ❌ `cycle-screen.dart`

- **Classes**: `PascalCase`
  - ✅ `class CycleScreen`
  - ❌ `class cycleScreen`

- **Variables/Functions**: `camelCase`
  - ✅ `getUserProfile()`
  - ✅ `int cycleLength`
  - ❌ `get_user_profile()`

- **Constants**: `SCREAMING_SNAKE_CASE`
  - ✅ `const DATABASE_NAME = 'mira.db';`
  - ✅ `const MAX_SYNC_RETRIES = 3;`

- **Private members**: `_leadingUnderscore`
  - ✅ `int _counter;`
  - ✅ `void _updateData() { }`

---

## Core Architectural Patterns

### Pattern 1: Service Pattern

**What is it?**
A service is a class that encapsulates business logic and external interactions (database, Bluetooth, etc.). Screens use services to do work instead of doing it themselves.

**Why use it?**
- Keeps UI code clean and focused on display
- Services can be reused by multiple screens
- Easier to test (mock services in tests)
- One place to fix bugs

**Example:**

```dart
// ❌ BAD: Screen does everything
class CycleScreen extends StatefulWidget {
  @override
  _CycleScreenState createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  void _loadCycleData() async {
    // Directly accessing database - tight coupling!
    final db = await openDatabase('mira.db');
    final results = await db.query('cycles');
    // Parse data...
    // Calculate predictions...
    setState(() { ... });
  }
}

// ✅ GOOD: Screen uses service
class CycleScreen extends StatefulWidget {
  final DatabaseService databaseService;
  final MLService mlService;

  const CycleScreen({
    required this.databaseService,
    required this.mlService,
  });

  @override
  _CycleScreenState createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  CycleData? _cycleData;

  void _loadCycleData() async {
    try {
      final data = await widget.databaseService.getCycleHistory();
      final prediction = await widget.mlService.predictNextPeriod(data);
      setState(() {
        _cycleData = data;
      });
    } catch (e) {
      _showError('Failed to load cycle data: $e');
    }
  }
}
```

**Services in Mira App:**
- `RingService` - Bluetooth communication
- `DatabaseService` - Data persistence
- `MLService` - Cycle predictions
- `NotificationService` - Alerts
- `ExportService` - Data export
- `BackupService` - Cloud sync

### Pattern 2: Model Classes (Data Transfer Objects)

**What is it?**
Simple classes that hold data with no business logic. They represent "things" in your app.

**Why use it?**
- Type safety (Dart catches errors at compile time)
- Clear structure (everyone knows what data looks like)
- Easy to pass data between functions
- Can convert to/from JSON or database rows

**Example:**

```dart
// models/cycle_data.dart
class CycleData {
  final int id;
  final DateTime periodStartDate;
  final DateTime? periodEndDate;
  final int cycleLength;
  final DateTime? ovulationDate;

  CycleData({
    required this.id,
    required this.periodStartDate,
    this.periodEndDate,
    required this.cycleLength,
    this.ovulationDate,
  });

  // Convert from database map
  factory CycleData.fromMap(Map<String, dynamic> map) {
    return CycleData(
      id: map['id'],
      periodStartDate: DateTime.parse(map['period_start_date']),
      periodEndDate: map['period_end_date'] != null
          ? DateTime.parse(map['period_end_date'])
          : null,
      cycleLength: map['cycle_length'],
      ovulationDate: map['ovulation_date'] != null
          ? DateTime.parse(map['ovulation_date'])
          : null,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'period_start_date': periodStartDate.toIso8601String(),
      'period_end_date': periodEndDate?.toIso8601String(),
      'cycle_length': cycleLength,
      'ovulation_date': ovulationDate?.toIso8601String(),
    };
  }

  // Create a copy with some fields changed (useful for updates)
  CycleData copyWith({
    int? id,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    int? cycleLength,
    DateTime? ovulationDate,
  }) {
    return CycleData(
      id: id ?? this.id,
      periodStartDate: periodStartDate ?? this.periodStartDate,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      cycleLength: cycleLength ?? this.cycleLength,
      ovulationDate: ovulationDate ?? this.ovulationDate,
    );
  }
}
```

### Pattern 3: Dependency Injection (Manual)

**What is it?**
Instead of creating dependencies inside a class, you pass them in from outside (via constructor).

**Why use it?**
- **Testability**: Can pass fake/mock objects in tests
- **Flexibility**: Can swap implementations
- **Clear dependencies**: You see what a class needs

**Example:**

```dart
// ❌ BAD: Hard-coded dependencies
class CycleScreen extends StatefulWidget {
  @override
  _CycleScreenState createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  // Created inside - can't test with fake database!
  final DatabaseService _db = DatabaseService.instance;
  final MLService _ml = MLService();
}

// ✅ GOOD: Dependencies injected
class CycleScreen extends StatefulWidget {
  final DatabaseService databaseService;
  final MLService mlService;

  const CycleScreen({
    Key? key,
    required this.databaseService,
    required this.mlService,
  }) : super(key: key);

  @override
  _CycleScreenState createState() => _CycleScreenState();
}

// In main.dart or parent widget:
CycleScreen(
  databaseService: DatabaseService.instance,
  mlService: MLService(),
)

// In tests:
CycleScreen(
  databaseService: MockDatabaseService(), // Fake for testing!
  mlService: MockMLService(),
)
```

**When to use DI in Mira:**
- ✅ Screens that use services (inject services)
- ✅ Services that use other services (inject dependencies)
- ❌ Simple widgets (no need to inject everything)

**When to use Singleton:**
For truly global, single-instance objects:

```dart
class DatabaseService {
  // Private constructor
  DatabaseService._();

  // Single instance
  static final DatabaseService instance = DatabaseService._();

  // Use anywhere: DatabaseService.instance.getSomething()
}
```

Use singletons for:
- `DatabaseService` (one database connection)
- `RingService` (one ring connection)
- Configuration objects

### Pattern 4: Repository Pattern (Optional/Advanced)

**What is it?**
A layer between services and raw data sources. Provides a clean API for data access.

**Note**: This is **optional** for your app. Start simple, add if needed.

**Example (if you want to use it later):**

```dart
// Without repository (simpler, good for now):
class CycleService {
  final DatabaseService _db;

  Future<List<CycleData>> getCycleHistory() async {
    return await _db.query('SELECT * FROM cycles');
  }
}

// With repository (more layers, cleaner separation):
class CycleRepository {
  final DatabaseService _db;

  Future<List<CycleData>> getAllCycles() async {
    final maps = await _db.query('SELECT * FROM cycles');
    return maps.map((m) => CycleData.fromMap(m)).toList();
  }

  Future<void> saveCycle(CycleData cycle) async {
    await _db.insert('cycles', cycle.toMap());
  }
}

class CycleService {
  final CycleRepository _repo;
  final MLService _ml;

  Future<CyclePrediction> getPrediction() async {
    final history = await _repo.getAllCycles();
    return await _ml.predict(history);
  }
}
```

**Recommendation**: Skip repositories for now. If `DatabaseService` gets too complex, add repositories later.

---

## Layer Descriptions

### Presentation Layer (screens/ + widgets/)

**Responsibility**: Display data and handle user interactions.

**What goes here:**
- Screen layouts
- User input handling
- Animations and transitions
- Calling services to get/save data
- Showing error messages

**What does NOT go here:**
- Business logic (calculations, validations)
- Direct database access
- Bluetooth communication
- ML inference

**Example Screen Structure:**

```dart
// screens/activity_screen.dart
class ActivityScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const ActivityScreen({
    Key? key,
    required this.databaseService,
  }) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // UI state
  bool _isLoading = true;
  String? _errorMessage;
  List<int>? _weeklySteps;
  int _todaySteps = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call service to get data
      final data = await widget.databaseService.getWeeklySteps();

      setState(() {
        _weeklySteps = data;
        _todaySteps = data.last;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load activity data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
        backgroundColor: Color.fromARGB(255, 64, 155, 197),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.popAndPushNamed(context, '/home'),
        child: Icon(Icons.home),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset('assets/images/backgrounds/tlo_aktywnosc.jpg',
                              fit: BoxFit.cover),
        ),
        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30.0,
            children: [
              MainShape(
                kolor: Color.fromARGB(255, 130, 167, 197),
                nazwa: 'Steps: $_todaySteps',
              ),
              SizedBox(
                height: 200,
                child: MyHistogram(tygodniowePodsumowanie: _weeklySteps!),
              ),
              // More widgets...
            ],
          ),
        ),
      ],
    );
  }
}
```

**Widget Organization:**

```dart
// widgets/common/custom_button.dart - Reusable across app
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 236, 199, 231),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
}
```

### Service Layer (services/)

**Responsibility**: Business logic, external communication, data orchestration.

**Key Services:**

#### 1. RingService - Bluetooth Communication

```dart
// services/ring_service.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/ring_data.dart';
import '../utils/constants.dart';

class RingService {
  // Singleton pattern
  RingService._();
  static final RingService instance = RingService._();

  BluetoothDevice? _connectedRing;
  BluetoothCharacteristic? _dataCharacteristic;

  // Stream for connection status (UI can listen)
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  final _connectionStatusController = StreamController<bool>.broadcast();

  /// Scan for Mira ring and connect
  Future<void> connectToRing() async {
    try {
      // Start scanning
      FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      // Listen for scan results
      final subscription = FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult result in results) {
          // Look for Mira ring (check device name or service UUID)
          if (result.device.name.contains(RING_DEVICE_NAME)) {
            _connectedRing = result.device;

            // Stop scanning
            await FlutterBluePlus.stopScan();

            // Connect to device
            await _connectedRing!.connect();
            _connectionStatusController.add(true);

            // Discover services
            await _discoverServices();
            break;
          }
        }
      });
    } catch (e) {
      _connectionStatusController.add(false);
      throw Exception('Failed to connect to ring: $e');
    }
  }

  /// Discover BLE services and characteristics
  Future<void> _discoverServices() async {
    if (_connectedRing == null) return;

    List<BluetoothService> services = await _connectedRing!.discoverServices();

    for (BluetoothService service in services) {
      if (service.uuid.toString() == RING_DATA_SERVICE_UUID) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == RING_DATA_CHARACTERISTIC_UUID) {
            _dataCharacteristic = characteristic;
            // Enable notifications
            await _dataCharacteristic!.setNotifyValue(true);
          }
        }
      }
    }
  }

  /// Sync data from ring
  Future<List<RingData>> syncData() async {
    if (_connectedRing == null || _dataCharacteristic == null) {
      throw Exception('Ring not connected');
    }

    try {
      // Request data from ring (write command)
      await _dataCharacteristic!.write([0x01]); // 0x01 = sync command

      // Read data (this is simplified - real implementation would be more complex)
      List<RingData> dataPoints = [];

      // Listen to notifications from ring
      final subscription = _dataCharacteristic!.value.listen((value) {
        // Parse binary data from ring
        final ringData = _parseRingData(value);
        dataPoints.add(ringData);
      });

      // Wait for sync to complete (timeout after 30 seconds)
      await Future.delayed(Duration(seconds: 30));
      await subscription.cancel();

      return dataPoints;
    } catch (e) {
      throw Exception('Failed to sync data: $e');
    }
  }

  /// Parse binary data from ring into RingData model
  RingData _parseRingData(List<int> bytes) {
    // This is ring-specific protocol - example structure:
    // Bytes 0-7: timestamp (8 bytes, Unix epoch)
    // Bytes 8-11: step count (4 bytes, uint32)
    // Bytes 12-15: temperature (4 bytes, float)
    // Bytes 16+: PPG data...

    // (You'll need to implement this based on actual ring protocol)
    return RingData(
      timestamp: DateTime.now(), // Parse from bytes[0-7]
      stepCount: 5000, // Parse from bytes[8-11]
      temperature: 36.6, // Parse from bytes[12-15]
      ppgData: [], // Parse PPG samples
      accelerometerData: [], // Parse accel data
    );
  }

  /// Get battery level
  Future<int> getBatteryLevel() async {
    if (_connectedRing == null) {
      throw Exception('Ring not connected');
    }

    // Read battery characteristic
    // (Implementation depends on ring's BLE protocol)
    return 85; // Example: 85%
  }

  /// Disconnect from ring
  Future<void> disconnect() async {
    if (_connectedRing != null) {
      await _connectedRing!.disconnect();
      _connectedRing = null;
      _dataCharacteristic = null;
      _connectionStatusController.add(false);
    }
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
```

#### 2. DatabaseService - Data Persistence

```dart
// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cycle_data.dart';
import '../models/health_metrics.dart';
import '../utils/constants.dart';

class DatabaseService {
  // Singleton
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  /// Get database instance (create if doesn't exist)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), DATABASE_NAME);

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Cycles table
    await db.execute('''
      CREATE TABLE cycles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        period_start_date TEXT NOT NULL,
        period_end_date TEXT,
        cycle_length INTEGER NOT NULL,
        ovulation_date TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Health metrics table
    await db.execute('''
      CREATE TABLE health_metrics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        step_count INTEGER,
        basal_temperature REAL,
        hrv REAL,
        resting_heart_rate INTEGER,
        sleep_hours REAL,
        readiness_score INTEGER,
        created_at TEXT NOT NULL,
        UNIQUE(date)
      )
    ''');

    // Symptoms table
    await db.execute('''
      CREATE TABLE symptoms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        symptom_type TEXT NOT NULL,
        intensity INTEGER,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Raw ring data table
    await db.execute('''
      CREATE TABLE ring_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        step_count INTEGER,
        temperature REAL,
        ppg_data BLOB,
        accelerometer_data BLOB,
        created_at TEXT NOT NULL
      )
    ''');

    // Events table (calendar events)
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }

  /// Handle database migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle schema changes between versions
    if (oldVersion < 2) {
      // Example: add new column in version 2
      // await db.execute('ALTER TABLE cycles ADD COLUMN notes TEXT');
    }
  }

  // ============ CYCLE DATA OPERATIONS ============

  /// Insert new cycle
  Future<int> insertCycle(CycleData cycle) async {
    final db = await database;
    return await db.insert('cycles', cycle.toMap());
  }

  /// Get all cycles
  Future<List<CycleData>> getAllCycles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cycles',
      orderBy: 'period_start_date DESC',
    );

    return List.generate(maps.length, (i) => CycleData.fromMap(maps[i]));
  }

  /// Get cycles within date range
  Future<List<CycleData>> getCyclesInRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cycles',
      where: 'period_start_date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'period_start_date DESC',
    );

    return List.generate(maps.length, (i) => CycleData.fromMap(maps[i]));
  }

  /// Update cycle
  Future<int> updateCycle(CycleData cycle) async {
    final db = await database;
    return await db.update(
      'cycles',
      cycle.toMap(),
      where: 'id = ?',
      whereArgs: [cycle.id],
    );
  }

  // ============ HEALTH METRICS OPERATIONS ============

  /// Insert health metrics for a date
  Future<int> insertHealthMetrics(HealthMetrics metrics) async {
    final db = await database;
    return await db.insert(
      'health_metrics',
      metrics.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Update if date exists
    );
  }

  /// Get health metrics for specific date
  Future<HealthMetrics?> getHealthMetricsForDate(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD

    final List<Map<String, dynamic>> maps = await db.query(
      'health_metrics',
      where: 'date = ?',
      whereArgs: [dateStr],
    );

    if (maps.isEmpty) return null;
    return HealthMetrics.fromMap(maps.first);
  }

  /// Get weekly step counts
  Future<List<int>> getWeeklySteps() async {
    final db = await database;
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));

    final List<Map<String, dynamic>> maps = await db.query(
      'health_metrics',
      columns: ['step_count'],
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        weekAgo.toIso8601String().split('T')[0],
        now.toIso8601String().split('T')[0],
      ],
      orderBy: 'date ASC',
    );

    return maps.map((m) => m['step_count'] as int? ?? 0).toList();
  }

  // ============ DATA EXPORT ============

  /// Export all data as JSON
  Future<Map<String, dynamic>> exportAllData() async {
    final db = await database;

    return {
      'cycles': await db.query('cycles'),
      'health_metrics': await db.query('health_metrics'),
      'symptoms': await db.query('symptoms'),
      'events': await db.query('events'),
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  /// Delete all data (for privacy/user deletion)
  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('cycles');
    await db.delete('health_metrics');
    await db.delete('symptoms');
    await db.delete('ring_data');
    await db.delete('events');
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
```

#### 3. MLService - Cycle Predictions

```dart
// services/ml_service.dart
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/cycle_data.dart';
import '../models/health_metrics.dart';
import '../models/prediction.dart';
import '../utils/constants.dart';

class MLService {
  Interpreter? _interpreter;
  bool _isInitialized = false;

  /// Initialize TensorFlow Lite model
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _interpreter = await Interpreter.fromAsset(ML_MODEL_PATH);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load ML model: $e');
    }
  }

  /// Predict next period start date
  Future<CyclePrediction> predictNextPeriod({
    required List<CycleData> cycleHistory,
    required List<HealthMetrics> recentMetrics,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // If not enough data, use simple average
    if (cycleHistory.length < 2) {
      return _simpleAveragePrediction(cycleHistory);
    }

    try {
      // Prepare input features for ML model
      final inputFeatures = _prepareInputFeatures(cycleHistory, recentMetrics);

      // Run inference
      var output = List.filled(1 * 3, 0.0).reshape([1, 3]);
      _interpreter!.run(inputFeatures, output);

      // Parse output
      // output[0][0] = predicted cycle length
      // output[0][1] = confidence score
      // output[0][2] = days until next period

      final predictedCycleLength = output[0][0].round();
      final confidence = output[0][1];
      final daysUntilPeriod = output[0][2].round();

      final lastPeriod = cycleHistory.first.periodStartDate;
      final predictedDate = lastPeriod.add(Duration(days: predictedCycleLength));

      return CyclePrediction(
        predictedPeriodDate: predictedDate,
        confidence: confidence,
        predictedCycleLength: predictedCycleLength,
        daysUntilPeriod: daysUntilPeriod,
      );
    } catch (e) {
      // Fallback to simple prediction if ML fails
      return _simpleAveragePrediction(cycleHistory);
    }
  }

  /// Prepare input features for ML model
  List<List<double>> _prepareInputFeatures(
    List<CycleData> cycleHistory,
    List<HealthMetrics> recentMetrics,
  ) {
    // Feature engineering
    // This is simplified - real implementation would be more sophisticated

    List<double> features = [];

    // Cycle length features (last 3 cycles)
    for (int i = 0; i < 3 && i < cycleHistory.length; i++) {
      features.add(cycleHistory[i].cycleLength.toDouble());
    }
    // Pad if less than 3 cycles
    while (features.length < 3) {
      features.add(28.0); // Average cycle length
    }

    // Recent temperature trend (last 7 days average)
    if (recentMetrics.isNotEmpty) {
      final avgTemp = recentMetrics
          .where((m) => m.basalTemperature != null)
          .map((m) => m.basalTemperature!)
          .fold(0.0, (a, b) => a + b) / recentMetrics.length;
      features.add(avgTemp);
    } else {
      features.add(36.5); // Default temperature
    }

    // HRV trend
    if (recentMetrics.isNotEmpty) {
      final avgHRV = recentMetrics
          .where((m) => m.hrv != null)
          .map((m) => m.hrv!)
          .fold(0.0, (a, b) => a + b) / recentMetrics.length;
      features.add(avgHRV);
    } else {
      features.add(50.0); // Default HRV
    }

    // Activity level
    if (recentMetrics.isNotEmpty) {
      final avgSteps = recentMetrics
          .where((m) => m.stepCount != null)
          .map((m) => m.stepCount!)
          .fold(0, (a, b) => a + b) / recentMetrics.length;
      features.add(avgSteps);
    } else {
      features.add(7000.0); // Default steps
    }

    // Model expects shape [1, num_features]
    return [features];
  }

  /// Simple average-based prediction (fallback)
  CyclePrediction _simpleAveragePrediction(List<CycleData> cycleHistory) {
    if (cycleHistory.isEmpty) {
      // No data - use standard 28-day cycle
      return CyclePrediction(
        predictedPeriodDate: DateTime.now().add(Duration(days: 28)),
        confidence: 0.3,
        predictedCycleLength: 28,
        daysUntilPeriod: 28,
      );
    }

    // Calculate average cycle length
    final avgLength = cycleHistory
        .map((c) => c.cycleLength)
        .fold(0, (a, b) => a + b) / cycleHistory.length;

    final lastPeriod = cycleHistory.first.periodStartDate;
    final daysSinceLastPeriod = DateTime.now().difference(lastPeriod).inDays;
    final daysUntilNext = avgLength.round() - daysSinceLastPeriod;

    return CyclePrediction(
      predictedPeriodDate: DateTime.now().add(Duration(days: daysUntilNext)),
      confidence: cycleHistory.length >= 3 ? 0.7 : 0.5,
      predictedCycleLength: avgLength.round(),
      daysUntilPeriod: daysUntilNext,
    );
  }

  /// Predict fertile window
  Future<FertileWindow> predictFertileWindow(CyclePrediction cyclePrediction) async {
    // Ovulation typically occurs 14 days before period
    final ovulationDate = cyclePrediction.predictedPeriodDate.subtract(
      Duration(days: 14),
    );

    // Fertile window is ~5 days (3 days before ovulation, ovulation day, 1 day after)
    final fertileStart = ovulationDate.subtract(Duration(days: 3));
    final fertileEnd = ovulationDate.add(Duration(days: 1));

    return FertileWindow(
      ovulationDate: ovulationDate,
      fertileStartDate: fertileStart,
      fertileEndDate: fertileEnd,
      confidence: cyclePrediction.confidence * 0.8, // Slightly lower confidence
    );
  }

  void dispose() {
    _interpreter?.close();
  }
}
```

### Data Layer (models/)

**Responsibility**: Define data structures, no business logic.

**Example Models:**

```dart
// models/health_metrics.dart
class HealthMetrics {
  final int? id;
  final DateTime date;
  final int? stepCount;
  final double? basalTemperature;
  final double? hrv;
  final int? restingHeartRate;
  final double? sleepHours;
  final int? readinessScore;

  HealthMetrics({
    this.id,
    required this.date,
    this.stepCount,
    this.basalTemperature,
    this.hrv,
    this.restingHeartRate,
    this.sleepHours,
    this.readinessScore,
  });

  factory HealthMetrics.fromMap(Map<String, dynamic> map) {
    return HealthMetrics(
      id: map['id'],
      date: DateTime.parse(map['date']),
      stepCount: map['step_count'],
      basalTemperature: map['basal_temperature'],
      hrv: map['hrv'],
      restingHeartRate: map['resting_heart_rate'],
      sleepHours: map['sleep_hours'],
      readinessScore: map['readiness_score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String().split('T')[0],
      'step_count': stepCount,
      'basal_temperature': basalTemperature,
      'hrv': hrv,
      'resting_heart_rate': restingHeartRate,
      'sleep_hours': sleepHours,
      'readiness_score': readinessScore,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}

// models/prediction.dart
class CyclePrediction {
  final DateTime predictedPeriodDate;
  final double confidence; // 0.0 to 1.0
  final int predictedCycleLength;
  final int daysUntilPeriod;

  CyclePrediction({
    required this.predictedPeriodDate,
    required this.confidence,
    required this.predictedCycleLength,
    required this.daysUntilPeriod,
  });
}

class FertileWindow {
  final DateTime ovulationDate;
  final DateTime fertileStartDate;
  final DateTime fertileEndDate;
  final double confidence;

  FertileWindow({
    required this.ovulationDate,
    required this.fertileStartDate,
    required this.fertileEndDate,
    required this.confidence,
  });
}
```

---

## Data Flow

### Flow 1: App Startup

```
1. main.dart runs
   ↓
2. Initialize services (DatabaseService, RingService)
   ↓
3. Check if ring is paired
   ↓
4. Load user profile from database
   ↓
5. Navigate to HomeScreen (or OnboardingScreen if first time)
   ↓
6. HomeScreen loads today's data from database
   ↓
7. Display dashboard
```

**Code Example:**

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await DatabaseService.instance.database; // Initialize DB
  await MLService().initialize(); // Load ML model

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mira Ring',
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(
          databaseService: DatabaseService.instance,
          ringService: RingService.instance,
          mlService: MLService(),
        ),
        '/cycle': (context) => CycleScreen(/* ... */),
        '/activity': (context) => ActivityScreen(/* ... */),
        '/health': (context) => HealthScreen(/* ... */),
        '/settings': (context) => SettingsScreen(/* ... */),
      },
    );
  }
}
```

### Flow 2: Ring Data Sync

```
User opens app → Ring in Bluetooth range
   ↓
1. RingService detects ring
   ↓
2. Auto-connect via BLE
   ↓
3. RingService.syncData() called
   ↓
4. Ring sends binary data packets
   ↓
5. RingService parses into RingData models
   ↓
6. Process raw data:
   - Calculate BBT from temperature readings
   - Calculate HRV from PPG data
   - Aggregate step counts
   ↓
7. DatabaseService.insertHealthMetrics()
   ↓
8. DatabaseService.insertRawRingData() (for backup)
   ↓
9. Notify UI: setState() or ChangeNotifier
   ↓
10. UI updates to show latest data
```

**Sequence Diagram:**

```
User          UI            RingService      DatabaseService      Ring
 |             |                  |                  |              |
 |-- Open App->|                  |                  |              |
 |             |-- Connect ------>|                  |              |
 |             |                  |-- BLE Connect ----------------->|
 |             |                  |<---------- Connected ------------|
 |             |<-- Connected ----|                  |              |
 |-- Pull to ->|                  |                  |              |
 |   Refresh   |                  |                  |              |
 |             |-- syncData() --->|                  |              |
 |             |                  |-- Request Data ---------------->|
 |             |                  |<-------- Binary Packets --------|
 |             |                  |                  |              |
 |             |                  |-- Parse Data     |              |
 |             |                  |-- save() ------->|              |
 |             |                  |                  |-- SQL INSERT |
 |             |                  |<-- Success ------|              |
 |             |<-- Data Updated--|                  |              |
 |<-- UI Updates|                 |                  |              |
```

### Flow 3: Cycle Prediction

```
1. User opens Cycle Screen
   ↓
2. CycleScreen loads cycle history (DatabaseService.getAllCycles())
   ↓
3. CycleScreen loads recent health metrics (last 30 days)
   ↓
4. Call MLService.predictNextPeriod(cycleHistory, healthMetrics)
   ↓
5. MLService prepares input features:
   - Last 3 cycle lengths
   - Recent temperature trend
   - HRV pattern
   - Activity levels
   ↓
6. MLService runs TFLite inference
   ↓
7. Returns CyclePrediction (date, confidence, cycle length)
   ↓
8. CycleScreen updates UI with prediction
   ↓
9. Calculate fertile window (ovulation = period - 14 days)
   ↓
10. Display on calendar with color coding
```

**Code Example:**

```dart
class _CycleScreenState extends State<CycleScreen> {
  CyclePrediction? _prediction;

  Future<void> _loadPrediction() async {
    // Get historical data
    final cycleHistory = await widget.databaseService.getAllCycles();
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    final recentMetrics = await widget.databaseService.getHealthMetricsInRange(
      thirtyDaysAgo,
      DateTime.now(),
    );

    // Get prediction
    final prediction = await widget.mlService.predictNextPeriod(
      cycleHistory: cycleHistory,
      recentMetrics: recentMetrics,
    );

    setState(() {
      _prediction = prediction;
    });
  }
}
```

---

## Key Components

### Constants Configuration

```dart
// utils/constants.dart

// ============ DATABASE ============
const String DATABASE_NAME = 'mira.db';
const int DATABASE_VERSION = 1;

// ============ BLUETOOTH ============
const String RING_DEVICE_NAME = 'Mira Ring';
const String RING_DATA_SERVICE_UUID = '0000180d-0000-1000-8000-00805f9b34fb';
const String RING_DATA_CHARACTERISTIC_UUID = '00002a37-0000-1000-8000-00805f9b34fb';
const int MAX_SYNC_RETRIES = 3;
const Duration SYNC_TIMEOUT = Duration(seconds: 30);

// ============ ML MODEL ============
const String ML_MODEL_PATH = 'assets/models/cycle_prediction.tflite';
const int MIN_CYCLES_FOR_PREDICTION = 2;
const double PREDICTION_CONFIDENCE_THRESHOLD = 0.6;

// ============ HEALTH THRESHOLDS ============
const double NORMAL_TEMP_MIN = 36.1;
const double NORMAL_TEMP_MAX = 37.2;
const double TEMP_ANOMALY_THRESHOLD = 0.5; // Degrees Celsius
const int NORMAL_HRV_MIN = 20;
const int NORMAL_HRV_MAX = 200;
const int DAILY_STEP_GOAL = 10000;

// ============ CYCLE DEFAULTS ============
const int DEFAULT_CYCLE_LENGTH = 28;
const int DEFAULT_PERIOD_LENGTH = 5;
const int OVULATION_DAYS_BEFORE_PERIOD = 14;
const int FERTILE_WINDOW_DAYS = 5;

// ============ NOTIFICATIONS ============
const int PERIOD_ADVANCE_NOTICE_DAYS = 2;
const Duration NOTIFICATION_CHECK_INTERVAL = Duration(hours: 1);

// ============ UI ============
const Duration ANIMATION_DURATION = Duration(milliseconds: 300);
const int MAX_CHART_DATA_POINTS = 30;
```

### Theme Configuration

```dart
// core/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Color palette (neumorphic, matching current design)
  static const Color PRIMARY_COLOR = Color.fromARGB(255, 236, 199, 231);
  static const Color ACCENT_COLOR = Color.fromARGB(255, 141, 227, 138);
  static const Color ACTIVITY_COLOR = Color.fromARGB(255, 64, 155, 197);
  static const Color HEALTH_COLOR = Color.fromARGB(255, 34, 169, 88);
  static const Color CYCLE_COLOR = Color.fromARGB(255, 236, 161, 202);

  static const Color BACKGROUND_LIGHT = Color.fromARGB(255, 245, 245, 245);
  static const Color TEXT_DARK = Colors.black;
  static const Color TEXT_LIGHT = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: PRIMARY_COLOR,
      scaffoldBackgroundColor: BACKGROUND_LIGHT,

      colorScheme: ColorScheme.fromSeed(
        seedColor: PRIMARY_COLOR,
        brightness: Brightness.light,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: TEXT_DARK,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: TEXT_DARK,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          foregroundColor: TEXT_DARK,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: TextStyle(fontSize: 20),
        ),
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16),
      ),
    );
  }
}
```

### Date Helpers

```dart
// utils/date_helpers.dart

class DateHelpers {
  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get date without time component
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Format date for display (e.g., "Nov 5, 2025")
  static String formatDate(DateTime date, {String locale = 'en'}) {
    final months = locale == 'pl'
        ? ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze', 'Lip', 'Sie', 'Wrz', 'Paź', 'Lis', 'Gru']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Calculate days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = dateOnly(from);
    final toDate = dateOnly(to);
    return toDate.difference(fromDate).inDays;
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return dateOnly(date).subtract(Duration(days: daysFromMonday));
  }

  /// Get list of dates in range
  static List<DateTime> datesInRange(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    DateTime current = dateOnly(start);
    final endDate = dateOnly(end);

    while (current.isBefore(endDate) || isSameDay(current, endDate)) {
      dates.add(current);
      current = current.add(Duration(days: 1));
    }

    return dates;
  }
}
```

---

## Database Design

### Schema

```sql
-- Cycles table
CREATE TABLE cycles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  period_start_date TEXT NOT NULL,        -- ISO 8601 date
  period_end_date TEXT,                   -- ISO 8601 date (null if ongoing)
  cycle_length INTEGER NOT NULL,          -- Days in cycle
  ovulation_date TEXT,                    -- Predicted/confirmed ovulation
  created_at TEXT NOT NULL                -- Timestamp
);

-- Health metrics table (one row per day)
CREATE TABLE health_metrics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,                     -- YYYY-MM-DD
  step_count INTEGER,
  basal_temperature REAL,                 -- Celsius
  hrv REAL,                               -- Milliseconds (RMSSD)
  resting_heart_rate INTEGER,             -- BPM
  sleep_hours REAL,
  readiness_score INTEGER,                -- 0-100
  created_at TEXT NOT NULL,
  UNIQUE(date)                            -- One entry per day
);

-- Symptoms table
CREATE TABLE symptoms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,                     -- YYYY-MM-DD
  symptom_type TEXT NOT NULL,             -- 'cramps', 'headache', 'mood', etc.
  intensity INTEGER,                      -- 1-5 scale
  notes TEXT,
  created_at TEXT NOT NULL
);

-- Raw ring data table (backup of all sensor readings)
CREATE TABLE ring_data (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp TEXT NOT NULL,                -- ISO 8601 datetime
  step_count INTEGER,
  temperature REAL,
  ppg_data BLOB,                          -- Binary PPG samples
  accelerometer_data BLOB,                -- Binary accelerometer samples
  created_at TEXT NOT NULL
);

-- Events table (calendar notes)
CREATE TABLE events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,                     -- YYYY-MM-DD
  title TEXT NOT NULL,
  description TEXT,
  created_at TEXT NOT NULL
);

-- User profile table
CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY,                 -- Always 1 (singleton)
  average_cycle_length INTEGER,
  average_period_length INTEGER,
  notification_enabled BOOLEAN,
  cloud_backup_enabled BOOLEAN,
  last_sync_time TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

### Indexes (for performance)

```sql
CREATE INDEX idx_cycles_start_date ON cycles(period_start_date);
CREATE INDEX idx_health_metrics_date ON health_metrics(date);
CREATE INDEX idx_symptoms_date ON symptoms(date);
CREATE INDEX idx_ring_data_timestamp ON ring_data(timestamp);
CREATE INDEX idx_events_date ON events(date);
```

### Data Retention Policy

To keep database size manageable:

```dart
// In DatabaseService
Future<void> cleanupOldData() async {
  final db = await database;
  final twoYearsAgo = DateTime.now().subtract(Duration(days: 730));

  // Delete raw ring data older than 2 years
  await db.delete(
    'ring_data',
    where: 'timestamp < ?',
    whereArgs: [twoYearsAgo.toIso8601String()],
  );

  // Keep aggregated health_metrics indefinitely (small data)
  // Keep cycles indefinitely (important for predictions)
}
```

---

## ML Integration

### Model Architecture

**Input Features** (vector of length ~10):
- Last 3 cycle lengths (padded with avg if < 3 cycles)
- Average basal temperature (last 7 days)
- Average HRV (last 7 days)
- Average step count (last 7 days)
- Current cycle day
- Age (optional, if provided)
- BMI (optional, if provided)

**Output** (vector of length 3):
- Predicted cycle length (days)
- Confidence score (0-1)
- Days until next period

**Model Type**:
- LSTM (Long Short-Term Memory) or 1D CNN
- Trained on anonymized dataset
- Personalizes on-device with user's data

### TFLite Integration

```dart
// services/ml_service.dart (expanded)

class MLService {
  Interpreter? _interpreter;

  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset('assets/models/cycle_prediction.tflite');

    // Optional: Allocate tensors
    _interpreter!.allocateTensors();

    // Log model info (for debugging)
    print('Input shape: ${_interpreter!.getInputTensor(0).shape}');
    print('Output shape: ${_interpreter!.getOutputTensor(0).shape}');
  }

  // ... (rest of MLService code from earlier)
}
```

### Handling Missing ML Model (Development)

During development, you may not have a trained model yet. Use mock predictions:

```dart
// services/ml_service.dart

class MLService {
  final bool USE_MOCK_PREDICTIONS = true; // Set to false in production

  Future<CyclePrediction> predictNextPeriod({...}) async {
    if (USE_MOCK_PREDICTIONS) {
      // Return fake prediction for testing UI
      return _mockPrediction(cycleHistory);
    }

    // Real ML inference
    // ...
  }

  CyclePrediction _mockPrediction(List<CycleData> history) {
    return CyclePrediction(
      predictedPeriodDate: DateTime.now().add(Duration(days: 5)),
      confidence: 0.85,
      predictedCycleLength: 28,
      daysUntilPeriod: 5,
    );
  }
}
```

This lets you build the entire app before the ML model is ready!

---

## Error Handling

### Strategy

**Principle**: Fail gracefully, inform the user, don't crash.

**Levels of errors:**
1. **Recoverable** - Try again, use fallback, continue (e.g., sync failure)
2. **User-fixable** - Show message with action (e.g., "Turn on Bluetooth")
3. **Fatal** - Log error, show generic message, potentially restart (e.g., database corruption)

### Implementation Pattern

```dart
class SomeService {
  Future<Data> fetchData() async {
    try {
      // Attempt operation
      final result = await riskyOperation();
      return result;
    } on SpecificException catch (e) {
      // Handle specific error
      logger.error('Specific error: $e');
      throw UserFriendlyException('Please check your internet connection');
    } on AnotherException catch (e) {
      // Handle another specific error
      logger.error('Another error: $e');
      return _fallbackData(); // Use cached or default data
    } catch (e, stackTrace) {
      // Catch-all for unexpected errors
      logger.error('Unexpected error: $e\n$stackTrace');
      throw UserFriendlyException('Something went wrong. Please try again.');
    }
  }
}
```

### UI Error Display

```dart
class _SomeScreenState extends State<SomeScreen> {
  String? _errorMessage;

  Future<void> _loadData() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final data = await widget.service.fetchData();
      setState(() {
        _data = data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(_errorMessage!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Normal UI
    return _buildNormalContent();
  }
}
```

### Logging

```dart
// utils/logger.dart
class Logger {
  static void info(String message) {
    print('[INFO] $message');
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    print('[ERROR] $message');
    if (error != null) print('  Error: $error');
    if (stackTrace != null) print('  Stack: $stackTrace');
  }

  static void debug(String message) {
    print('[DEBUG] $message');
  }
}
```

---

## Testing Strategy

### Test Structure

```
test/
├── unit/                      # Fast, isolated tests
│   ├── services/
│   │   ├── database_service_test.dart
│   │   ├── ml_service_test.dart
│   │   └── ring_service_test.dart
│   ├── utils/
│   │   └── date_helpers_test.dart
│   └── models/
│       └── cycle_data_test.dart
├── widget/                    # Widget tests
│   └── widgets/
│       ├── main_shape_test.dart
│       └── charts/
│           └── histogram_test.dart
└── integration/               # Full app tests
    └── app_test.dart
```

### Unit Test Example

```dart
// test/unit/utils/date_helpers_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:smartring_demo/utils/date_helpers.dart';

void main() {
  group('DateHelpers', () {
    test('isSameDay returns true for same calendar day', () {
      final date1 = DateTime(2025, 11, 5, 10, 30);
      final date2 = DateTime(2025, 11, 5, 18, 45);

      expect(DateHelpers.isSameDay(date1, date2), true);
    });

    test('isSameDay returns false for different days', () {
      final date1 = DateTime(2025, 11, 5);
      final date2 = DateTime(2025, 11, 6);

      expect(DateHelpers.isSameDay(date1, date2), false);
    });

    test('daysBetween calculates correct difference', () {
      final start = DateTime(2025, 11, 1);
      final end = DateTime(2025, 11, 10);

      expect(DateHelpers.daysBetween(start, end), 9);
    });
  });
}
```

### Service Test with Mocking

```dart
// test/unit/services/ml_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:smartring_demo/services/ml_service.dart';
import 'package:smartring_demo/models/cycle_data.dart';

void main() {
  group('MLService', () {
    late MLService mlService;

    setUp(() {
      mlService = MLService();
    });

    test('predictNextPeriod returns valid prediction with 2+ cycles', () async {
      // Arrange: Create test data
      final cycleHistory = [
        CycleData(
          id: 1,
          periodStartDate: DateTime(2025, 10, 1),
          cycleLength: 28,
        ),
        CycleData(
          id: 2,
          periodStartDate: DateTime(2025, 9, 3),
          cycleLength: 29,
        ),
      ];

      // Act: Run prediction
      final prediction = await mlService.predictNextPeriod(
        cycleHistory: cycleHistory,
        recentMetrics: [],
      );

      // Assert: Check results
      expect(prediction.predictedCycleLength, greaterThan(20));
      expect(prediction.predictedCycleLength, lessThan(40));
      expect(prediction.confidence, greaterThan(0.0));
      expect(prediction.confidence, lessThanOrEqualTo(1.0));
    });

    test('predictNextPeriod uses default with no history', () async {
      final prediction = await mlService.predictNextPeriod(
        cycleHistory: [],
        recentMetrics: [],
      );

      expect(prediction.predictedCycleLength, 28); // Default cycle
      expect(prediction.confidence, lessThan(0.5)); // Low confidence
    });
  });
}
```

### Widget Test Example

```dart
// test/widget/widgets/main_shape_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartring_demo/main.dart';

void main() {
  testWidgets('MainShape displays text correctly', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainShape(
            kolor: Colors.blue,
            nazwa: 'Test Text',
          ),
        ),
      ),
    );

    // Verify text is displayed
    expect(find.text('Test Text'), findsOneWidget);

    // Verify container properties
    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.decoration, isA<BoxDecoration>());
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/utils/date_helpers_test.dart

# Run with coverage
flutter test --coverage
```

---

## Common Pitfalls & Best Practices

### Pitfall 1: Not Using `await` Properly

❌ **BAD:**
```dart
void loadData() {
  databaseService.getData(); // Missing await!
  setState(() { ... }); // Runs before data loads!
}
```

✅ **GOOD:**
```dart
Future<void> loadData() async {
  final data = await databaseService.getData();
  setState(() {
    _data = data;
  });
}
```

### Pitfall 2: Calling `setState` After Widget Disposed

❌ **BAD:**
```dart
class _ScreenState extends State<Screen> {
  void loadData() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() { ... }); // Crash if user navigated away!
  }
}
```

✅ **GOOD:**
```dart
class _ScreenState extends State<Screen> {
  void loadData() async {
    await Future.delayed(Duration(seconds: 5));
    if (mounted) { // Check if widget still exists
      setState(() { ... });
    }
  }
}
```

### Pitfall 3: Database Connections Not Closed

❌ **BAD:**
```dart
void getData() async {
  final db = await openDatabase('mira.db');
  final results = await db.query('cycles');
  // db never closed - memory leak!
}
```

✅ **GOOD:**
```dart
// Use singleton DatabaseService that manages connection lifecycle
final data = await DatabaseService.instance.getAllCycles();
// Service handles connection management
```

### Pitfall 4: Hardcoding Values

❌ **BAD:**
```dart
if (temperature > 37.5) { // Magic number!
  showAlert();
}
```

✅ **GOOD:**
```dart
if (temperature > FEVER_THRESHOLD) { // Defined in constants.dart
  showAlert();
}
```

### Pitfall 5: Not Handling Null Values

❌ **BAD:**
```dart
final temp = metrics.basalTemperature; // Could be null!
final display = temp.toStringAsFixed(1); // Crash!
```

✅ **GOOD:**
```dart
final temp = metrics.basalTemperature;
final display = temp != null ? temp.toStringAsFixed(1) : '--';
// Or use null-aware operator:
final display = metrics.basalTemperature?.toStringAsFixed(1) ?? '--';
```

### Best Practice 1: Consistent Naming

```dart
// ✅ GOOD: Clear, consistent names
class CycleScreen extends StatefulWidget { ... }
class CycleData { ... }
final CycleService cycleService;

// ❌ BAD: Inconsistent, unclear
class Screen1 extends StatefulWidget { ... }
class Data { ... }
final svc = ...;
```

### Best Practice 2: Small Functions

```dart
// ❌ BAD: Giant function doing everything
void loadAllData() async {
  // 100 lines of code...
}

// ✅ GOOD: Break into smaller functions
Future<void> loadAllData() async {
  await _loadCycleData();
  await _loadHealthMetrics();
  await _loadPredictions();
}

Future<void> _loadCycleData() async { ... }
Future<void> _loadHealthMetrics() async { ... }
Future<void> _loadPredictions() async { ... }
```

### Best Practice 3: Document Complex Code

```dart
// ✅ GOOD: Explain WHY, not just WHAT
/// Calculates basal body temperature from nighttime readings.
/// BBT is the minimum temperature during sleep, typically measured
/// between 3-6 AM. We take the 10th percentile of temperatures
/// during sleep hours to filter out outliers.
double calculateBasalTemperature(List<double> nighttimeTemps) {
  // Implementation...
}
```

### Best Practice 4: Use `const` for Performance

```dart
// ✅ GOOD: const widgets are reused, not rebuilt
const Text('Hello');
const SizedBox(height: 20);
const Icon(Icons.home);

// ❌ BAD: Created fresh on every rebuild
Text('Hello');
SizedBox(height: 20);
Icon(Icons.home);
```

---

## Development Workflow

### Team Workflow (3 Developers)

**Person 1: Cycle Tracking Feature**
- Owns `screens/cycle_screen.dart`
- Owns `widgets/calendar/` widgets
- Works with `services/ml_service.dart` (shared)
- Works with `models/cycle_data.dart`, `models/prediction.dart`

**Person 2: Activity & Health Features**
- Owns `screens/activity_screen.dart`, `screens/health_screen.dart`
- Owns `widgets/charts/` (histogram, HRV chart, temp chart)
- Works with `models/health_metrics.dart`

**Person 3: Ring Integration & Core Services**
- Owns `services/ring_service.dart`
- Owns `services/database_service.dart`
- Owns `services/notification_service.dart`
- Helps others integrate with services

**Shared Responsibilities:**
- Everyone: Add tests for their code
- Code review: Each PR reviewed by at least one other person
- Integration: Weekly sync to integrate features

### Git Workflow

```bash
# 1. Create feature branch
git checkout -b feature/cycle-prediction

# 2. Make changes, commit often
git add .
git commit -m "Add cycle prediction UI"

# 3. Push to remote
git push origin feature/cycle-prediction

# 4. Create Pull Request on GitHub
# 5. Code review
# 6. Merge to main after approval
```

### Development Phases

**Phase 1 (Weeks 1-2): Setup & Core Infrastructure**
- ✅ Project structure
- ✅ Database setup (tables, migrations)
- ✅ Basic navigation
- ✅ Services scaffolding (empty methods)
- ✅ Model classes

**Phase 2 (Weeks 3-4): Ring Integration**
- ✅ Bluetooth connection
- ✅ Data sync
- ✅ Parse ring data
- ✅ Store in database

**Phase 3 (Weeks 5-6): Core Features - Part 1**
- ✅ Activity screen (steps, histogram)
- ✅ Health screen (temp, HRV charts)
- ✅ Calendar view

**Phase 4 (Weeks 7-8): Core Features - Part 2**
- ✅ Cycle tracking
- ✅ Period logging
- ✅ ML prediction (mock first, real later)

**Phase 5 (Weeks 9-10): Polish & Advanced Features**
- ✅ Notifications
- ✅ Data export
- ✅ Settings
- ✅ Onboarding

**Phase 6 (Weeks 11-12): Testing & Refinement**
- ✅ Unit tests
- ✅ Bug fixes
- ✅ Performance optimization
- ✅ UI polish

---

## Appendix

### Useful Packages

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  # UI
  table_calendar: ^3.0.8         # Calendar widget
  fl_chart: ^1.1.1               # Charts
  flutter_localizations:         # Localization
    sdk: flutter

  # Data & State
  sqflite: ^2.3.0                # SQLite database
  sqflite_sqlcipher: ^2.2.1      # Encrypted database
  path: ^1.8.3                   # Path manipulation

  # Bluetooth
  flutter_blue_plus: ^1.14.0     # BLE communication

  # ML
  tflite_flutter: ^0.10.4        # TensorFlow Lite

  # Utilities
  intl: ^0.18.1                  # Date formatting
  local_auth: ^2.1.7             # Biometric authentication
  shared_preferences: ^2.2.2     # Simple key-value storage

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0          # Linting
  mockito: ^5.4.4                # Mocking for tests
```

### Learning Resources

**Flutter Basics:**
- Official Flutter docs: https://docs.flutter.dev
- Flutter Codelabs: https://docs.flutter.dev/codelabs
- Widget Catalog: https://docs.flutter.dev/ui/widgets

**Architecture:**
- Flutter Architecture Samples: https://github.com/brianegan/flutter_architecture_samples
- Clean Architecture in Flutter: https://medium.com/ruangguru/an-introduction-to-flutter-clean-architecture

**Database:**
- sqflite Documentation: https://pub.dev/packages/sqflite
- SQL Tutorial: https://www.w3schools.com/sql/

**Bluetooth:**
- flutter_blue_plus: https://pub.dev/packages/flutter_blue_plus
- BLE Basics: https://www.bluetooth.com/learn-about-bluetooth/

**ML:**
- TFLite Flutter: https://pub.dev/packages/tflite_flutter
- TensorFlow Lite Guide: https://www.tensorflow.org/lite/guide

### Troubleshooting

**Problem: "Database is locked"**
- Solution: Don't open multiple database connections. Use singleton `DatabaseService.instance`

**Problem: "setState called after dispose"**
- Solution: Check `if (mounted)` before calling `setState()`

**Problem: "Bluetooth not connecting"**
- Solution: Check permissions in `AndroidManifest.xml` and `Info.plist`

**Problem: "ML model not loading"**
- Solution: Ensure `.tflite` file is in `assets/models/` and listed in `pubspec.yaml`

**Problem: "Build fails on iOS"**
- Solution: Run `cd ios && pod install && cd ..`

---

## Conclusion

This architecture is designed to be:
- ✅ **Simple enough** for students new to Flutter
- ✅ **Structured enough** to scale as the app grows
- ✅ **Professional enough** to teach good practices
- ✅ **Flexible enough** to refactor as you learn

**Remember:**
1. Start simple, refactor later
2. Test as you go
3. Comment complex code
4. Ask for help when stuck
5. Have fun building!

---

**Document Version:** 1.0
**Questions?** Contact: [Your Name/Email]
**Last Updated:** November 5, 2025
