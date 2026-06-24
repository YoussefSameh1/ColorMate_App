class LoginState {
  const LoginState({
    required this.isLoading,
    this.successMessage,
    this.errorMessage,
  });

  factory LoginState.initial() {
    return const LoginState(isLoading: false);
  }

  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  LoginState copyWith({
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
