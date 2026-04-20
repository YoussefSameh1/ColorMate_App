class VerifyEmailState {
  const VerifyEmailState({
    required this.isVerifying,
    required this.isResending,
    required this.isVerified,
    this.successMessage,
    this.errorMessage,
  });

  factory VerifyEmailState.initial() {
    return const VerifyEmailState(
      isVerifying: false,
      isResending: false,
      isVerified: false,
    );
  }

  final bool isVerifying;
  final bool isResending;
  final bool isVerified;
  final String? successMessage;
  final String? errorMessage;

  VerifyEmailState copyWith({
    bool? isVerifying,
    bool? isResending,
    bool? isVerified,
    String? successMessage,
    String? errorMessage,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    return VerifyEmailState(
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      isVerified: isVerified ?? this.isVerified,
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
