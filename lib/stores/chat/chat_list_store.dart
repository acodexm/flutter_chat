import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/helpers/data_pagination.dart';
import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/firebase/chat_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:mobx/mobx.dart';

part 'chat_list_store.g.dart';

class ChatListStore = ChatListStoreBase with _$ChatListStore;

abstract class ChatListStoreBase extends DataPagination with Store {
  final RootStore rootStore;
  final _chatService = locator<ChatService>();
  final _navigationService = locator<NavigationService>();
  final _auth = locator<AuthService>();
  Query _query;
  ObservableList<ChatResponse> chats = ObservableList();
  StreamSubscription chatsListener;

  ChatListStoreBase(this.rootStore);

  @observable
  int limit = 20;

  @observable
  UserResponse currentUser;

  void archiveChat(String chatId) {}

  void openChat(ChatResponse chat) {
    _navigationService.toNamed(ViewRoutes.chat, arguments: chat);
  }

  @action
  void onRefresh() {
    chats.clear();
    if (currentUser == null) {
      currentUser = _auth.currentUser;
    }
    refreshPage(_query, limit);
  }

  Future navigateToSettingView() async {
    await _navigationService.toNamed(ViewRoutes.settings);
  }

  void requestMoreData() {
    requestPaginatedData(_query, limit);
    Log.d('chats amount ${chats.length}');
  }

  onLongPress(int index) {
    Log.d('onLongPressChat todo impl');
  }

  @action
  Future<void> listen() async {
    Log.d('chatList listen');
    currentUser = _auth.currentUser;
    _query = _chatService.chatRef.orderBy('timestamp', descending: true).where('users', arrayContains: currentUser.uid);
    requestPaginatedData(_query, limit);
    chatsListener = streamData.listen((docs) {
      chats.clear();
      chats.addAll(docs.map((doc) => ChatResponse.fromMap(doc)).toList());
    });
  }

  void dispose() {
    Log.d('chatList dispose');
    chats.clear();
    chatsListener?.cancel();
    disposePagination();
  }
}
