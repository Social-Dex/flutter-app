// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String? ?? '',
      birthDay: json['birthDay'] as String? ?? '1970-01-01',
      isInRelationship: json['isInRelationship'] as bool? ?? false,
      occupation: json['occupation'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'birthDay': instance.birthDay,
      'isInRelationship': instance.isInRelationship,
      'occupation': instance.occupation,
      'gender': instance.gender,
      'description': instance.description,
    };
