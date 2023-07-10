import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app/services/location.dart';
import 'package:app/services/models.dart';
import 'package:app/services/firestore.dart';
import 'package:app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:fluttermoji/fluttermoji.dart';

class UserData {
  final BuildContext context;
  late UserProfile _profile;
  late User _authData;
  LatLng _lastPostion = const LatLng(0, 0);

  UserData(this.context) {
    update();

    Location().getCurrentPosition().listen((position) {
      _lastPostion = position;
    });
  }

  Future<void> update() async {
    _profile = await FirestoreService().getUserProfile();
    _authData = AuthService().user!;

    if (_profile.avatarSVG == '') {
      _profile.avatarSVG = await FluttermojiFunctions().encodeMySVGtoString();
    }
  }

  UserProfile get profile {
    return _profile;
  }

  String get email {
    return _authData.email!;
  }

  String get name {
    return _profile.name;
  }

  String get birthday {
    return _profile.birthday;
  }

  int get age {
    SimpleDate simpleBday = SimpleDate.fromString(date: _profile.birthday);
    DateTime bDay = DateTime(simpleBday.year, simpleBday.month, simpleBday.day);
    DateDuration duration = AgeCalculator.age(bDay);

    return duration.years;
  }

  bool? get isInRelationship {
    return _profile.isInRelationship;
  }

  String get occupation {
    return _profile.occupation;
  }

  String get gender {
    switch (_profile.gender) {
      case 'male':
        return AppLocalizations.of(context)!.male;
      case 'female':
        return AppLocalizations.of(context)!.female;
    }

    return _profile.gender;
  }

  IconData get genderIcon {
    switch (_profile.gender) {
      case 'male':
        return Icons.male;
      case 'female':
        return Icons.female;
      default:
        return Icons.transgender;
    }
  }

  String get relationshipStatus {
    if (_profile.isInRelationship == true) {
      return AppLocalizations.of(context)!.relationshipStatusTaken;
    } else if (_profile.isInRelationship == false) {
      return AppLocalizations.of(context)!.relationshipStatusSingle;
    }

    return AppLocalizations.of(context)!.preferNotToAnswer;
  }

  String get bio {
    return _profile.bio;
  }

  Stream<LatLng> get position {
    return Location().getCurrentPosition();
  }

  LatLng get lastPosition {
    return _lastPostion;
  }

  String get avatarSvg {
    return _profile.avatarSVG;
  }

  Color get statusColor {
    return UserStatus.getProp(_profile.status).color;
  }

  String get statusText {
    return _profile.statusText;
  }
}