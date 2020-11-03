import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/core/models/enums/enums.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/ui/pages/chat/messages/message_item.dart';
import 'package:flutter_chat/ui/widgets/stateful/creation_aware_list_item.dart';
import 'package:flutter_chat/utils/const.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ChatRoomView extends StatefulWidget {
  final String chatId;
  final ChatResponse chat;

  ChatRoomView({this.chatId, this.chat});

  @override
  _ChatRoomViewState createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final model = locator<RootStore>().chatRoomStore;

  @override
  void initState() {
    super.initState();
    //todo refactor this cancer
    model.chat = widget.chat;
    model.chatId = widget.chatId ?? widget.chat?.id;
    model.listen();
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(
            model.chatTitle,
          ),
          centerTitle: true,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                model.updateChat();
              },
            ),
          ],
        ),
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  Flexible(
                    child: model.messages.isNotEmpty
                        ? ListView.builder(
                            reverse: true,
                            itemCount: model.messages.length,
                            itemBuilder: (context, index) => CreationAwareListItem(
                              itemCreated: () {
                                if (index == model.messages.length - model.limit) model.requestMoreData();
                              },
                              child: GestureDetector(
                                onLongPress: () => model.onLongPress(index),
                                child: MessageItem(
                                  message: model.messages[index],
                                  rtl: model.messages[index].createdBy == model.currentUser.uid,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            child: Center(
                              child: Text('no messages'),
                            ),
                          ),
                  ),
                  // Sticker
//                      (isShowSticker ? Stickers(onSendMessage: onSendMessage) : Container()),

                  // Input content
                  Container(
                    child: Row(
                      children: <Widget>[
                        // Button send image
                        Material(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.0),
                            child: IconButton(
                              icon: Icon(Icons.image),
                              onPressed: model.getImage,
                              color: primaryColor,
                            ),
                          ),
                          color: Colors.white,
                        ),
//          Material(
//            child: Container(
//              margin: EdgeInsets.symmetric(horizontal: 1.0),
//              child: IconButton(
//                icon: Icon(Icons.face),
//                onPressed: model.getSticker,
//                color: primaryColor,
//              ),
//            ),
//            color: Colors.white,
//          ),

                        // Edit text
                        Flexible(
                          child: Container(
                            child: TextField(
                              style: TextStyle(color: primaryColor, fontSize: 15.0),
                              controller: model.textEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: greyColor),
                              ),
                              focusNode: model.focusNode,
                            ),
                          ),
                        ),

                        // Button send message
                        Material(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () => model.onSendMessage(model.textEditingController.text, MessageType.TEXT),
                              color: primaryColor,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
                  ),
                ],
              ),

              // Loading
//                  buildLoading()
            ],
          ),
          onWillPop: () {
            model.markMessagesAsRead();
            return Future.value(true);
          },
        ),
      ),
    );
  }
}
