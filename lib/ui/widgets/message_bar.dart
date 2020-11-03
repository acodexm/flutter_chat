import 'package:flutter/material.dart';

class MessageBar extends StatelessWidget {
  const MessageBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(children: [Text('todo input')],),
      ),
    );
  }
}
