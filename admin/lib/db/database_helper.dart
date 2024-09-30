import 'package:admin/models/meet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'meet.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE meets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      password TEXT,
      enableOtherLightColors INTEGER,
      startDateTime TEXT,
      exitDateTime TEXT
    )
    ''');
  }

  Future<int> insertMeet(Meet meet) async {
    final db = await database;
    return await db.insert('meets', meet.toJson());
  }

  Future<List<Meet>> getAllMeets() async {
    final db = await database;
    final records = await db.query('meets');
    return records.map(Meet.fromJson).toList();
  }

  Future<void> updateMeet(Meet meet) async {
    final db = await database;
    await db.update(
      'meets',
      meet.toJson(),
      where: 'id = ?',
      whereArgs: [meet.id],
    );
  }

  Future<Meet?> checkUnclosedMeet() async {
    final db = await database;
    final records = await db.rawQuery(
      'SELECT * FROM meets WHERE exitDateTime IS NULL ORDER BY startDateTime DESC LIMIT 1',
    );
    if (records.isNotEmpty) {
      return Meet.fromJson(records[0]);
    }
    return null;
  }
}
