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
    String path = join(await getDatabasesPath(), 'goparent_v2.db');
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
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
        isCompleted BOOLEAN DEFAULT 0,
        minAge INTEGER NOT NULL,
        maxAge INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
        FOREIGN KEY (missionId) REFERENCES missionsdb(missionId)
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

    // collage_pictures
    await db.execute('''
      CREATE TABLE collage_pictures (
        collageId INTEGER NOT NULL,
        pictureId INTEGER NOT NULL,
        FOREIGN KEY (collageId) REFERENCES collagesdb(collageId),
        FOREIGN KEY (pictureId) REFERENCES picturesdb(pictureId),
        PRIMARY KEY (collageId, pictureId)
      )
    ''');

    // rewards ../Type of reward (e.g., "collage_style", "badge")
    await db.execute('''
      CREATE TABLE rewardsdb (
        rewardId INTEGER PRIMARY KEY AUTOINCREMENT,
        pointsRequired INTEGER NOT NULL,
        rewardType TEXT NOT NULL,
        rewardData TEXT NOT NULL
      )
    ''');

     // user rewards tracker
    await db.execute('''
      CREATE TABLE user_rewards (
        userId INTEGER NOT NULL,
        rewardId INTEGER NOT NULL,
        isUnlocked BOOLEAN DEFAULT 0, -- Whether the reward is unlocked
        FOREIGN KEY (userId) REFERENCES userdb(userId),
        FOREIGN KEY (rewardId) REFERENCES rewardsdb(rewardId),
        PRIMARY KEY (userId, rewardId)
      )
    ''');

//../commented for now--focus on core functionalities
//     // logs ../unsure about the schema of this.
//     await db.execute('''
//       CREATE TABLE logsdb (
//         logId INTEGER PRIMARY KEY AUTOINCREMENT,
//         userId INTEGER NOT NULL,
//         action TEXT NOT NULL,
//         targetId INTEGER,
//         timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY (userId) REFERENCES userdb(userId)
//       )

//       CREATE TABLE logsdb (
//   logId INTEGER PRIMARY KEY AUTOINCREMENT,
//   userId INTEGER NOT NULL, -- References the user performing the action
//   actionType TEXT NOT NULL, -- Standardized action type (e.g., "create", "delete")
//   targetType TEXT, -- Type of entity affected (e.g., "mission", "picture", "collage")
//   targetId INTEGER, -- ID of the affected entity
//   metadata TEXT, -- Optional JSON data for additional details
//   timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Time of the action
//   FOREIGN KEY (userId) REFERENCES userdb(userId)
// );
//     ''');

    // // emergency_supportdb (Low Priority)
    // await db.execute('''
    //   CREATE TABLE emergency_supportdb (
    //     supportId INTEGER PRIMARY KEY AUTOINCREMENT,
    //     contactName TEXT NOT NULL,
    //     phoneNumber TEXT NOT NULL,
    //     category TEXT NOT NULL
    //   )
    // ''');
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

  Future<List<Map<String, dynamic>>> getUserBabies(int userId) async {
    final db = await database;
    return await db.query('babydb', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getMissionsForAge(int minAge, int maxAge) async {
    final db = await database;
    return await db.query('missionsdb', where: 'minAge <= ? AND maxAge >= ?', whereArgs: [minAge, maxAge]);
  }
}
