class RewardModel {
  final int? rewardId;
  final String rewardName;
  final String description;
  final int pointsRequired;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  RewardModel({
    this.rewardId,
    required this.rewardName,
    required this.description,
    required this.pointsRequired,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RewardModel.fromMap(Map<String, dynamic> map) {
    return RewardModel(
      rewardId: map['rewardId'],
      rewardName: map['rewardName'],
      description: map['description'],
      pointsRequired: map['pointsRequired'],
      isAvailable: map['isAvailable'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rewardId': rewardId,
      'rewardName': rewardName,
      'description': description,
      'pointsRequired': pointsRequired,
      'isAvailable': isAvailable ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
