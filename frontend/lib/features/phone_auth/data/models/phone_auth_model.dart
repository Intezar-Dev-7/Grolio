// features/phone_auth/data/models/phone_auth_model.dart

import '../../domain/entities/phone_auth_entity.dart';

class PhoneAuthModel {
  final String phoneNumber;
  final String countryCode;
  final String? verificationId;

  PhoneAuthModel({
    required this.phoneNumber,
    required this.countryCode,
    this.verificationId,
  });

  factory PhoneAuthModel.fromJson(Map<String, dynamic> json) {
    return PhoneAuthModel(
      phoneNumber: json['phone_number'] as String,
      countryCode: json['country_code'] as String,
      verificationId: json['verification_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'country_code': countryCode,
      'verification_id': verificationId,
    };
  }

  PhoneAuthEntity toEntity() {
    return PhoneAuthEntity(
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      verificationId: verificationId,
    );
  }
}
