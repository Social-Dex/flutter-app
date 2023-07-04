import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/services/location.dart';
import 'package:app/services/models.dart';
import 'package:app/services/firestore.dart';
import 'package:app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:age_calculator/age_calculator.dart';

class UserData {
  final BuildContext context;
  late UserProfile _profile;
  late User _authData;
  LatLng _lastPostion = const LatLng(0,0);

  UserData(this.context) {
    update();
  }

  Future<void> update() async {
    _profile = await FirestoreService().getUserProfile();
    _authData = AuthService().user!;

    Location().getCurrentPosition().listen((position) {
      _lastPostion = position;
    });
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

  String get bio {
    return _profile.bio;
  }

  Stream<LatLng> get position {
    return Location().getCurrentPosition();
  }

  LatLng get lastPosition {
    return _lastPostion;
  }
}