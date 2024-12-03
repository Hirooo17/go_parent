class BabyModel {
  final int? babyId;
  final int userId;
  final int babyAge;
  final String babyGender;
  final String babyName;

  BabyModel({
    this.babyId,
    required this.userId,
    required this.babyAge,
    required this.babyGender,
    required this.babyName,
  });

  factory BabyModel.fromMap(Map<String, dynamic> map) {
    return BabyModel(
      babyId: map['babyId'],
      userId: map['userId'],
      babyAge: map['babyAge'],
      babyGender: map['babyGender'],
      babyName: map['babyName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'babyId': babyId,
      'userId': userId,
      'babyAge': babyAge,
      'babyGender': babyGender,
      'babyName': babyName,
    };
  }
}
