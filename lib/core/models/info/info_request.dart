import 'package:flutter_chat/core/models/info/info_response.dart';

class InfoRequest {
  String id;
  String title;
  String description;
  DateTime startAt;
  DateTime endAt;
  String photoURL;
  String shareLink;

  InfoRequest({
    this.id,
    this.title,
    this.description,
    this.startAt,
    this.endAt,
    this.photoURL,
    this.shareLink,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      'title': title,
      'description': description,
      'startAt': startAt,
      'endAt': endAt,
      'photoURL': photoURL,
      'shareLink': shareLink,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  static InfoRequest fromInfoResponse(InfoResponse response) {
    return InfoRequest(
        id: response.id,
        title: response.title,
        description: response.description,
        photoURL: response.photoURL,
        startAt: response.startAt,
        endAt: response.endAt,
        shareLink: response.shareLink);
  }

  @override
  String toString() {
    return 'InfoRequest{title: $title, description: $description, startAt: $startAt, endAt: $endAt, photoURL: $photoURL, shareLink: $shareLink}';
  }
}
