import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/serializers/serializers.dart';

part 'user_response.g.dart';

abstract class UserResponse implements Built<UserResponse, UserResponseBuilder> {
  String get uid;

  @nullable
  String get displayName;

  @nullable
  String get about;

  @nullable
  String get photoURL;

  DateTime get createdAt;

  DateTime get lastSeen;

  String get email;

  String get role;


  String toJson() {
    return json.encode(serializers.serializeWith(UserResponse.serializer, this));
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(UserResponse.serializer, this);
  }

  factory UserResponse.fromJson(String jsonString) {
    return serializers.deserializeWith(
      UserResponse.serializer,
      json.decode(jsonString),
    );
  }

  factory UserResponse.fromMap(DocumentSnapshot doc) {
    return serializers.deserializeWith(
      UserResponse.serializer,
      {'uid': doc.id, ...doc.data()},
    );
  }

  UserResponse._();

  static Serializer<UserResponse> get serializer => _$userResponseSerializer;

  factory UserResponse([void Function(UserResponseBuilder) updates]) = _$UserResponse;
}
