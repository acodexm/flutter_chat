import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/core/models/info/info_request.dart';

class ChatRequest {
  String id;
  Map<String, String> title;
  InfoRequest info;
  List<String> users;
  String type;
  String chatHash;
  String createdBy;

  ChatRequest({
    this.id,
    @required this.title,
    this.info,
    this.users,
    @required this.type,
    @required this.chatHash,
    @required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "info": info?.toMap() ?? null,
      "users": users,
      "type": type,
      "chatHash": chatHash,
      "createdBy": createdBy,
      "timestamp": FieldValue.serverTimestamp(),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return 'ChatRequest{id: $id, title: $title, info: $info, users: $users, type: $type, chatHash: $chatHash, createdBy: $createdBy}';
  }
}
