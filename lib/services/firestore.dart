import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/models.dart';

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
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<UserProfile> getUserProfile() async {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid);
    var snapshot = await ref.get();
    
    return UserProfile.fromJson(snapshot.data() ?? {});
  }
}