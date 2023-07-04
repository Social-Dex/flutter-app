import 'package:app/services/location.dart';
import 'package:app/services/models.dart';
import 'package:app/services/firestore.dart';
import 'package:app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';

class UserData {
  late UserProfile _profile;
  late User _authData;
  LatLng _position = const LatLng(0,0);

  UserData() {
    update();
  }

  Future<void> update() async {
    _profile = await FirestoreService().getUserProfile();
    _authData = AuthService().user!;

    Location().getCurrentPosition().listen((position) {
      _position = position;
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

  bool? get isInRelationship {
    return _profile.isInRelationship;
  }

  String get occupation {
    return _profile.occupation;
  }

  String get gender {
    return _profile.gender;
  }

  String get bio {
    return _profile.bio;
  }

  LatLng get position {
    if (_position == const LatLng(0,0)) {
      update();
    }

    return _position;
  }
}