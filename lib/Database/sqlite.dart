// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_parent/Database/Mission/mission_db_required.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String table_name = "tasks";
  final String idColumnname = "id";
  final String ContentColumnname = "content";
  final String statusColumnname = "status";
  final String usersTable = 'users_table';
  final String userEmailColumn = 'useremail';
  final String userPasswordColumn = 'userpassword';

  DatabaseService._constructor();
  Future<Database> get database async{
      if(_db != null) return _db!;
      _db = await getDatabase();
      return _db!;
  }


//refactored but same functionality
Future<Database> getDatabase() async {
  final databasePath = join(await getDatabasesPath(), "master_db.db");

  final database = await openDatabase(
    databasePath,
    version: 1,
    //first table for mission
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $table_name (
          $idColumnname INTEGER PRIMARY KEY,
          $ContentColumnname TEXT NOT NULL,
          $statusColumnname INTEGER NOT NULL
        )
      ''');

     // Create the second table (users)
      await db.execute('''
        CREATE TABLE $usersTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          $userEmailColumn TEXT NOT NULL,
          $userPasswordColumn TEXT NOT NULL
        )
      ''');
    },
  );
  return database;
}


  void addTask( String content ) async{
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


class UserModel {
  final String useremail;
  final String userpassword;

  const UserModel({
    required this.useremail,
    required this.userpassword,
  });

  Map<String, Object?> toMap() {
    return {
      'useremail': useremail,
      'userpassword': userpassword,
    };
  }


  @override
  String toString() {
    return 'UserModel{useremail: $useremail, userpassword: $userpassword}';
  }
}


Future<void> insertUser(UserModel user) async {
  try {
    // Get a reference to the database using the singleton instance
    final db = await DatabaseService.instance.database;

    // Insert the user data into the users_table
    await db.insert(
      DatabaseService.instance.usersTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('User inserted: $user');
  } catch (e) {
    print('Error inserting user: $e');
  }


Future<List<UserModel>> getAllUsers() async {
  try {
    // Get a reference to the database using the singleton instance
    final db = await DatabaseService.instance.database;

    // Query the users_table for all records
    final List<Map<String, dynamic>> userMaps = await db.query(
      DatabaseService.instance.usersTable,
    );

    // Convert the List<Map> to a List<UserModel>
    List<UserModel> users = userMaps.map((userMap) {
      return UserModel(
        useremail: userMap['useremail'] as String,
        userpassword: userMap['userpassword'] as String,
      );
    }).toList();

    return users;
  } catch (e) {
    print('Error retrieving users: $e');
    return [];
  }
}
}

