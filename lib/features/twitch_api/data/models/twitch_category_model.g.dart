// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitchCategoryModel _$TwitchCategoryModelFromJson(Map<String, dynamic> json) =>
    TwitchCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      boxArtUrl: json['box_art_url'] as String?,
    );

Map<String, dynamic> _$TwitchCategoryModelToJson(
  TwitchCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'box_art_url': instance.boxArtUrl,
};
