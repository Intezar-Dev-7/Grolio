part of 'phone_auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object?> get props => [];
}

class PhoneAuthOtpRequested extends PhoneAuthEvent {
  final String phoneNumber;
  final String countryCode;

  const PhoneAuthOtpRequested({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}

class PhoneAuthOtpVerified extends PhoneAuthEvent {
  final String otp;

  const PhoneAuthOtpVerified(this.otp);

  @override
  List<Object?> get props => [otp];
}

class PhoneAuthGoogleRequested extends PhoneAuthEvent {
  const PhoneAuthGoogleRequested();
}

class PhoneAuthAppleRequested extends PhoneAuthEvent {
  const PhoneAuthAppleRequested();
}

class PhoneAuthGithubRequested extends PhoneAuthEvent {
  const PhoneAuthGithubRequested();
}
