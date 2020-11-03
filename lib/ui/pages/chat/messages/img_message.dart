import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/widgets/full_photo.dart';
import 'package:flutter_chat/utils/const.dart';


class ImgMessage extends StatelessWidget {
  final url;
  final bool rtl;

  ImgMessage({Key key, this.url, this.rtl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Material(
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.all(70.0),
              decoration: BoxDecoration(
                color: greyColor2,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Material(
              child: Image.asset(
                'images/img_not_available.jpeg',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            imageUrl: url,
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullPhoto(url: url)));
        },
        padding: EdgeInsets.all(0),
      ),
      margin: rtl
          ? EdgeInsets.only(bottom: 10, left: 10)
          : EdgeInsets.only(bottom: 10, right: 10.0),
    );
  }
}
