import 'package:sqflite/sqflite.dart';
import 'package:go_parent/Database/Models/collage_model.dart';

class CollageHelper {
  final Database db;

  CollageHelper(this.db);

  /// Insert a new collage into the database
  Future<int> insertCollage(CollageModel collage) async {
    return await db.insert(
      'collagedb',
      collage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a collage by ID
  Future<CollageModel?> getCollageById(int collageId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'collagedb',
      where: 'collageId = ?',
      whereArgs: [collageId],
    );

    if (result.isNotEmpty) {
      return CollageModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all collages
  Future<List<CollageModel>> getAllCollages() async {
    final List<Map<String, dynamic>> result = await db.query('collagedb');

    return result.map((map) => CollageModel.fromMap(map)).toList();
  }

  /// Retrieve all collages that include a specific picture
  Future<List<CollageModel>> getCollagesByPictureId(int pictureId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'collagedb',
      where: 'pictureId = ?',
      whereArgs: [pictureId],
    );

    return result.map((map) => CollageModel.fromMap(map)).toList();
  }

  /// Update collage details
  Future<int> updateCollage(CollageModel collage) async {
    return await db.update(
      'collagedb',
      collage.toMap(),
      where: 'collageId = ?',
      whereArgs: [collage.collageId],
    );
  }

  /// Delete a collage by ID
  Future<int> deleteCollage(int collageId) async {
    return await db.delete(
      'collagedb',
      where: 'collageId = ?',
      whereArgs: [collageId],
    );
  }

  /// Count total collages in the database
  Future<int> countCollages() async {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM collagedb');

    return result.first['count'] as int;
  }

  /// Retrieve collages with a specific title
  Future<List<CollageModel>> getCollagesByTitle(String title) async {
    final List<Map<String, dynamic>> result = await db.query(
      'collagedb',
      where: 'title LIKE ?',
      whereArgs: ['%$title%'],
    );

    return result.map((map) => CollageModel.fromMap(map)).toList();
  }
}
