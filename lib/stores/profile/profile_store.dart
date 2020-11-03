import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat/core/models/user/user_request.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/firebase/users_service.dart';
import 'package:flutter_chat/core/services/storage/cloud_storage_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = ProfileStoreBase with _$ProfileStore;

abstract class ProfileStoreBase with Store {
  final RootStore rootStore;
  final _uploadImageService = locator<CloudStorageService>();
  final _auth = locator<AuthService>();
  final _userService = locator<UserService>();
  final FocusNode focusNodeAbout = FocusNode();
  final FocusNode focusNodeDisplayName = FocusNode();
  ImagePicker picker;
  @observable
  UserResponse user;
  @observable
  String photoURL;
  @observable
  String displayName;
  @observable
  String about;

  ProfileStoreBase(this.rootStore);

  @action
  void init() {
    user = _auth.currentUser;
    picker = ImagePicker();
    photoURL = user.photoURL;
    Log.d(user.toString());
    about = user.about;
    displayName = user.displayName;
  }

  @action
  Future getImage() async {
    File image =
        File((await picker.getImage(source: ImageSource.gallery)).path);
    photoURL = await _uploadImageService
        .uploadFile(imageToUpload: image, path: BucketPath.PROFILE)
        .then((value) => value.imageUrl);
    await _userService
        .updateUser(UserRequest(uid: user.uid, photoURL: photoURL));
  }

  void handleUpdateData() async {
    focusNodeAbout.unfocus();
    focusNodeDisplayName.unfocus();
    await _userService.updateUser(UserRequest(
      uid: user.uid,
      displayName: displayName,
      about: about,
    ));
  }
}
