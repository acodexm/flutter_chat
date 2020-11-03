import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRequest {
  String id;
  String createdBy;
  String content;
  String type;

//  DateTime timestamp;

  MessageRequest({this.id, this.createdBy, this.content, this.type});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "createdBy": createdBy,
      "content": content,
      "type": type,
      "timestamp": FieldValue.serverTimestamp(),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return 'MessageRequest{id: $id, createdBy: $createdBy, content: $content, type: $type}';
  }
}
