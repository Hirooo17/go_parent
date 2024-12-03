import 'package:sqflite/sqflite.dart';
import 'package:go_parent/Database/Models/logs_model.dart';

class LogsHelper {
  final Database db;

  LogsHelper(this.db);

  /// Insert a new log into the database
  Future<int> insertLog(LogModel log) async {
    return await db.insert(
      'logsdb',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a log by its ID
  Future<LogModel?> getLogById(int logId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'logsdb',
      where: 'logId = ?',
      whereArgs: [logId],
    );

    if (result.isNotEmpty) {
      return LogModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all logs
  Future<List<LogModel>> getAllLogs() async {
    final List<Map<String, dynamic>> result = await db.query(
      'logsdb',
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => LogModel.fromMap(map)).toList();
  }

  /// Retrieve logs by user ID
  Future<List<LogModel>> getLogsByUserId(int userId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'logsdb',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => LogModel.fromMap(map)).toList();
  }

  /// Retrieve logs by action type
  Future<List<LogModel>> getLogsByAction(String action) async {
    final List<Map<String, dynamic>> result = await db.query(
      'logsdb',
      where: 'action LIKE ?',
      whereArgs: ['%$action%'],
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => LogModel.fromMap(map)).toList();
  }

  /// Delete a log by its ID
  Future<int> deleteLog(int logId) async {
    return await db.delete(
      'logsdb',
      where: 'logId = ?',
      whereArgs: [logId],
    );
  }

  /// Delete all logs for a specific user
  Future<int> deleteLogsByUserId(int userId) async {
    return await db.delete(
      'logsdb',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  /// Count total logs in the database
  Future<int> countLogs() async {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM logsdb');

    return result.first['count'] as int;
  }

  /// Count logs by user ID
  Future<int> countLogsByUserId(int userId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM logsdb WHERE userId = ?',
      [userId],
    );

    return result.first['count'] as int;
  }
}
