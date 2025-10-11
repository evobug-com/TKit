// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchTokenModel _$TwitchTokenModelFromJson(Map<String, dynamic> json) =>
    TwitchTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      scopes: (json['scopes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TwitchTokenModelToJson(TwitchTokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'scopes': instance.scopes,
    };
