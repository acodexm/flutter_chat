import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/enums/enums.dart';
import 'package:flutter_chat/core/models/message/message_item_data.dart';
import 'package:flutter_chat/ui/pages/chat/messages/img_message.dart';
import 'package:flutter_chat/utils/const.dart';

class MessageItem extends StatelessWidget {
  final bool rtl;
  final MessageItemData message;

  MessageItem({this.message, this.rtl});

  @override
  Widget build(BuildContext context) {
    switch (MessageType.valueOf(message.type)) {
      case MessageType.TEXT:
        {
          return Container(
            child: Text(
              message.content,
              style: TextStyle(color: rtl ? Colors.white : primaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: rtl ? primaryColor : greyColor2, borderRadius: BorderRadius.circular(8.0)),
            margin: rtl ? EdgeInsets.only(bottom: 10.0, left: 10.0) : EdgeInsets.only(bottom: 10.0, right: 10.0),
          );
        }
      case MessageType.IMAGE:
        {
          return ImgMessage(url: message.content, rtl: rtl);
        }
      default:
        {
          return Container();
        }
    }
  }
}
