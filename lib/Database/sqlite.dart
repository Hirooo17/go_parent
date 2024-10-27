// ignore_for_file: non_constant_identifier_names

import 'package:go_parent/Database/Mission/mission_db_required.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseService {
  Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String table_name = "tasks";
  final String idColumnname = "id";
  final String ContentColumnname = "content";
  final String statusColumnname = "status";


  DatabaseService._constructor();

  Future<Database> get database async{
      if(_db != null) return _db!;
      _db = await getDatabase();
      return _db!;
  }



  Future<Database> getDatabase() async {
    final dataBaseDirPath = await getDatabasesPath();

    final databasePath = join(dataBaseDirPath, "master_db.db");

    final database = await
     openDatabase(
      databasePath,
      version: 1,
       onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $table_name (
        $idColumnname INTEGER PRIMARY KEY,
        $ContentColumnname TEXT NOT NULL,
        $statusColumnname INTEGER NOT NULL
        )
        ''');
    });
    return database;
  }


  void addTask(
    String content,

  )async{
final db = await database;
    await db.insert(table_name, {
      ContentColumnname : content, 
      statusColumnname : 0,
    }
    );

  }

  Future<List<Missions>?> getTask() async {
  final db = await database;
  final data = await db.query(table_name);  // Await the query to avoid errors
  List<Missions> tasks = data.map((e) => Missions(
    id: e["id"] as int,
    status: e["status"] as int,
    content: e["content"] as String
  )).toList();  // Complete the map with .toList()
  
  return tasks;  // Return the list of tasks
}

}
