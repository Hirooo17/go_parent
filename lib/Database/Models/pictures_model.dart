class PictureModel {
  final int? pictureId;
  final int taskId;
  final String photoContent;
  final bool isCollage;
  final DateTime createdAt;

  PictureModel({
    this.pictureId,
    required this.taskId,
    required this.photoContent,
    this.isCollage = false,
    required this.createdAt,
  });

  factory PictureModel.fromMap(Map<String, dynamic> map) {
    return PictureModel(
      pictureId: map['pictureId'],
      taskId: map['taskId'],
      photoContent: map['photoContent'],
      isCollage: map['isCollage'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pictureId': pictureId,
      'taskId': taskId,
      'photoContent': photoContent,
      'isCollage': isCollage ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
