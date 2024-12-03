class LogModel {
  final int? logId;
  final int userId;
  final String action;
  final int? targetId;
  final DateTime timestamp;

  LogModel({
    this.logId,
    required this.userId,
    required this.action,
    this.targetId,
    required this.timestamp,
  });

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      logId: map['logId'],
      userId: map['userId'],
      action: map['action'],
      targetId: map['targetId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'logId': logId,
      'userId': userId,
      'action': action,
      'targetId': targetId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
