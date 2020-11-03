import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/user/user_request.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';
import 'package:flutter_chat/utils/logger.dart';

abstract class UserService {
  Future<String> createUser(UserRequest user);

  Future<bool> updateUser(UserRequest user);

  Future<UserResponse> getUser(String id);

  Future<bool> archiveUser(String id);

  CollectionReference get usersRef;
}

class UserServiceImpl implements UserService {
  CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  CollectionReference get usersRef => _usersCollectionReference;

  @override
  Future<String> createUser(UserRequest user) async {
    try {
      var userReference = _usersCollectionReference.doc(user.uid);
      await userReference.set(user.toMap());
      return userReference.id;
    } catch (e) {
      Log.e('createUser', e: e);
    }
    return null;
  }

  @override
  Future<UserResponse> getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return UserResponse.fromMap(userData);
    } catch (e) {
      Log.e('getUser', e: e);
    }
    return null;
  }

  @override
  Future<bool> archiveUser(String uid) async {
    try {
      await _usersCollectionReference.doc(uid).update({'type': 'archived'});
    } catch (e) {
      Log.e('archiveUser', e: e);
    }
    return null;
  }

  @override
  Future<bool> updateUser(UserRequest user) async {
    try {
      await _usersCollectionReference.doc(user.uid).set(
          user.toMap(), SetOptions(merge: true));
      return true;
    } catch (e) {
      Log.e('updateUser', e: e);
    }
    return false;
  }
}
