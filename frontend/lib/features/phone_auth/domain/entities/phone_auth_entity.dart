// features/phone_auth/domain/entities/phone_auth_entity.dart

import 'package:equatable/equatable.dart';

class PhoneAuthEntity extends Equatable {
  final String phoneNumber;
  final String countryCode;
  final String? verificationId;

  const PhoneAuthEntity({
    required this.phoneNumber,
    required this.countryCode,
    this.verificationId,
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode, verificationId];
}

class OtpVerificationEntity extends Equatable {
  final String verificationId;
  final String otp;

  const OtpVerificationEntity({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [verificationId, otp];
}
