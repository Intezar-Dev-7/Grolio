// Purpose

// Handles login events

// Emits loading / success / error

// Talks to usecases
// social_auth/presentation/bloc/social_auth_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/repositories/social_auth_repository.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/login_with_github.dart';
import '../../domain/usecases/refresh_token.dart';
import '../../domain/usecases/logout.dart';
import 'social_auth_event.dart';
import 'social_auth_state.dart';

/// BLoC coordinates:
/// - start OAuth (open URL)
/// - handle ReceivedDeepLink event (store tokens)
/// - refresh tokens when needed (use RefreshToken usecase)
/// - logout

class SocialAuthBloc extends Bloc<SocialAuthEvent, SocialAuthState> {
  final SocialAuthRepository repository;
  final LoginWithGoogle loginWithGoogle;
  final LoginWithGithub loginWithGithub;
  final RefreshToken refreshTokenUseCase;
  final LogoutUseCase logoutUseCase;

  StreamSubscription? _linkSub;

  SocialAuthBloc({
    required this.repository,
    required this.loginWithGoogle,
    required this.loginWithGithub,
    required this.refreshTokenUseCase,
    required this.logoutUseCase,
  }) : super(SocialAuthInitial()) {
    on<SocialAppStarted>(_onAppStarted);
    on<SocialLoginWithProvider>(_onLoginWithProvider);
    on<SocialReceivedDeepLink>(_onReceiveDeepLink);
    on<SocialLogout>(_onLogout);
  }

  Future<void> _onAppStarted(
    SocialAppStarted event,
    Emitter<SocialAuthState> emit,
  ) async {
    emit(SocialAuthLoading());
    try {
      final token = await repository.getAccessToken();
      final session = await repository.getSessionId();
      if (token != null && session != null) {
        emit(SocialAuthAuthenticated(acessToken: token, sessionid: session));
      } else {
        emit(SocialAuthUnauthenticated());
      }
    } catch (e) {
      emit(SocialAuthError('Startup error: $e'));
    }
  }

  Future<void> _onLoginWithProvider(
    SocialLoginWithProvider event,
    Emitter<SocialAuthState> emit,
  ) async {
    emit(SocialAuthLoading());
    try {
      final startUrl = repository.oauthStartUrl(event.provider);
      // Open in external browser - backend will handle OAUTH flow and eventually redirect to dep link
      await launchUrl(startUrl, mode: LaunchMode.externalApplication);
      // Wait for deep link -> handled by SocialReceicedDeepLink event (you must dispatch if from global listner )
      emit(SocialAuthUnauthenticated());
    } catch (e) {
      emit(SocialAuthError('Could not start OAuth: $e'));
    }
  }

  Future<void> _onReceiveDeepLink(
    SocialReceivedDeepLink event,
    Emitter<SocialAuthState> emit,
  ) async {
    emit(SocialAuthLoading());
    try {
      final uri = event.uri;
      final accessToken = uri.queryParameters['accessToken'];
      final sessionId = uri.queryParameters['sessionId'];
      if (accessToken == null || sessionId == null) {
        emit(SocialAuthError('Deep link missing tokens'));
        return;
      }
      // Save securely
      await repository.saveTokens(
        accessToken: accessToken,
        sessionId: sessionId,
      );
      emit(
        SocialAuthAuthenticated(acessToken: accessToken, sessionid: sessionId),
      );
    } catch (e) {
      emit(SocialAuthError('Deep link handling failed: $e'));
    }
  }

  /// Use this to request a new access token using stored sessionId.
  /// On success, repository.saveTokens is called with rotated sessionId.

  Future<bool> tryRefresh() async {
    final sessionId = await repository.getSessionId();
    if (sessionId == null) return false;
    final data = await refreshTokenUseCase.execute(sessionId);
    if (data == null) return false;
    // backend returns { accessToken, sessionId}

    final access = data['accessToken'] as String?;
    final newSession = data['sessionId'] as String?;

    if (access == null || newSession == null) return false;
    await repository.saveTokens(accessToken: access, sessionId: newSession);
    return true;
  }

  Future<void> _onLogout(
    SocialLogout event,
    Emitter<SocialAuthState> emit,
  ) async {
    emit(SocialAuthLoading());
    try {
      final sessionId = await repository.getSessionId();
      await logoutUseCase.execute(sessionId);
    } catch (_) {
      // ignore errors on logout
    } finally {
      await repository.clearTokens();
      emit(SocialAuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _linkSub?.cancel();
    return super.close();
  }
}
