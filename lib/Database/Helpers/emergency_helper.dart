import 'package:sqflite/sqflite.dart';
import 'package:go_parent/Database/Models/emergency_model.dart';

class EmergencySupportHelper {
  final Database db;

  EmergencySupportHelper(this.db);

  /// Insert a new emergency support contact into the database
  Future<int> insertEmergencyContact(EmergencySupportModel contact) async {
    return await db.insert(
      'emergency_supportdb',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve an emergency support contact by its ID
  Future<EmergencySupportModel?> getEmergencyContactById(int supportId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'emergency_supportdb',
      where: 'supportId = ?',
      whereArgs: [supportId],
    );

    if (result.isNotEmpty) {
      return EmergencySupportModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all emergency support contacts
  Future<List<EmergencySupportModel>> getAllEmergencyContacts() async {
    final List<Map<String, dynamic>> result = await db.query(
      'emergency_supportdb',
      orderBy: 'category ASC',
    );

    return result.map((map) => EmergencySupportModel.fromMap(map)).toList();
  }

  /// Update an emergency support contact by its ID
  Future<int> updateEmergencyContact(EmergencySupportModel contact) async {
    return await db.update(
      'emergency_supportdb',
      contact.toMap(),
      where: 'supportId = ?',
      whereArgs: [contact.supportId],
    );
  }

  /// Delete an emergency support contact by its ID
  Future<int> deleteEmergencyContact(int supportId) async {
    return await db.delete(
      'emergency_supportdb',
      where: 'supportId = ?',
      whereArgs: [supportId],
    );
  }

  /// Retrieve all emergency contacts by category
  Future<List<EmergencySupportModel>> getEmergencyContactsByCategory(
      String category) async {
    final List<Map<String, dynamic>> result = await db.query(
      'emergency_supportdb',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'contactName ASC',
    );

    return result.map((map) => EmergencySupportModel.fromMap(map)).toList();
  }

  /// Count the total number of emergency support contacts
  Future<int> countEmergencyContacts() async {
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM emergency_supportdb');
    return result.first['count'] as int;
  }
}
