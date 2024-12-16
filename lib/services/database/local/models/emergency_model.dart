class EmergencySupportModel {
  final int? supportId;
  final String contactName;
  final String phoneNumber;
  final String category;

  EmergencySupportModel({
    this.supportId,
    required this.contactName,
    required this.phoneNumber,
    required this.category,
  });

  factory EmergencySupportModel.fromMap(Map<String, dynamic> map) {
    return EmergencySupportModel(
      supportId: map['supportId'],
      contactName: map['contactName'],
      phoneNumber: map['phoneNumber'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supportId': supportId,
      'contactName': contactName,
      'phoneNumber': phoneNumber,
      'category': category,
    };
  }
}
