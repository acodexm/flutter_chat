import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuthRequest {
  String displayName;
  String about;
  String photoURL;
  String email;
  bool exists = true;
  String role = 'user';

  UserAuthRequest(
      {this.displayName, this.about, this.photoURL, this.email, this.exists});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "displayName": exists ? null : displayName,
      "about": exists ? null : about,
      "photoURL": exists ? null : photoURL,
      "email": email, // always update email
      "role": exists ? null : role,
      "createdAt": exists ? null : FieldValue.serverTimestamp(),
      "lastSeen": FieldValue.serverTimestamp(),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return 'UserAuthRequest{displayName: $displayName, about: $about, photoURL: $photoURL, email: $email}';
  }
}
//
