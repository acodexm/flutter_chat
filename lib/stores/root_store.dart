import 'package:flutter_chat/stores/auth/auth_store.dart';
import 'package:flutter_chat/stores/chat/chat_list_store.dart';
import 'package:flutter_chat/stores/chat/chat_room_store.dart';
import 'package:flutter_chat/stores/profile/profile_store.dart';
import 'package:flutter_chat/stores/settings/settings_store.dart';
import 'package:flutter_chat/stores/start_up/start_up_store.dart';
import 'package:flutter_chat/stores/users/user_list_store.dart';
import 'package:flutter_chat/utils/logger.dart';

class RootStore {
  ChatListStore _chatListStore;
  ChatRoomStore _chatRoomStore;
  UserListStore _userListStore;
  StartUpStore _startUpStore;
  AuthStore _authStore;
  ProfileStore _profileStore;
  SettingsStore _settingsStore;

  ProfileStore get profileStore => _profileStore;

  SettingsStore get settingsStore => _settingsStore;

  AuthStore get authStore => _authStore;

  StartUpStore get startUpStore => _startUpStore;

  ChatListStore get chatListStore => _chatListStore;

  ChatRoomStore get chatRoomStore => _chatRoomStore;


  UserListStore get userListStore => _userListStore;

  RootStore() {
    _authStore = AuthStore(this);
    _startUpStore = StartUpStore(this);
    _chatRoomStore = ChatRoomStore(this);
    _chatListStore = ChatListStore(this);
    _settingsStore = SettingsStore(this);
    _profileStore = ProfileStore(this);
    _userListStore = UserListStore(this);
  }

  Future<void> initialize() async {}

  void dispose() {
    Log.d('root store disposed');
  }
}
