import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class UserProfile {
  String name;
  String birthday;
  bool? isInRelationship;
  String occupation;
  String gender;
  String bio;
  String avatarSVG;
  String status;
  String statusText;

  UserProfile({
    this.name = '',
    this.birthday = '1970-01-01',
    this.isInRelationship,
    this.occupation = '',
    this.gender = 'male',
    this.bio = '',
    this.avatarSVG = '',
    this.status = 'approachable',
    this.statusText = '',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

class UserStatus {
  static UserStatusScheme get approachable =>
      UserStatusScheme(name: 'approachable', color: Colors.green[600]!);
  static UserStatusScheme get reserved =>
      UserStatusScheme(name: 'reserved', color: Colors.red[300]!);
  static UserStatusScheme get inactive =>
      UserStatusScheme(name: 'inactive', color: Colors.yellow[700]!);
  static UserStatusScheme get hidden =>
      const UserStatusScheme(name: 'hidden', color: Colors.transparent);
  
  static UserStatusScheme getProp(String property) {
    switch(property) {
      case 'approachable':
        return approachable;
      case 'reserved':
        return reserved;
      case 'inactive':
        return inactive;
      case 'hidden':
        return hidden;
    }

    return hidden;
  }
}

class UserStatusScheme {
  final String name;
  final Color color;

  const UserStatusScheme({
    required this.name,
    required this.color,
  });
}

class SimpleDate {
  int year = 1970;
  int month = 01;
  int day = 01;

  SimpleDate({
    this.year = 1970,
    this.month = 1,
    this.day = 1,
  });

  SimpleDate.fromString({String? date = '1970-01-01'}) {
    date = date ?? '1970-01-01';
    final regex = RegExp(r'(\d+)-(\d+)-(\d+)');

    final match = regex.firstMatch(date);

    if (match == null || match.groupCount != 3) {
      year = 1970;
      month = 1;
      day = 1;
      return;
    }

    year = int.parse(match.group(1)!);
    month = int.parse(match.group(2)!);
    day = int.parse(match.group(3)!);
  }

  @override
  String toString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  static int getSanitizedDateInput(int length, String? value) {
    if (value == null || value.isEmpty) {
      return 1;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 1;
    }

    if (value.toString().length > length) {
      return int.parse(value.substring(0, length));
    }

    return int.parse(value);
  }
}
