import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/serializers/serializers.dart';

part 'message_response.g.dart';

abstract class MessageResponse implements Built<MessageResponse, MessageResponseBuilder> {
  String get id;

  String get createdBy;

  @nullable
  DateTime get timestamp;

  String get content;

  String get type;

  String toJson() {
    return json.encode(serializers.serializeWith(MessageResponse.serializer, this));
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(MessageResponse.serializer, this);
  }

  factory MessageResponse.fromJson(String jsonString) {
    return serializers.deserializeWith(
      MessageResponse.serializer,
      json.decode(jsonString),
    );
  }

  factory MessageResponse.fromMap(DocumentSnapshot doc) {
    return serializers.deserializeWith(
      MessageResponse.serializer,
      {'id': doc.id, ...doc.data()},
    );
  }

  MessageResponse._();

  static Serializer<MessageResponse> get serializer => _$messageResponseSerializer;

  factory MessageResponse([void Function(MessageResponseBuilder) updates]) = _$MessageResponse;
}
