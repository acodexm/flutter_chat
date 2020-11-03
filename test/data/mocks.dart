import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';

final mockChat1 = ChatResponse(
  (p) => p
    ..id = 'user1'
);
final mockChat2 = mockChat1.rebuild(
  (p) => p
    ..id = 'user2'
);
final mockChats = [mockChat1, mockChat2];

final mockChatsJson = [
  {'userId': 1, 'id': 1, 'title': 'Chat 1'},
  {'userId': 1, 'id': 2, 'title': 'Chat 2'},
];

final mockUserJson = {
  'uid': 'user1',
  'displayName': 'Leanne Graham',
  'email': 'Sincere@april.biz',
  'photoUrl': 'hildegard.org',
};

final mockUID = 'user1';
final mockEmail = 'email@gmail.com';
final mockPassword = 'password';
final mockDisplayName = 'Barrack Obama';
final mockUser = UserResponse(
  (u) => u
    ..uid = mockUID
    ..displayName = mockDisplayName
    ..email = mockEmail
    ..photoURL = 'barrackobama.com',
);
