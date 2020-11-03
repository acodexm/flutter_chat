import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/core/models/enums/enums.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatelessWidget {
  final ChatResponse chat;
  final String chatUserId;
  final onTap;
  final onLongPress;

  ChatItem({this.chat, this.chatUserId, this.onLongPress, this.onTap}) {
//    Log.d('ChatItem: $chat');
  }

  Widget _buildUserUnreadMessages() {
    if (chat.unreadByCounter != null &&
        chat.unreadByCounter[chatUserId] != null &&
        chat.unreadByCounter[chatUserId].length != 0) {
      return Text(chat.unreadByCounter[chatUserId].length.toString());
    }
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    switch (ChatType.valueOf(chat.type)) {
      case ChatType.GROUP:
        {
          return ListTile(
            onTap: onTap,
            onLongPress: onLongPress,
            title: Text(chat.title[chatUserId]),
            leading: Icon(Icons.people),
            subtitle: Text(DateFormat('dd MMM kk:mm').format(chat.timestamp)),
            trailing: _buildUserUnreadMessages(),
          );
        }
      case ChatType.PRIVATE:
        {
          return ListTile(
            onTap: onTap,
            onLongPress: onLongPress,
            title: Text(chat.title[chatUserId]),
            leading: Icon(Icons.person),
            subtitle: Text(DateFormat('dd MMM kk:mm').format(chat.timestamp)),
            trailing: _buildUserUnreadMessages(),
          );
        }
      default:
        {
          return Container();
        }
    }
  }
}
