library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/core/models/info/info_response.dart';
import 'package:flutter_chat/core/models/message/message_response.dart';
import 'package:flutter_chat/core/models/serializers/custom/geo_point_serializer.dart';
import 'package:flutter_chat/core/models/serializers/custom/timestamp_serializer.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';

part 'serializers.g.dart';

@SerializersFor([UserResponse, ChatResponse, MessageResponse, InfoResponse])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(GeoPointSerializer())
      ..addPlugin(TimestampSerializerPlugin()))
    .build();
