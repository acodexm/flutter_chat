import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/info/info_response.dart';
import 'package:flutter_chat/core/models/serializers/serializers.dart';

part 'chat_response.g.dart';

abstract class ChatResponse implements Built<ChatResponse, ChatResponseBuilder> {
  String get id;

  BuiltMap<String, String> get title;

  InfoResponse get info;

  BuiltList<String> get users;

  String get type;

  String get chatHash;

  String get createdBy;

  @nullable
  DateTime get timestamp;

  @nullable
  BuiltMap<String, BuiltList<String>> get unreadByCounter;

  String toJson() {
    return json.encode(serializers.serializeWith(ChatResponse.serializer, this));
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(ChatResponse.serializer, this);
  }

  factory ChatResponse.fromJson(String jsonString) {
    return serializers.deserializeWith(
      ChatResponse.serializer,
      json.decode(jsonString),
    );
  }

  factory ChatResponse.fromMap(DocumentSnapshot doc) {
    return serializers.deserializeWith(
      ChatResponse.serializer,
      {'id': doc.id, ...doc.data()},
    );
  }

  ChatResponse._();

  static Serializer<ChatResponse> get serializer => _$chatResponseSerializer;

  factory ChatResponse([void Function(ChatResponseBuilder) updates]) = _$ChatResponse;
}
