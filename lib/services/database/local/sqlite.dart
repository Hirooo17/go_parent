// ignore_for_file: non_constant_identifier_names
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io' show Directory, Platform;

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;
  static bool _initialized = false;

  factory DatabaseService() {
    return instance;
  }

  DatabaseService._internal();

  // Initialize the database service
  static Future<void> initialize() async {
    if (_initialized) return;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize FFI for desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    _initialized = true;
  }

  Future<Database> get database async {
    if (!_initialized) {
      await initialize();
    }
    
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'goparent.db');
    
    // Ensure the directory exists
    await Directory(dirname(path)).create(recursive: true);

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
        email TEXT NOT NULL UNIQUE,
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
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES userdb(userId) ON DELETE CASCADE
      )
    ''');
   

    // missions
    await db.execute('''
      CREATE TABLE missionsdb (
        missionId INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        content TEXT NOT NULL,
        isCompleted BOOLEAN DEFAULT 0,
        minAge INTEGER NOT NULL,
        maxAge INTEGER NOT NULL
      )
    ''');
   

    // pictures
    await db.execute('''
      CREATE TABLE picturesdb (
        pictureId INTEGER PRIMARY KEY AUTOINCREMENT,
        missionId INTEGER NOT NULL,
        photoContent TEXT NOT NULL,
        isCollage BOOLEAN DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (missionId) REFERENCES missionsdb(missionId) ON DELETE CASCADE
      )
    ''');
   

    // collage
    await db.execute('''
      CREATE TABLE collagedb (
        collageId INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        collageData TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // collage_pictures with improved join performance
    await db.execute('''
      CREATE TABLE collage_pictures (
        collageId INTEGER NOT NULL,
        pictureId INTEGER NOT NULL,
        FOREIGN KEY (collageId) REFERENCES collagedb(collageId) ON DELETE CASCADE,
        FOREIGN KEY (pictureId) REFERENCES picturesdb(pictureId) ON DELETE CASCADE,
        PRIMARY KEY (collageId, pictureId)
      )
    ''');
   

    // rewards
    await db.execute('''
      CREATE TABLE rewardsdb (
        rewardId INTEGER PRIMARY KEY AUTOINCREMENT,
        pointsRequired INTEGER NOT NULL,
        rewardType TEXT NOT NULL,
        rewardData TEXT NOT NULL
      )
    ''');
  

    // user rewards tracker with optimized querying
    await db.execute('''
      CREATE TABLE user_rewards (
        userId INTEGER NOT NULL,
        rewardId INTEGER NOT NULL,
        isUnlocked BOOLEAN DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES userdb(userId) ON DELETE CASCADE,
        FOREIGN KEY (rewardId) REFERENCES rewardsdb(rewardId) ON DELETE CASCADE,
        PRIMARY KEY (userId, rewardId)
      )
    ''');
    

    // notes with full-text search capability
    await db.execute('''
      CREATE TABLE notesdb (
        noteId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES userdb(userId) ON DELETE CASCADE
      )
    ''');
  
    
    
  }

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

  

  // Clean up resources
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  
}