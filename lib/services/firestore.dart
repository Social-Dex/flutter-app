import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/models.dart';
import 'package:latlong2/latlong.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUserProfile(UserProfile userProfile) {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid);

    var data = {
      'name': userProfile.name,
      'birthday': userProfile.birthday.toString(),
      'gender': userProfile.gender,
      'occupation': userProfile.occupation,
      'isInRelationship': userProfile.isInRelationship,
      'bio': userProfile.bio,
      'avatarSVG': userProfile.avatarSVG,
      'status': userProfile.status,
      'statusText': userProfile.statusText,
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<UserProfile> getUserProfile({String? userId}) async {
    var user = AuthService().user!;
    userId ??= user.uid;

    var ref = _db.collection('users').doc(userId);
    var snapshot = await ref.get();

    return UserProfile.fromJson(snapshot.data() ?? {});
  }

  Future<UsersOnMap> getUserPositions() async {
    var user = AuthService().user!;

    var ref = _db.collection('location').doc('tmp');
    var snapshot = await ref.get();

    if (snapshot.data() == null) return UsersOnMap();

    UsersOnMap map = UsersOnMap(
        users: snapshot.data()!.map((key, value) {
      var pos = value['position'] ?? const LatLng(0, 0);
      LatLng latLng = LatLng(pos.latitude, pos.longitude);
      return MapEntry(
          key.trim(),
          UserMapData(
            position: latLng,
            avatarSVG: value['avatarSVG'] ?? '{"topType":24,"accessoriesType":0,"hairColor":1,"facialHairType":0,"facialHairColor":1,"clotheType":4,"eyeType":6,"eyebrowType":10,"mouthType":8,"skinColor":3,"clotheColor":8,"style":0,"graphicType":0}',
            status: value['status'] ?? 'inactive',
          ));
    }));

    map.users!.remove(user.uid);

    return map;
  }
}
