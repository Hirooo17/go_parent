class MissionModel {
  final int? missionId;
  final String title;
  final String category;
  final String content;
  final String level;
  final int? taskId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MissionModel({
    this.missionId,
    required this.title,
    required this.category,
    required this.content,
    required this.level,
    this.taskId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MissionModel.fromMap(Map<String, dynamic> map) {
    return MissionModel(
      missionId: map['missionId'],
      title: map['title'],
      category: map['category'],
      content: map['content'],
      level: map['level'],
      taskId: map['taskId'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'missionId': missionId,
      'title': title,
      'category': category,
      'content': content,
      'level': level,
      'taskId': taskId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
