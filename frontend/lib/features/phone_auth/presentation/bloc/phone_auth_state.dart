// features/phone_auth/presentation/bloc/phone_auth_state.dart

part of 'phone_auth_bloc.dart';

enum PhoneAuthStatus {
  initial,
  sendingOtp,
  otpSent,
  verifyingOtp,
  authenticated,
  error,
}

class PhoneAuthState extends Equatable {
  final PhoneAuthStatus status;
  final String? verificationId;
  final String? errorMessage;
  final String? token;

  const PhoneAuthState({
    required this.status,
    this.verificationId,
    this.errorMessage,
    this.token,
  });

  factory PhoneAuthState.initial() {
    return const PhoneAuthState(
      status: PhoneAuthStatus.initial,
    );
  }

  PhoneAuthState copyWith({
    PhoneAuthStatus? status,
    String? verificationId,
    String? errorMessage,
    String? token,
  }) {
    return PhoneAuthState(
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [status, verificationId, errorMessage, token];
}
