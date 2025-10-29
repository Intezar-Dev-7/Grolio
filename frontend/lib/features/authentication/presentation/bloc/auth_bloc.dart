// features/authentication/presentation/bloc/auth_bloc.dart (Update BLoC)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_in_with_github_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignInWithGitHubUseCase signInWithGitHubUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignUpWithEmailUseCase signUpWithEmailUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthBloc({
    required this.signInWithEmailUseCase,
    required this.signInWithGitHubUseCase,
    required this.signInWithGoogleUseCase,
    required this.signUpWithEmailUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<UsernameChanged>(_onUsernameChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<SignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<SignInWithGitHubRequested>(_onSignInWithGitHubRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  void _onEmailChanged(EmailChanged event, Emitter<AuthState> emit) {
    final isValid = Validators.isValidEmail(event.email);
    emit(state.copyWith(
      email: event.email,
      isEmailValid: isValid,
    ));
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
          (_) => emit(state.copyWith(
        status: AuthStatus.initial,
      )),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<AuthState> emit) {
    final isValid = Validators.isValidPassword(event.password);
    emit(state.copyWith(
      password: event.password,
      isPasswordValid: isValid,
    ));
  }

  void _onConfirmPasswordChanged(
      ConfirmPasswordChanged event,
      Emitter<AuthState> emit,
      ) {
    final isValid = event.confirmPassword.isNotEmpty &&
        event.confirmPassword == state.password;
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      isConfirmPasswordValid: isValid,
    ));
  }

  void _onUsernameChanged(UsernameChanged event, Emitter<AuthState> emit) {
    final isValid = Validators.isValidUsername(event.username);
    emit(state.copyWith(
      username: event.username,
      isUsernameValid: isValid,
    ));
  }

  void _onPasswordVisibilityToggled(
      PasswordVisibilityToggled event,
      Emitter<AuthState> emit,
      ) {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    ));
  }

  Future<void> _onSignInWithEmailRequested(
      SignInWithEmailRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await signInWithEmailUseCase(
      SignInWithEmailParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
          (authResult) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: authResult.user,
      )),
    );
  }

  Future<void> _onSignInWithGitHubRequested(
      SignInWithGitHubRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await signInWithGitHubUseCase(NoParams());

    result.fold(
          (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
          (authResult) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: authResult.user,
      )),
    );
  }

  Future<void> _onSignInWithGoogleRequested(
      SignInWithGoogleRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await signInWithGoogleUseCase(NoParams());

    result.fold(
          (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
          (authResult) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: authResult.user,
      )),
    );
  }

  Future<void> _onSignUpWithEmailRequested(
      SignUpWithEmailRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await signUpWithEmailUseCase(
      SignUpWithEmailParams(
        email: event.email,
        password: event.password,
        displayName: event.username,
      ),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
          (authResult) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: authResult.user,
      )),
    );
  }
}
