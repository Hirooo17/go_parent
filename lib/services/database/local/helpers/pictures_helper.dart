import 'package:sqflite/sqflite.dart';
import 'package:go_parent/services/database/local/models/pictures_model.dart';

class PictureHelper {
  final Database db;

  PictureHelper(this.db);

  /// Insert a new picture into the database
  Future<int> insertPicture(PictureModel picture) async {
    return await db.insert(
      'picturesdb',
      picture.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a picture by ID
  Future<PictureModel?> getPictureById(int pictureId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'picturesdb',
      where: 'pictureId = ?',
      whereArgs: [pictureId],
    );

    if (result.isNotEmpty) {
      return PictureModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all pictures
  Future<List<PictureModel>> getAllPictures() async {
    final List<Map<String, dynamic>> result = await db.query('picturesdb');

    return result.map((map) => PictureModel.fromMap(map)).toList();
  }

  /// Retrieve all pictures for a specific task
  Future<List<PictureModel>> getPicturesByTaskId(int taskId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'picturesdb',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );

    return result.map((map) => PictureModel.fromMap(map)).toList();
  }

  /// Retrieve pictures that are marked as part of a collage
  Future<List<PictureModel>> getPicturesForCollage() async {
    final List<Map<String, dynamic>> result = await db.query(
      'picturesdb',
      where: 'isCollage = 1',
    );

    return result.map((map) => PictureModel.fromMap(map)).toList();
  }

  /// Update picture details
  Future<int> updatePicture(PictureModel picture) async {
    return await db.update(
      'picturesdb',
      picture.toMap(),
      where: 'pictureId = ?',
      whereArgs: [picture.pictureId],
    );
  }

  /// Mark a picture as part of a collage
  Future<int> markAsCollage(int pictureId) async {
    return await db.update(
      'picturesdb',
      {'isCollage': 1},
      where: 'pictureId = ?',
      whereArgs: [pictureId],
    );
  }

  /// Delete a picture by ID
  Future<int> deletePicture(int pictureId) async {
    return await db.delete(
      'picturesdb',
      where: 'pictureId = ?',
      whereArgs: [pictureId],
    );
  }

  /// Count total pictures for a task
  Future<int> countPicturesByTaskId(int taskId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM picturesdb WHERE taskId = ?',
      [taskId],
    );

    return result.first['count'] as int;
  }

  /// Count total pictures marked for a collage
  Future<int> countPicturesForCollage() async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM picturesdb WHERE isCollage = 1',
    );

    return result.first['count'] as int;
  }
}
