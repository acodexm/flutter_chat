import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/helpers/data_pagination.dart';
import 'package:flutter_chat/core/models/chat/chat_request.dart';
import 'package:flutter_chat/core/models/enums/enums.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/firebase/chat_service.dart';
import 'package:flutter_chat/core/services/firebase/users_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/utils/hash.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:mobx/mobx.dart';

part 'user_list_store.g.dart';

class UserListStore = UserListStoreBase with _$UserListStore;

abstract class UserListStoreBase extends DataPagination with Store {
  final RootStore rootStore;
  final _userService = locator<UserService>();
  final _chatService = locator<ChatService>();
  final _navigationService = locator<NavigationService>();
  final _auth = locator<AuthService>();
  Query _query;
  ObservableList<UserResponse> users = ObservableList();
  StreamSubscription usersListener;

  UserListStoreBase(this.rootStore);

  @observable
  int limit = 20;

  @observable
  UserResponse currentUser;
  ObservableMap<String, UserResponse> selected = ObservableMap();

  @action
  void toggleSelect(UserResponse user) {
    Log.d('selected $user');
    selected.update(user.uid, (value) {
      if (value == null) {
        return user;
      }
      return null;
    });
  }

  bool isSelected() {
    return selected != null &&
        selected.isNotEmpty &&
        selected.values.any((element) => element != null);
  }

  void onUserClick(UserResponse user) async {
    Log.d('UserList Tile click ${user.toString()} ');
    Log.d('UserList Tile click current ${currentUser.toString()} ');
    var chatId = await _chatService.createChat(
      ChatRequest(
          title: _createPrivateTitle(user),
          chatHash:
              getHash([currentUser.uid, user.uid], ChatType.PRIVATE.toString()),
          users: [currentUser.uid, user.uid],
          type: ChatType.PRIVATE.toString(),
          createdBy: currentUser.uid),
    );
    Log.d('entering chat $chatId');
    _navigationService.toNamed(ViewRoutes.chat, arguments: chatId);
  }

  Map<String, String> _createPrivateTitle(UserResponse user) {
    return {
      currentUser.uid: user.displayName,
      user.uid: currentUser.displayName
    };
  }

  Map<String, String> _createGroupTitle() {
    Map<String, UserResponse> selectedUsers = Map.from(selected);
    selectedUsers.removeWhere((key, value) => value == null);
    Map<String, String> groupTitle = Map();
    selectedUsers.forEach((key, value) {
      groupTitle.putIfAbsent(key, () {
        String title = '';
        selectedUsers.forEach((nextId, value) {
          if (nextId != key) {
            title = title + value.displayName + ', ';
          }
        });
        return title.substring(0, title.lastIndexOf(',') - 1);
      });
    });
    return groupTitle;
  }

  void createGroupChat() async {
    Log.d('UserList fab click CREATE GROUP CHAT');
    List<String> users = [currentUser.uid];
    Map<String, bool> selectedUsers = Map.from(selected);
    selectedUsers.removeWhere((key, value) => value == false);
    users.addAll(selectedUsers.keys);
    var chatId = await _chatService.createChat(
      ChatRequest(
        title: _createGroupTitle(),
        chatHash: getHash(users, ChatType.GROUP.toString()),
        users: users,
        createdBy: currentUser.uid,
        type: ChatType.GROUP.toString(),
      ),
    );
    Log.d('entering group chat $chatId');
    _navigationService.toNamed(ViewRoutes.chat, arguments: chatId);
  }

  void archiveUser(String userId) {}

  @action
  void onRefresh() {
    users.clear();
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
    Log.d('users amount ${users.length}');
  }

  @action
  Future<void> listen() async {
    Log.d('userList listen');
    currentUser = _auth.currentUser;
    _query = _userService.usersRef.orderBy('lastSeen', descending: true);
    requestPaginatedData(_query, limit);
    usersListener = streamData.listen((docs) {
      users.clear();
      users.addAll(docs
          .where((element) => element.id != currentUser.uid)
          .map((doc) => UserResponse.fromMap(doc))
          .toList());
    });
  }

  void dispose() {
    Log.d('userList dispose');
    users.clear();
    usersListener?.cancel();
    disposePagination();
  }
}
