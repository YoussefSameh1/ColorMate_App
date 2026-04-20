class LoginRequestModel {
  const LoginRequestModel({
    required this.userNameOrEmail,
    required this.password,
    required this.remmberMe,
  });

  final String userNameOrEmail;
  final String password;
  final bool remmberMe;

  Map<String, dynamic> toJson() {
    return {
      'userNameOrEmail': userNameOrEmail,
      'password': password,
      'remmberMe': remmberMe,
    };
  }
}
