class CollageModel {
  final int? collageId;
  final int pictureId;
  final String title;
  final String collageData;
  final DateTime createdAt;
  final DateTime updatedAt;

  CollageModel({
    this.collageId,
    required this.pictureId,
    required this.title,
    required this.collageData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CollageModel.fromMap(Map<String, dynamic> map) {
    return CollageModel(
      collageId: map['collageId'],
      pictureId: map['pictureId'],
      title: map['title'],
      collageData: map['collageData'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collageId': collageId,
      'pictureId': pictureId,
      'title': title,
      'collageData': collageData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
