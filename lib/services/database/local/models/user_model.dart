class UserModel {
  final int? userId;
  final String username;
  final String email;
  final String password;
  final int totalScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    this.totalScore = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      totalScore: map['totalScore'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'password': password,
      'totalScore': totalScore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
