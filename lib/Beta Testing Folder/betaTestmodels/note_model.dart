class NoteModel {
  final int? noteId;
  final int userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    this.noteId,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'userId': userId,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      noteId: map['noteId'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  NoteModel copyWith({
    int? noteId,
    int? userId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      noteId: noteId ?? this.noteId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}