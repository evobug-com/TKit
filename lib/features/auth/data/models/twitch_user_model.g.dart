// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchUserModel _$TwitchUserModelFromJson(Map<String, dynamic> json) =>
    TwitchUserModel(
      id: json['id'] as String,
      login: json['login'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$TwitchUserModelToJson(TwitchUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'email': instance.email,
    };
