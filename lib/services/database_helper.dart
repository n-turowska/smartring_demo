import 'package:smartring_demo/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  final String _cycleTableName = 'cycle_events';
  final String _cycleIdColumnName = 'id';
  final String _cycleDateColumnName = 'date';
  final String _cycleEventTypeColumnName = 'event_type';
  static Database? _db;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _getDatabase();
    return _db!;
  }

  Future<Database> _getDatabase() async {
    //asynchroniczna, nie zwraca od razu->od razu zwraca future, czyli cos co w przyszlosci bedzie
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "MiraRing.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDB,
    );
    return database;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $_cycleTableName(
        $_cycleIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
        $_cycleDateColumnName TEXT NOT NULL,
        $_cycleEventTypeColumnName TEXT NOT NULL CHECK(
          $_cycleEventTypeColumnName IN(
            'period_start',
            'period_end',
            'ovulation_predicted',
            'ovulation_confirmed',
            'fertile_window'
            'user_event'
          )
        ),
        title TEXT
      )
''');
  }
}
