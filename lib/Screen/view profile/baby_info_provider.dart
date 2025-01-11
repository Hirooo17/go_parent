import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:go_parent/services/database/local/models/baby_model.dart';

import '../../services/database/local/helpers/baby_helper.dart';

class BabyInfoProvider {
  final Database db;
  final BabyHelper babyHelper;

  BabyInfoProvider(this.db) : babyHelper = BabyHelper(db);

  // Add multiple babies at once (for the profile edit screen)
  Future<List<int>> addMultipleBabies(List<Map<String, dynamic>> childrenData, int userId) async {
    List<int> addedBabyIds = [];
    
    await db.transaction((txn) async {
      for (var childData in childrenData) {
        final baby = BabyModel(
          userId: userId,
          babyAge: int.parse(childData['age']),
          babyGender: 'Unknown', // You might want to add gender selection in your UI
          babyName: childData['name'],
        );
        
        final id = await txn.insert(
          'babydb',
          baby.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        addedBabyIds.add(id);
      }
    });
    
    return addedBabyIds;
  }

  // Update multiple babies at once
  Future<void> updateMultipleBabies(List<Map<String, dynamic>> childrenData, int userId) async {
    await db.transaction((txn) async {
      // First, get existing babies for this user
      final existingBabies = await babyHelper.getBabiesByUserId(userId);
      final existingBabyIds = existingBabies.map((b) => b.babyId!).toList();
      
      // Update or insert each child
      for (var childData in childrenData) {
        if (childData.containsKey('babyId')) {
          // Update existing baby
          final baby = BabyModel(
            babyId: childData['babyId'],
            userId: userId,
            babyAge: int.parse(childData['age']),
            babyGender: childData['gender'] ?? 'Unknown',
            babyName: childData['name'],
          );
          
          await txn.update(
            'babydb',
            baby.toMap(),
            where: 'babyId = ?',
            whereArgs: [baby.babyId],
          );
          
          existingBabyIds.remove(childData['babyId']);
        } else {
          // Insert new baby
          final baby = BabyModel(
            userId: userId,
            babyAge: int.parse(childData['age']),
            babyGender: childData['gender'] ?? 'Unknown',
            babyName: childData['name'],
          );
          
          await txn.insert(
            'babydb',
            baby.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      
      // Delete babies that no longer exist in the updated data
      if (existingBabyIds.isNotEmpty) {
        await txn.delete(
          'babydb',
          where: 'babyId IN (${existingBabyIds.join(',')})',
        );
      }
    });
  }

  // Get formatted children data for the profile edit screen
  Future<List<Map<String, dynamic>>> getFormattedChildrenData(int userId) async {
    final babies = await babyHelper.getBabiesByUserId(userId);
    
    return babies.map((baby) => {
      'babyId': baby.babyId,
      'name': baby.babyName,
      'age': baby.babyAge.toString(),
      'gender': baby.babyGender,
      'key': UniqueKey(),
    }).toList();
  }

  // Save profile changes
  Future<void> saveProfileChanges(int userId, List<Map<String, dynamic>> childrenData) async {
    await updateMultipleBabies(childrenData, userId);
  }

  // Validate baby data
  bool validateBabyData(Map<String, dynamic> childData) {
    return childData['name'].toString().isNotEmpty && 
           childData['age'].toString().isNotEmpty &&
           int.tryParse(childData['age'].toString()) != null;
  }
  Future<int> insertPartialBaby({
  required int userId,
  required int babyAge,
  required String babyName,
  String babyGender = "Unknown", // Default value
}) async {
  BabyModel baby = BabyModel(
    userId: userId,
    babyAge: babyAge,
    babyGender: babyGender,
    babyName: babyName,
  );
  return await db.insert(
    'babydb',
    baby.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
}