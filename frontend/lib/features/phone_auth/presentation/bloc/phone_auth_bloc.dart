// features/phone_auth/presentation/bloc/phone_auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/services/auth_service.dart';
import '../../data/datasources/phone_auth_remote_datasource.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthRemoteDataSource remoteDataSource;

  PhoneAuthBloc({required this.remoteDataSource})
      : super(PhoneAuthState.initial()) {
    on<PhoneAuthOtpRequested>(_onOtpRequested);
    on<PhoneAuthOtpVerified>(_onOtpVerified);
    on<PhoneAuthGoogleRequested>(_onGoogleRequested);
    on<PhoneAuthAppleRequested>(_onAppleRequested);
    on<PhoneAuthGithubRequested>(_onGithubRequested);
  }

  Future<void> _onOtpRequested(
      PhoneAuthOtpRequested event,
      Emitter<PhoneAuthState> emit,
      ) async {
    emit(state.copyWith(status: PhoneAuthStatus.sendingOtp));

    try {
    /*  final result = await remoteDataSource.sendOtp(
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
      );

      // ✅ Save user ID after successful login
      await AuthService.setCurrentUserId(result['user']['id']);
      await AuthService.setUserToken(result['token']);

      */
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(
        status: PhoneAuthStatus.otpSent,
        verificationId: 'mock_verification_id',//result.verificationId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'Failed to send OTP. Please try again.',
      ));
    }
  }

  Future<void> _onOtpVerified(
      PhoneAuthOtpVerified event,
      Emitter<PhoneAuthState> emit,
      ) async {

    emit(state.copyWith(status: PhoneAuthStatus.verifyingOtp));

    try {

      /*final result = await remoteDataSource.verifyOtp(
        verificationId: state.verificationId!,
        otp: event.otp,
      );*/
      await Future.delayed(const Duration(seconds: 2));


      emit(state.copyWith(
        status: PhoneAuthStatus.authenticated,
        token: 'sample_token',//result['token'] as String,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'Invalid OTP. Please try again.',
      ));
    }
  }

  Future<void> _onGoogleRequested(
      PhoneAuthGoogleRequested event,
      Emitter<PhoneAuthState> emit,
      ) async {
    emit(state.copyWith(status: PhoneAuthStatus.verifyingOtp));

    try {
      final result = await remoteDataSource.loginWithGoogle();

      emit(state.copyWith(
        status: PhoneAuthStatus.authenticated,
        token: result['token'] as String,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'Google sign-in failed. Please try again.',
      ));
    }
  }

  Future<void> _onAppleRequested(
      PhoneAuthAppleRequested event,
      Emitter<PhoneAuthState> emit,
      ) async {
    emit(state.copyWith(status: PhoneAuthStatus.verifyingOtp));

    try {
      final result = await remoteDataSource.loginWithApple();

      emit(state.copyWith(
        status: PhoneAuthStatus.authenticated,
        token: result['token'] as String,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'Apple sign-in failed. Please try again.',
      ));
    }
  }

  Future<void> _onGithubRequested(
      PhoneAuthGithubRequested event,
      Emitter<PhoneAuthState> emit,
      ) async {
    emit(state.copyWith(status: PhoneAuthStatus.verifyingOtp));

    try {
      final result = await remoteDataSource.loginWithGithub();

      emit(state.copyWith(
        status: PhoneAuthStatus.authenticated,
        token: result['token'] as String,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'GitHub sign-in failed. Please try again.',
      ));
    }
  }
}
