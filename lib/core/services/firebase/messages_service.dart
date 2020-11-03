import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/message/message_request.dart';
import 'package:flutter_chat/core/models/message/message_response.dart';
import 'package:flutter_chat/utils/logger.dart';

abstract class MessagesService {
  // Messages within the chat
  Future<bool> sendMessage(MessageRequest message);

  Future<bool> archiveMessage(String id);

  Stream<List<MessageResponse>> listenToMessagesRealTime();

  void requestMoreMessages();
}

class MessagesServiceImpl implements MessagesService {
  final StreamController<List<MessageResponse>> _messagesController =
      StreamController<List<MessageResponse>>.broadcast();
  CollectionReference _messagesCollectionReference;
  List<List<MessageResponse>> _allPagedMessages = List<List<MessageResponse>>();
  static const int _limitMessages = 20;
  DocumentSnapshot _lastMessage;
  bool _hasMoreMessages = true;
  String userId;

  MessagesServiceImpl(DocumentReference chat) {
    assert(chat != null);
    _messagesCollectionReference = chat.collection('messages');
  }

  @override
  Future<bool> sendMessage(MessageRequest message) async {
    try {
      await _messagesCollectionReference.add(message.toMap());
      return true;
    } catch (e) {
      Log.e('sendMessage', e: e);
    }
    return false;
  }

  @override
  Stream<List<MessageResponse>> listenToMessagesRealTime() {
    _requestMessages();
    return _messagesController.stream;
  }

  void _requestMessages() {
    var pageMessagesQuery = _messagesCollectionReference.orderBy('timestamp', descending: true).limit(_limitMessages);
    if (_lastMessage != null) {
      pageMessagesQuery = pageMessagesQuery.startAfterDocument(_lastMessage);
    }
    if (!_hasMoreMessages) return;
    var currentRequestIndex = _allPagedMessages.length;

    pageMessagesQuery.snapshots().listen((messageSnapshot) {
      if (messageSnapshot.docs.isNotEmpty &&
          !messageSnapshot.metadata.hasPendingWrites) {
        var message = messageSnapshot.docs
            .map((snapshot) => MessageResponse.fromMap(snapshot))
            .toList();

        var pageExists = currentRequestIndex < _allPagedMessages.length;
        if (pageExists) {
          _allPagedMessages[currentRequestIndex] = message;
        } else {
          _allPagedMessages.add(message);
        }
        var allMessages = _allPagedMessages.fold<List<MessageResponse>>(
            List<MessageResponse>(),
            (initialValue, pageItems) => initialValue..addAll(pageItems));
        _messagesController.add(allMessages);
        if (currentRequestIndex == _allPagedMessages.length - 1) {
          _lastMessage = messageSnapshot.docs.last;
        }
        _hasMoreMessages = message.length == _limitMessages;
      }
    });
  }

  @override
  Future<bool> archiveMessage(String messageId) async {
    try {
      await _messagesCollectionReference.doc(messageId).set(
          {'type': 'archived'}, SetOptions(merge: true));
    } catch (e) {
      Log.e('archiveMessage', e: e);
    }
    return null;
  }

  @override
  void requestMoreMessages() => _requestMessages();
}
