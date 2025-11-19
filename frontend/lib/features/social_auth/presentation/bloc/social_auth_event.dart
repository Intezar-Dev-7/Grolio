// social_auth/presentation/bloc/social_auth_event.dart
import 'package:equatable/equatable.dart';

abstract class SocialAuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SocialAppStarted extends SocialAuthEvent {}

class SocialLoginWithProvider extends SocialAuthEvent {
  final String provider; // Google or Github

  SocialLoginWithProvider(this.provider);

  @override
  List<Object?> get props => [provider];
}

// When the app receivces a deep link like grolio://auth?accessToken=...&sessionId=..
class SocialReceivedDeepLink extends SocialAuthEvent {
  final Uri uri;
  SocialReceivedDeepLink(this.uri);
  @override
  List<Object?> get props => [uri.toString()];
}

class SocialLogout extends SocialAuthEvent {}
