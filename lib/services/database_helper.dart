import 'package:smartring_demo/services/database_service.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  final String _cycleTableName = 'cycle_events';
  final String _idColumnName = 'id';
  final String _dateColumnName = 'date';
  final String _cycleEventTypeColumnName = 'event_type';
  final String _predictionColumnName = "is_prediction";
  final String _confidenceColumnName = "confidence";
  final String _notesColumnName = "notes";
  final String _userTableName = 'user_profile';
  final String _userAvrCycleLengthColumnName = 'average_cycle_length';
  final String _userLastPeriodColumnName = "last_period_start";
  final String _createdTableColumnName = 'created_at';
  final String _userUpdatedTableColumnName = 'updated_at';
  final String _healthTableName = "health_metrics";
  final String _stepColumnName = "step_count";
  final String _basalTempColumnName = "basal_temperature";
  final String _hrvColumnName = "hrv";
  final String _restHeartRateColumnName = "resting_heart_rate";
  final String _sleepHoursColumnName = "sleep_hours";
  final String _sleepQualityColumnName = "sleep_quality";
  final String _readinessColumnName = "readiness_score";
  static const String _dbName = "encrypted_data.db";
  static const String _passwordKey = 'dbPassword';
  static Database? _db;
  DatabaseHelper._init();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String> _getPassword() async {
    String? password = await _secureStorage.read(key: _passwordKey);
    if (password == null) {
      final random = Random.secure();
      password = List<int>.generate(
        32,
        (_) => random.nextInt(256),
      ).map((e) => e.toRadixString(16).padLeft(2, '0')).join();
      await _secureStorage.write(key: _passwordKey, value: password);
    }
    return password;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _getDatabase();
    return _db!;
  }

  Future<Database> _getDatabase() async {
    //asynchroniczna, nie zwraca od razu->od razu zwraca future, czyli cos co w przyszlosci bedzie
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, _dbName);
    final key = await _getPassword();

    final database = await openDatabase(
      databasePath,
      password: key,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys=ON');
      },
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('''
    CREATE TABLE $_userTableName(
    
    $_idColumnName INTEGER PRIMARY KEY CHECK(id=1),
    $_userAvrCycleLengthColumnName INTEGER DEFAULT 28,
    $_userLastPeriodColumnName TEXT,
    $_createdTableColumnName TEXT NOT NULL,
    $_userUpdatedTableColumnName TEXT NOT NULL
    )
''');
    await db.insert('$_userTableName', {
      '$_idColumnName': 1,
      '$_userAvrCycleLengthColumnName': 28,
      '$_createdTableColumnName': DateTime.now().toIso8601String(),
      '$_userUpdatedTableColumnName': DateTime.now().toIso8601String(),
    });

    await db.execute('''
    CREATE TABLE $_healthTableName(
    
    $_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
    $_dateColumnName TEXT NOT NULL UNIQUE,
    $_stepColumnName INTEGER,
    $_basalTempColumnName REAL,
    $_hrvColumnName REAL,
    $_restHeartRateColumnName INTEGER,
    $_sleepHoursColumnName REAL,
    $_sleepQualityColumnName INTEGER CHECK ($_sleepQualityColumnName BETWEEN 1 AND 5),
    $_readinessColumnName INTEGER CHECK ($_readinessColumnName BETWEEN 0 AND 100),
    $_createdTableColumnName TEXT NOT NULL,
    user_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES $_userTableName($_idColumnName)
    )
''');
    await db.execute(
      'CREATE INDEX idx_health_table_date ON $_healthTableName($_dateColumnName)',
    );

    await db.execute('''
        CREATE TABLE $_cycleTableName(
  
        $_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
        $_dateColumnName TEXT NOT NULL,
        $_cycleEventTypeColumnName TEXT NOT NULL CHECK(
          $_cycleEventTypeColumnName IN(
            'period_start',
            'period_end',
            'ovulation_predicted',
            'ovulation_confirmed',
            'fertile_window',
            'user_event'
          )
          
        ),
        $_predictionColumnName INTEGER,
        $_confidenceColumnName REAL CHECK ($_confidenceColumnName BETWEEN 0.0 AND 1.0),
        $_notesColumnName TEXT,
        $_createdTableColumnName TEXT NOT NULL,
        title TEXT,
        user_id INTEGER,
        FOREIGN KEY(user_id) REFERENCES $_userTableName($_idColumnName)
      )
''');
    await db.execute(
      'CREATE INDEX idx_cycle_table_date ON $_cycleTableName($_dateColumnName)',
    );
    await db.execute('''
    CREATE TABLE symptoms (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      symptom_type TEXT NOT NULL,
      category TEXT NOT NULL CHECK (
        category IN ('physical','mood','other')
      ),
      intensity INTEGER NOT NULL CHECK (intensity BETWEEN 1 AND 5),
      notes TEXT,
      created_at TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE calendar_notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      created_at TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE sync_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sync_start TEXT NOT NULL,
      sync_end TEXT,
      records_synced INTEGER DEFAULT 0,
      status TEXT NOT NULL CHECK (
        status IN ('in_progress','completed','failed')
      ),
      error_message TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE ovulation_days (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      title TEXT NOT NULL
      
    )
  ''');
    await db.execute('''
    CREATE TABLE menstruation_days (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      title TEXT NOT NULL
      
    )
  ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE health_metrics ADD COLUMN test TEXT');
    }
  }
}
