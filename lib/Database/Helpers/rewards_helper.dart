import 'package:sqflite/sqflite.dart';
import 'package:go_parent/Database/Models/rewards_model.dart';

class RewardsHelper {
  final Database db;

  RewardsHelper(this.db);

  /// Insert a new reward into the database
  Future<int> insertReward(RewardModel reward) async {
    return await db.insert(
      'rewardsdb',
      reward.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve a reward by its ID
  Future<RewardModel?> getRewardById(int rewardId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'rewardsdb',
      where: 'rewardId = ?',
      whereArgs: [rewardId],
    );

    if (result.isNotEmpty) {
      return RewardModel.fromMap(result.first);
    }
    return null;
  }

  /// Retrieve all available rewards
  Future<List<RewardModel>> getAllRewards() async {
    final List<Map<String, dynamic>> result = await db.query(
      'rewardsdb',
      where: 'isAvailable = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );

    return result.map((map) => RewardModel.fromMap(map)).toList();
  }

  /// Retrieve all rewards (including unavailable ones)
  Future<List<RewardModel>> getAllRewardsIncludingUnavailable() async {
    final List<Map<String, dynamic>> result = await db.query(
      'rewardsdb',
      orderBy: 'created_at DESC',
    );

    return result.map((map) => RewardModel.fromMap(map)).toList();
  }

  /// Update a reward by its ID
  Future<int> updateReward(RewardModel reward) async {
    return await db.update(
      'rewardsdb',
      reward.toMap(),
      where: 'rewardId = ?',
      whereArgs: [reward.rewardId],
    );
  }

  /// Mark a reward as unavailable
  Future<int> markRewardAsUnavailable(int rewardId) async {
    return await db.update(
      'rewardsdb',
      {'isAvailable': 0},
      where: 'rewardId = ?',
      whereArgs: [rewardId],
    );
  }

  /// Delete a reward by its ID
  Future<int> deleteReward(int rewardId) async {
    return await db.delete(
      'rewardsdb',
      where: 'rewardId = ?',
      whereArgs: [rewardId],
    );
  }

  /// Count the total number of rewards
  Future<int> countRewards() async {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM rewardsdb');
    return result.first['count'] as int;
  }

  /// Retrieve rewards by points requirement
  Future<List<RewardModel>> getRewardsByPoints(int points) async {
    final List<Map<String, dynamic>> result = await db.query(
      'rewardsdb',
      where: 'pointsRequired <= ?',
      whereArgs: [points],
      orderBy: 'pointsRequired ASC',
    );

    return result.map((map) => RewardModel.fromMap(map)).toList();
  }
}
