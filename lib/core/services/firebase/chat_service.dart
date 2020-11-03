import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/models/chat/chat_request.dart';
import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/utils/hash.dart';
import 'package:flutter_chat/utils/logger.dart';

abstract class ChatService {
  CollectionReference get chatRef;

  Future<String> createChat(ChatRequest doc);

  Future<bool> updateChat(ChatRequest doc);

  Future<ChatResponse> getChat(String id);

  Future<bool> archiveChat(String id);

  Future<bool> markMessagesAsReadBy(String chatId, String userId);
}

class ChatServiceImpl implements ChatService {
  final CollectionReference _chatsCollectionReference =
      FirebaseFirestore.instance.collection('chats');

  CollectionReference get chatRef => _chatsCollectionReference;

  @override
  Future<String> createChat(ChatRequest chat) async {
    String chatId = await _checkIfChatExists(chat);
    if (chatId == null)
      try {
        var chatReference = _chatsCollectionReference.doc();
        chatId = chatReference.id;
        await chatReference.set(chat.toMap());
      } catch (e) {
        Log.e('createChat', e: e);
      }
    return chatId;
  }

  Future<String> _checkIfChatExists(ChatRequest chat) async {
    try {
        var chatDocuments = await _chatsCollectionReference
            .where('type', isEqualTo: chat.type)
            .where('chatHash', isEqualTo: getHash(chat.users, chat.type))
            .get();
        if (chatDocuments.docs.isEmpty) return null;
        return chatDocuments.docs.first.id;
      } catch (e) {
        Log.e('_checkIfChatExists', e: e);
      }

    return null;
  }

  @override
  Future<ChatResponse> getChat(String id) async {
    try {
      var chatData = await _chatsCollectionReference.doc(id).get();
      return ChatResponse.fromMap(chatData);
    } catch (e) {
      Log.e('getChat', e: e);
    }
    return null;
  }

  @override
  Future<bool> archiveChat(String id) async {
    try {
      await _chatsCollectionReference.doc(id).update({'type': 'archived'});
      return true;
    } catch (e) {
      Log.e('archiveChat', e: e);
    }
    return false;
  }

  @override
  Future<bool> updateChat(ChatRequest chat) async {
    try {
      await _chatsCollectionReference.doc(chat.id).set(
          chat.toMap(), SetOptions(merge: true));
      return true;
    } catch (e) {
      Log.e('updateChat', e: e);
    }
    return false;
  }

  @override
  Future<bool> markMessagesAsReadBy(String chatId, String userId) async {
    try {
      await _chatsCollectionReference.doc(chatId).set({
        'unreadByCounter': {userId: FieldValue.delete()}
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      Log.e('markMessagesAsReadBy', e: e);
    }
    return false;
  }
}
