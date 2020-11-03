import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/ui/pages/chat/chat_list/chat_item.dart';
import 'package:flutter_chat/ui/widgets/stateful/creation_aware_list_item.dart';
import 'package:flutter_chat/utils/const.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with AutomaticKeepAliveClientMixin<ChatList> {
  final listStore = locator<RootStore>().chatListStore;

  @override
  void initState() {
    super.initState();
    listStore.listen();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    listStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('home.title')),
        leading: Observer(
          builder: (context) => RawMaterialButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              listStore.navigateToSettingView();
            },
            child: listStore.currentUser?.photoURL != null ?? false
                ? Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      ),
                      imageUrl: listStore.currentUser.photoURL,
                      fit: BoxFit.cover,
                    ),
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  clipBehavior: Clip.hardEdge,
                )
                    : Icon(
                  Icons.account_circle,
                ),
              ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: listStore.chats?.isNotEmpty ?? false
                ? Observer(
                builder: (context) => ListView.builder(
                  itemCount: listStore.chats.length,
                  itemBuilder: (context, index) => CreationAwareListItem(
                      itemCreated: () {
                        if (index == listStore.chats.length - listStore.limit) listStore.requestMoreData();
                      },
                      child: ChatItem(
                        chat: listStore.chats.elementAt(index),
                        onLongPress: () => listStore.onLongPress(index),
                        onTap: () => listStore.openChat(listStore.chats.elementAt(index)),
                        chatUserId: listStore.currentUser.uid,
                      )),
                ))
                : Container(
              child: Center(
                child: Text('no chats'),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
