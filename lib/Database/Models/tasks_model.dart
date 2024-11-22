class TaskModel {
  final int? taskId;
  final int missionId;
  final String content;
  final bool isCompleted;

  TaskModel({
    this.taskId,
    required this.missionId,
    required this.content,
    this.isCompleted = false,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'],
      missionId: map['missionId'],
      content: map['content'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'missionId': missionId,
      'content': content,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
