import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/utils/const.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final model = locator<RootStore>().profileStore;

  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  void dispose() {
//    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Avatar
        Container(
          child: Center(
            child: Stack(
              children: <Widget>[
                (model.photoURL != null
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 90.0,
                            height: 90.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: model.photoURL,
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 90.0,
                        color: greyColor,
                      )),
                IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: primaryColor.withOpacity(0.5),
                  ),
                  onPressed: model.getImage,
                  padding: EdgeInsets.all(30.0),
                  splashColor: Colors.transparent,
                  highlightColor: greyColor,
                  iconSize: 30.0,
                ),
              ],
            ),
          ),
          width: double.infinity,
          margin: EdgeInsets.all(20.0),
        ),
        Column(
          children: <Widget>[
            Container(
              child: Text(
                translate('profile.displayName'),
                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
            ),
            Container(
              child: Theme(
                data: Theme.of(context).copyWith(primaryColor: primaryColor),
                child: Observer(
                  builder: (context) => TextFormField(
                    initialValue: model.displayName,
                    decoration: InputDecoration(
                      hintText: translate('profile.displayName.hint'),
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    onChanged: (value) => model.displayName = value,
                    focusNode: model.focusNodeDisplayName,
                  ),
                ),
              ),
              margin: EdgeInsets.only(left: 30.0, right: 30.0),
            ),
            Container(
              child: Text(
                translate('profile.about'),
                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
            ),
            Container(
              child: Theme(
                data: Theme.of(context).copyWith(primaryColor: primaryColor),
                child: Observer(
                  builder: (context) => TextFormField(
                    initialValue: model.about,
                    decoration: InputDecoration(
                      hintText: translate('profile.about.hint'),
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    onChanged: (value) => model.about = value,
                    focusNode: model.focusNodeAbout,
                  ),
                ),
              ),
              margin: EdgeInsets.only(left: 30.0, right: 30.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        Container(
          child: MaterialButton(
            onPressed: model.handleUpdateData,
            child: Text(translate('button.update')),
          ),
          margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
        ),
      ],
    );
  }
}
