// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      name: json['name'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '1970-01-01',
      isInRelationship: json['isInRelationship'] as bool?,
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

UsersOnMap _$UsersOnMapFromJson(Map<String, dynamic> json) => UsersOnMap(
      users: (json['users'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, UserMapData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$UsersOnMapToJson(UsersOnMap instance) =>
    <String, dynamic>{
      'users': instance.users,
    };

UserMapData _$UserMapDataFromJson(Map<String, dynamic> json) => UserMapData(
      position: json['position'] == null
          ? const LatLng(0, 0)
          : LatLng.fromJson(json['position'] as Map<String, dynamic>),
      avatarSVG: json['avatarSVG'] as String? ??
          '{"topType":24,"accessoriesType":0,"hairColor":1,"facialHairType":0,"facialHairColor":1,"clotheType":4,"eyeType":6,"eyebrowType":10,"mouthType":8,"skinColor":3,"clotheColor":8,"style":0,"graphicType":0}',
      status: json['status'] as String? ?? 'inactive',
    );

Map<String, dynamic> _$UserMapDataToJson(UserMapData instance) =>
    <String, dynamic>{
      'position': instance.position,
      'avatarSVG': instance.avatarSVG,
      'status': instance.status,
    };
