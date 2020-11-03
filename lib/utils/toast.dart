import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/const.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> showToast(String msg) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: primaryColor,
    textColor: Colors.white);
