import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/snackbar/snackbar_request.dart';
import 'package:flutter_chat/core/models/snackbar/snackbar_response.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/logger.dart';

abstract class SnackbarService {
  Future<SnackbarResponse> showSnackbar(SnackbarRequest alertRequest);

  void completeSnackbar(SnackbarResponse response);
}

/// A service that is responsible for returning future snackbar
class SnackbarServiceImpl implements SnackbarService {
  Completer<SnackbarResponse> _snackbarCompleter;

  @override
  Future<SnackbarResponse> showSnackbar(SnackbarRequest request) {
    _snackbarCompleter = Completer<SnackbarResponse>();
    _showSnackbar(request);
    return _snackbarCompleter.future;
  }

  @override
  void completeSnackbar(SnackbarResponse response) {
    locator<NavigationService>().pop();
    _snackbarCompleter.complete(response);
    _snackbarCompleter = null;
  }

  void _showSnackbar(SnackbarRequest request) {
    Log.d(request.toString());
    final context = locator<NavigationService>().navigationKey.currentState.overlay.context;
    if (request.actionButton != null) {
      Flushbar(
        title: request.title,
        message: request.message,
        duration: Duration(seconds: request.duration ?? 5),
        mainButton: FlatButton(
          onPressed: () {
            completeSnackbar(SnackbarResponse(confirmed: true));
          },
          child: Text(
            request.actionButton,
            style: TextStyle(color: Colors.amber),
          ),
        ),
      )..show(context).whenComplete(() => completeSnackbar(SnackbarResponse(confirmed: false)));
    } else
      Flushbar(
        title: request.title,
        message: request.message,
        duration: Duration(seconds: request.duration ?? 3),
      )..show(context).whenComplete(() => completeSnackbar(SnackbarResponse(confirmed: true)));
  }
}
