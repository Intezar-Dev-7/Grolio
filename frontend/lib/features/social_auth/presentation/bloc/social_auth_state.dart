// social_auth/presentation/bloc/social_auth_state.dart
import 'package:equatable/equatable.dart';

abstract class SocialAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SocialAuthInitial extends SocialAuthState {}

class SocialAuthLoading extends SocialAuthState {}

class SocialAuthAuthenticated extends SocialAuthState {
  final String acessToken;
  final String sessionid;

  SocialAuthAuthenticated({required this.acessToken, required this.sessionid});
  @override
  List<Object?> get props => [acessToken, sessionid];
}

class SocialAuthUnauthenticated extends SocialAuthState {}

class SocialAuthError extends SocialAuthState {
  final String message;
  SocialAuthError(this.message);
  @override
  List<Object?> get props => [message];
}
