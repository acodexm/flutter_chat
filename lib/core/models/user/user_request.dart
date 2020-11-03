import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequest {
  String uid;
  String displayName;
  String about;
  String photoURL;
  String email;
  String role;

  UserRequest({
    this.uid,
    this.displayName,
    this.about,
    this.photoURL,
    this.email,
    this.role,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "uid": uid,
      "displayName": displayName,
      "about": about,
      "photoURL": photoURL,
      "email": email,
      "role": role,
      "lastSeen": FieldValue.serverTimestamp(),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return 'UserRequest{uid: $uid, displayName: $displayName, about: $about, photoURL: $photoURL, email: $email, role: $role}';
  }
}
