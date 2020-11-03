import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/helpers/data_pagination.dart';
import 'package:flutter_chat/core/models/chat/chat_request.dart';
import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/core/models/dialog/dialog_request.dart';
import 'package:flutter_chat/core/models/enums/enums.dart';
import 'package:flutter_chat/core/models/message/message_item_data.dart';
import 'package:flutter_chat/core/models/message/message_request.dart';
import 'package:flutter_chat/core/models/message/message_response.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/dialog/dialog_service.dart';
import 'package:flutter_chat/core/services/firebase/chat_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/core/services/storage/cloud_storage_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:flutter_translate/global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'chat_room_store.g.dart';

class ChatRoomStore = ChatRoomStoreBase with _$ChatRoomStore;

abstract class ChatRoomStoreBase extends DataPagination with Store {
  final RootStore rootStore;
  final _chatService = locator<ChatService>();
  final _navigationService = locator<NavigationService>();
  final _auth = locator<AuthService>();
  final ImagePicker picker = new ImagePicker();
  final ScrollController listScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final _cloudStorage = locator<CloudStorageService>();
  final _dialogService = locator<DialogService>();
  CollectionReference _msgRef;
  String chatId;

  ChatResponse chat;

  Faker faker = Faker();
  String imageUrl;
  PickedFile imageFile;
  bool isLoading;
  bool isShowSticker;
  Query _query;

  StreamSubscription<List<DocumentSnapshot>> messageListener;

  ChatRoomStoreBase(this.rootStore);

  @observable
  int limit = 20;

  ObservableList<MessageItemData> messages = ObservableList();

  @observable
  UserResponse currentUser;
  @observable
  String chatTitle = 'Chat';

  void archiveChat(String chatId) {}

  void openChat(MessageResponse chat) {
    _navigationService.toNamed(ViewRoutes.chat, arguments: chat);
  }

  @action
  void onRefresh() {
    messages.clear();
    if (currentUser == null) {
      currentUser = _auth.currentUser;
    }
    refreshPage(_query, limit);
  }

  void requestMoreData() {
    requestPaginatedData(_query, limit);
    Log.d('messages amount ${messages.length}');
  }

  @action
  Future init({String chatId, ChatResponse chat}) async {
    //todo REFACTOR
    this.chatId = chatId;
    this.chat = chat;
    if (chat == null) {
      if (chatId == null) {
        return;
      }
      this.chat = await _chatService.getChat(chatId);
      Log.d('init chat room ${chat.toString()}');
    }
  }

  @action
  void listen() {
    Log.d('chatList listen');
    currentUser = _auth.currentUser;
    chatTitle = chat.title[currentUser.uid];
    _msgRef = _chatService.chatRef.doc(chatId).collection('messages');
    _query = _msgRef.orderBy('timestamp', descending: true);
    requestPaginatedData(_query, limit);
    messageListener = streamData.listen((docs) {
      messages.clear();
      messages.addAll(docs.map((message) {
        List<String> unreadBy = [];
        if (chat.unreadByCounter != null)
          chat.unreadByCounter.forEach((user, messages) {
            if (messages.contains(message.id)) unreadBy.add(user);
          });
        return MessageItemData(MessageResponse.fromMap(message), unreadBy: unreadBy);
      }).toList());
    });
    markMessagesAsRead();
  }

  void dispose() {
    Log.d('chatList dispose');
    messages.clear();
    messageListener?.cancel();
    disposePagination();
  }

  @action
  Future getImage() async {
    imageFile = await picker.getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      isLoading = true;
      var result = await _cloudStorage.uploadFile(
          imageToUpload: File(imageFile.path), path: BucketPath.MESSAGE);
      onSendMessage(result.imageUrl, MessageType.IMAGE);
    }
  }

  Future updateChat() async {
    Map<String, DialogField> fields;
    switch (ChatType.valueOf(chat.type)) {
      case ChatType.PRIVATE:
        {
          fields = {
            'title': DialogField(
              type: FieldType.Text,
              value: chat.title[currentUser.uid],
              label: translate('chat.title'),
            )
          };
          break;
        }
      case ChatType.GROUP:
        {
          fields = {
            'title': DialogField(
              type: FieldType.Text,
              value: chat.title[currentUser.uid],
              label: translate('chat.title'),
            )
          };
          break;
        }
    }
    var response = await _dialogService.showFormDialog(DialogFormRequest(
      title: translate('chat.edit.title'),
      fields: fields,
      okButton: translate('buttons.update'),
    ));
    if (response.confirmed) {
      switch (ChatType.valueOf(chat.type)) {
        case ChatType.PRIVATE:
          {
            Map<String, String> privateTitle = Map.from(chat.title.toMap());
            privateTitle.update(currentUser.uid, (value) => response.answers['title']);
            await _chatService.updateChat(ChatRequest(
              id: chatId,
              title: privateTitle,
              chatHash: null,
              createdBy: null,
              type: null,
            ));
            break;
          }
        case ChatType.GROUP:
          {
            Map<String, String> groupTitle = Map.from(chat.title.toMap());
            groupTitle.update(currentUser.uid, (value) => response.answers['title']);
            await _chatService.updateChat(ChatRequest(
              id: chatId,
              title: groupTitle,
              chatHash: null,
              createdBy: null,
              type: null,
            ));
            break;
          }
      }
      chat = await _chatService.getChat(chatId);
    }
  }

  void onSendMessage(String content, MessageType type) {
    if (content == null || content == '') content = faker.lorem.sentence();
    _msgRef.add(MessageRequest(
      createdBy: currentUser.uid,
      content: content,
      type: type.toString(),
    ).toMap());
    Log.d('onSendMessage: $content $type');
//    if (messages != null)
//      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Future markMessagesAsRead() {
    return _chatService.markMessagesAsReadBy(chatId, currentUser.uid);
  }

  void onLongPress(int index) {
    Log.d('todo handle long press on message $index');
  }
}
