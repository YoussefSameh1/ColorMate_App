class SignupRequestModel {
  const SignupRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePictureUrl,
    required this.userName,
    required this.password,
    required this.confirmPassword,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String profilePictureUrl;
  final String userName;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'userName': userName,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
