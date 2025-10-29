// features/authentication/presentation/bloc/auth_state.dart (Update state)

part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String email;
  final String password;
  final String confirmPassword;
  final String username;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isUsernameValid;
  final bool isSignUpMode;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.username = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isConfirmPasswordValid = false,
    this.isUsernameValid = false,
    this.isSignUpMode = false,
  });

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
    );
  }

  bool get isSignInFormValid => isEmailValid && isPasswordValid;

  bool get isSignUpFormValid =>
      isEmailValid &&
          isPasswordValid &&
          isConfirmPasswordValid &&
          isUsernameValid &&
          password == confirmPassword;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? email,
    String? password,
    String? confirmPassword,
    String? username,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isUsernameValid,
    bool? isSignUpMode,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      username: username ?? this.username,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isSignUpMode: isSignUpMode ?? this.isSignUpMode,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    email,
    password,
    confirmPassword,
    username,
    isPasswordVisible,
    isConfirmPasswordVisible,
    isEmailValid,
    isPasswordValid,
    isConfirmPasswordValid,
    isUsernameValid,
    isSignUpMode,
  ];
}
