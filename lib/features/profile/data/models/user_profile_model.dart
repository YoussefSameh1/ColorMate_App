class UserProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String? lastTestDate;
  final String? colorblindnessType;
  final String? testDescription;

  UserProfileModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    required this.name,
    required this.email,
    this.phoneNumber = '',
    this.profileImage,
    this.lastTestDate,
    this.colorblindnessType,
    this.testDescription,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final firstName = (json['firstName'] ?? '').toString();
    final lastName = (json['lastName'] ?? '').toString();
    final fullName = '$firstName $lastName'.trim();

    return UserProfileModel(
      id: (json['id'] ?? '').toString(),
      firstName: firstName,
      lastName: lastName,
      name: fullName.isNotEmpty ? fullName : (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      profileImage: json['profilePictureUrl'] ?? json['profileImage'],
      lastTestDate: json['lastTestDate'],
      colorblindnessType: json['colorblindnessType'],
      testDescription: json['testDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profileImage,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImage,
    String? lastTestDate,
    String? colorblindnessType,
    String? testDescription,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      lastTestDate: lastTestDate ?? this.lastTestDate,
      colorblindnessType: colorblindnessType ?? this.colorblindnessType,
      testDescription: testDescription ?? this.testDescription,
    );
  }
}
