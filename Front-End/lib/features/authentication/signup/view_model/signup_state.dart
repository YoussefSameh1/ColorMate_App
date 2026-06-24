class SignupState {
  const SignupState({
    required this.isLoading,
    required this.isSuccess,
    this.successMessage,
    this.errorMessage,
  });

  factory SignupState.initial() {
    return const SignupState(isLoading: false, isSuccess: false);
  }

  final bool isLoading;
  final bool isSuccess;
  final String? successMessage;
  final String? errorMessage;

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
