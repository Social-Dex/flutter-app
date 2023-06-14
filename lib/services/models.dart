import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class User {
  String name;
  String birthDay;
  bool isInRelationship;
  String occupation;
  String gender;
  String description;

  User({
    this.name = '',
    this.birthDay = '1970-01-01',
    this.isInRelationship = false,
    this.occupation = '',
    this.gender = '',
    this.description = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class SimpleDate {
  late final int year;
  late final int month;
  late final int day;

  SimpleDate({
    this.year = 1970,
    this.month = 1,
    this.day = 1,
  });

  SimpleDate.fromString(String? date) {
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
}
