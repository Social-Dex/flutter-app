// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      name: json['name'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '1970-01-01',
      isInRelationship: json['isInRelationship'] as bool? ?? false,
      occupation: json['occupation'] as String? ?? '',
      gender: json['gender'] as String? ?? 'male',
      bio: json['bio'] as String? ?? '',
      avatarSVG: json['avatarSVG'] as String? ?? '',
      status: json['status'] as String? ?? 'approachable',
      statusText: json['statusText'] as String? ?? '',
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthday': instance.birthday,
      'isInRelationship': instance.isInRelationship,
      'occupation': instance.occupation,
      'gender': instance.gender,
      'bio': instance.bio,
      'avatarSVG': instance.avatarSVG,
      'status': instance.status,
      'statusText': instance.statusText,
    };
