import 'package:flutter_chat/core/models/enums/auth_status.dart';
import 'package:flutter_chat/core/models/user/user_response.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final RootStore rootStore;
  @observable
  UserResponse currentUser;
  @observable
  AuthStatus status;

  AuthStoreBase(this.rootStore);
}
