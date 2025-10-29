// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignUpRequestModelImpl _$$SignUpRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$SignUpRequestModelImpl(
  email: json['email'] as String,
  password: json['password'] as String,
  displayName: json['display_name'] as String,
);

Map<String, dynamic> _$$SignUpRequestModelImplToJson(
  _$SignUpRequestModelImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'display_name': instance.displayName,
};
