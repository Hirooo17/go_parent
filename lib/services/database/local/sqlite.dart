// ignore_for_file: non_constant_identifier_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'goparent.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
    Future<void> _onCreate(Database db, int version) async {
    // userdb
    await db.execute('''
      CREATE TABLE userdb (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        totalScore INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // babydb
    await db.execute('''
      CREATE TABLE babydb (
        babyId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        babyAge INTEGER NOT NULL,
        babyGender TEXT NOT NULL,
        babyName TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES userdb(userId)
      )
    ''');

    // missions
    await db.execute('''
      CREATE TABLE missionsdb (
        missionId INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        content TEXT NOT NULL,
        level TEXT NOT NULL,
        taskId INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (taskId) REFERENCES tasksdb(taskId)
      )
    ''');

    // tasksdb
    await db.execute('''
      CREATE TABLE tasksdb (
        taskId INTEGER PRIMARY KEY AUTOINCREMENT,
        missionId INTEGER NOT NULL,
        content TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        FOREIGN KEY (missionId) REFERENCES missionsdb(missionId)
      )
    ''');

    // picturesdb
    await db.execute('''
      CREATE TABLE picturesdb (
        pictureId INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER NOT NULL,
        photoContent TEXT NOT NULL,
        isCollage INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (taskId) REFERENCES tasksdb(taskId)
      )
    ''');

    // collagedb
    await db.execute('''
      CREATE TABLE collagedb (
        collageId INTEGER PRIMARY KEY AUTOINCREMENT,
        pictureId INTEGER NOT NULL,
        title TEXT NOT NULL,
        collageData TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (pictureId) REFERENCES picturesdb(pictureId)
      )
    ''');

    // logsdb (Low Priority)
    await db.execute('''
      CREATE TABLE logsdb (
        logId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        action TEXT NOT NULL,
        targetId INTEGER,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES userdb(userId)
      )
    ''');

    // rewardsdb (Low Priority)
    await db.execute('''
      CREATE TABLE rewardsdb (
        rewardId INTEGER PRIMARY KEY AUTOINCREMENT,
        rewardName TEXT NOT NULL,
        description TEXT NOT NULL,
        pointsRequired INTEGER NOT NULL,
        isAvailable INTEGER DEFAULT 1,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // emergency_supportdb (Low Priority)
    await db.execute('''
      CREATE TABLE emergency_supportdb (
        supportId INTEGER PRIMARY KEY AUTOINCREMENT,
        contactName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

//wafansdanfasdfmdsa

Future<void> listTables() async {
  final db = await DatabaseService.instance.database;
  final result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");

  print("List of tables:");
  for (var table in result) {
    print(table['name']);
  }
}

Future<void> dropTable(String tableName) async {
  final db = await DatabaseService.instance.database;

  try {
    await db.execute("DROP TABLE IF EXISTS $tableName;");
    print("Table '$tableName' dropped successfully.");
  } catch (e) {
    print("Error dropping table '$tableName': $e");
    }
  }
}
