import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/ui/widgets/stateful/creation_aware_list_item.dart';
import 'package:flutter_chat/utils/const.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList>
    with AutomaticKeepAliveClientMixin<UserList> {
  final model = locator<RootStore>().userListStore;

  @override
  void initState() {
    super.initState();
    model.listen();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('users.title')),
        leading: Observer(
          builder: (context) => RawMaterialButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              model.navigateToSettingView();
            },
            child: model.currentUser?.photoURL != null ?? false
                ? Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      ),
                      imageUrl: model.currentUser.photoURL,
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
            child: model.users?.isNotEmpty ?? false
                ? Observer(
                    builder: (context) => ListView.builder(
                      itemCount: model.users.length,
                      itemBuilder: (context, index) => CreationAwareListItem(
                        itemCreated: () {
                          if (index == model.users.length - model.limit)
                            model.requestMoreData();
                        },
                        child: ListTile(
                          onTap: () {
                            if (model.isSelected()) {
                              model.toggleSelect(model.users.elementAt(index));
                            } else
                              model.onUserClick(model.users.elementAt(index));
                          },
                          selected: model
                                  .selected[model.users.elementAt(index).uid] !=
                              null,
                          onLongPress: () {
                            model.toggleSelect(model.users.elementAt(index));
                          },
                          title: Text(
                            '${model.users.elementAt(index).displayName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: model.users.elementAt(index).photoURL != null
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                    ),
                                    imageUrl:
                                        model.users.elementAt(index).photoURL,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    child: Center(
                      child: Text('no users'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
