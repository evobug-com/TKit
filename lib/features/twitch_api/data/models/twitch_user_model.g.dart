// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchUserModel _$TwitchUserModelFromJson(Map<String, dynamic> json) =>
    TwitchUserModel(
      id: json['id'] as String,
      login: json['login'] as String,
      displayName: json['display_name'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      email: json['email'] as String?,
      broadcasterType: json['broadcaster_type'] as String?,
    );

Map<String, dynamic> _$TwitchUserModelToJson(TwitchUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'display_name': instance.displayName,
      'profile_image_url': instance.profileImageUrl,
      'email': instance.email,
      'broadcaster_type': instance.broadcasterType,
    };
