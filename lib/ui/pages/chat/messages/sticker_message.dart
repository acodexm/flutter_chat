import 'package:flutter/material.dart';

class Sticker extends StatelessWidget {
  final document;
  final bool isLeft;

  Sticker({Key key, this.document, this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/images/${document['content']}.gif',
        width: 100.0,
        height: 100.0,
        fit: BoxFit.cover,
      ),
      margin: isLeft
          ? EdgeInsets.only(bottom: 10.0, left: 10.0)
          : EdgeInsets.only(bottom: 10.0, right: 10.0),
    );
  }
}
