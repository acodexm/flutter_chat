import 'dart:async';

import 'package:flutter/foundation.dart';

class Debounce {
  final int delay;
  VoidCallback action;
  Timer _timer;

  Debounce({this.delay});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: delay), action);
  }
}
