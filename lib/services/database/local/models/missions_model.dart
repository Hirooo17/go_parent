class MissionModel {
  final int? missionId;
  final String title;
  final String category;
  final String content;
  final bool isCompleted;
  final int minAge;
  final int maxAge;
  final DateTime createdAt;
  final DateTime updatedAt;

  MissionModel({
    this.missionId,
    required this.title,
    required this.category,
    required this.content,
    required this.isCompleted,
    required this.minAge,
    required this.maxAge,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MissionModel.fromMap(Map<String, dynamic> map) {
    print("Parsing MissionModel from map: $map");
    return MissionModel(
      missionId: map['missionId'],
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      content: map['content'] ?? '',
      isCompleted: map['isCompleted'] == 0,
      minAge: map['minAge'] ?? 0,
      maxAge: map['maxAge'] ?? 0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'missionId': missionId,
      'title': title,
      'category': category,
      'content': content,
      'isCompleted': isCompleted ? 0 : 1,
      'minAge': minAge,
      'maxAge': maxAge,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
