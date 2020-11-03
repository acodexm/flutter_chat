library enums;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enums.g.dart';

class ChatType extends EnumClass {
  static Serializer<ChatType> get serializer => _$chatTypeSerializer;

  static const ChatType PRIVATE = _$PRIVATE;
  static const ChatType GROUP = _$GROUP;
  static const ChatType SAVED = _$SAVED;

  const ChatType._(String name) : super(name);

  static BuiltSet<ChatType> get values => _$values;

  static ChatType valueOf(String name) => _$valueOf(name);
}

class MessageType extends EnumClass {
  static Serializer<MessageType> get serializer => _$messageTypeSerializer;

  static const MessageType TEXT = _$TEXT;
  static const MessageType IMAGE = _$IMAGE;
  static const MessageType VIDEO = _$VIDEO;
  static const MessageType DELETED = _$DELETED;
  static const MessageType ARCHIVED = _$ARCHIVED;
  static const MessageType GIF = _$GIF;

  const MessageType._(String name) : super(name);

  static BuiltSet<MessageType> get values => _$messages;

  static MessageType valueOf(String name) => _$messageOf(name);
}
