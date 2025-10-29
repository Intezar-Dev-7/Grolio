// features/authentication/data/models/auth_result_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_result_entity.dart';
import 'user_model.dart';

part 'auth_result_model.freezed.dart';
part 'auth_result_model.g.dart';

@freezed
class AuthResultModel with _$AuthResultModel {
  const AuthResultModel._();

  const factory AuthResultModel({
    required UserModel user,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _AuthResultModel;

  factory AuthResultModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResultModelFromJson(json);

  /// Convert model to entity
  AuthResultEntity toEntity() {
    return AuthResultEntity(
      user: user.toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}
