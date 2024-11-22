import 'package:sqflite/sqflite.dart';
import 'package:go_parent/Database/Models/tasks_model.dart';

class TaskHelper {
  final Database db;

  TaskHelper(this.db);

  /// Insert a new task into the database
  Future<int> insertTask(TaskModel task) async {
    return await db.insert(
      'tasksdb',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a task by ID
  Future<TaskModel?> getTaskById(int taskId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'tasksdb',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );

    if (result.isNotEmpty) {
      return TaskModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all tasks
  Future<List<TaskModel>> getAllTasks() async {
    final List<Map<String, dynamic>> result = await db.query('tasksdb');

    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  /// Retrieve tasks by missionId
  Future<List<TaskModel>> getTasksByMissionId(int missionId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'tasksdb',
      where: 'missionId = ?',
      whereArgs: [missionId],
    );

    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  /// Retrieve completed or pending tasks
  Future<List<TaskModel>> getTasksByCompletionStatus(bool isCompleted) async {
    final List<Map<String, dynamic>> result = await db.query(
      'tasksdb',
      where: 'isCompleted = ?',
      whereArgs: [isCompleted ? 1 : 0],
    );

    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  /// Mark a task as completed
  Future<int> markTaskAsCompleted(int taskId) async {
    return await db.update(
      'tasksdb',
      {'isCompleted': 1},
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  /// Update task details
  Future<int> updateTask(TaskModel task) async {
    return await db.update(
      'tasksdb',
      task.toMap(),
      where: 'taskId = ?',
      whereArgs: [task.taskId],
    );
  }

  /// Delete a task by ID
  Future<int> deleteTask(int taskId) async {
    return await db.delete(
      'tasksdb',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  /// Count total tasks by missionId
  Future<int> countTasksByMissionId(int missionId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasksdb WHERE missionId = ?',
      [missionId],
    );

    return result.first['count'] as int;
  }

  /// Count completed tasks by missionId
  Future<int> countCompletedTasksByMissionId(int missionId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasksdb WHERE missionId = ? AND isCompleted = 1',
      [missionId],
    );

    return result.first['count'] as int;
  }
}
