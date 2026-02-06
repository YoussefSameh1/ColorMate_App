class UserProfileModel {
  final String name;
  final String email;
  final String? profileImage;
  final String? lastTestDate;
  final String? colorblindnessType;
  final String? testDescription;

  UserProfileModel({
    required this.name,
    required this.email,
    this.profileImage,
    this.lastTestDate,
    this.colorblindnessType,
    this.testDescription,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      lastTestDate: json['lastTestDate'],
      colorblindnessType: json['colorblindnessType'],
      testDescription: json['testDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'lastTestDate': lastTestDate,
      'colorblindnessType': colorblindnessType,
      'testDescription': testDescription,
    };
  }

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? profileImage,
    String? lastTestDate,
    String? colorblindnessType,
    String? testDescription,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      lastTestDate: lastTestDate ?? this.lastTestDate,
      colorblindnessType: colorblindnessType ?? this.colorblindnessType,
      testDescription: testDescription ?? this.testDescription,
    );
  }
}
