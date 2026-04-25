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
    final profileImage = _extractProfileImage(json);

    return UserProfileModel(
      id: (json['id'] ?? '').toString(),
      firstName: firstName,
      lastName: lastName,
      name: fullName.isNotEmpty ? fullName : (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      profileImage: profileImage,
      lastTestDate: json['lastTestDate'],
      colorblindnessType: json['colorblindnessType'],
      testDescription: json['testDescription'],
    );
  }

  static String? _extractProfileImage(Map<String, dynamic> json) {
    const imageKeys = [
      'profilePictureUrl',
      'profileImage',
      'imageUrl',
      'pictureUrl',
      'avatar',
      'photoUrl',
    ];

    for (final key in imageKeys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    final nestedData = json['data'];
    if (nestedData is Map<String, dynamic>) {
      for (final key in imageKeys) {
        final value = nestedData[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
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
