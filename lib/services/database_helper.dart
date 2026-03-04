import 'package:smartring_demo/services/database_service.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  final String _cycleTableName = 'cycle_events';
  final String _idColumnName = 'id';
  final String _cycleDateColumnName = 'date';
  final String _cycleEventTypeColumnName = 'event_type';
  final String _userTableName = 'user_profile';
  final String _userAvrCycleLengthColumnName = 'average_cycle_length';
  final String _userLastPeriodColumnName = "last_period_start";
  final String _userCreatedTableColumnName = 'created_at';
  final String _userUpdatedTableColumnName = 'updated_at';
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
      version: 1,
      onCreate: _createDB,
    );
    return database;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_userTableName(
    $_idColumnName INTEGER PRIMARY KEY CHECK(id=1),
    $_userAvrCycleLengthColumnName INTEGER DEFAULT 28,
    $_userLastPeriodColumnName TEXT,
    $_userCreatedTableColumnName TEXT NOT NULL,
    $_userUpdatedTableColumnName TEXT NOT NUL
    )
''');
    await db.insert('$_userTableName', {
      '$_idColumnName': 1,
      '$_userAvrCycleLengthColumnName': 28,
      '$_userCreatedTableColumnName': DateTime.now().toIso8601String(),
      '$_userUpdatedTableColumnName': DateTime.now().toIso8601String(),
    });

    await db.execute('''
        CREATE TABLE $_cycleTableName(
        $_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
        $_cycleDateColumnName TEXT NOT NULL,
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
        title TEXT
      )
''');
  }
}
