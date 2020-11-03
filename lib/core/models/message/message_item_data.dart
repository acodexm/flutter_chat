import 'package:flutter_chat/core/models/message/message_response.dart';

class MessageItemData {
  String id;
  String createdBy;
  String content;
  String type;
  DateTime timestamp;
  List<String> unreadBy;

  MessageItemData(MessageResponse messageResponse, {this.unreadBy}) {
    this.id = messageResponse.id;
    this.createdBy = messageResponse.createdBy;
    this.content = messageResponse.content;
    this.type = messageResponse.type;
    this.timestamp = messageResponse.timestamp;
  }
}
