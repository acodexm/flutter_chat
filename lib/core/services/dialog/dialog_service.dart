import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat/core/models/dialog/dialog_request.dart';
import 'package:flutter_chat/core/models/dialog/dialog_response.dart';

abstract class DialogService {
  GlobalKey<NavigatorState> get dialogNavigationKey;

  void registerDialogListener(Function(DialogRequest) showDialogListener);

  Future<DialogResponse> showDialog(DialogRequest request);

  void registerFormDialogListener(Function(DialogFormRequest) showDialogListener);

  Future<DialogResponse> showFormDialog(DialogFormRequest request);

  void dialogComplete(DialogResponse response);
}

class DialogServiceImpl implements DialogService {
  GlobalKey<NavigatorState> _dialogNavigationKey = GlobalKey<NavigatorState>();
  Function(DialogRequest) _showDialogListener;
  Function(DialogFormRequest) _showFormDialogListener;
  Completer<DialogResponse> _dialogCompleter;

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  void registerFormDialogListener(Function(DialogFormRequest) showDialogListener) {
    _showFormDialogListener = showDialogListener;
  }

  Future<DialogResponse> showDialog(DialogRequest request) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(request);
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(DialogResponse response) {
    _dialogNavigationKey.currentState.pop();
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }

  @override
  Future<DialogResponse> showFormDialog(DialogFormRequest request) {
    _dialogCompleter = Completer<DialogResponse>();
    _showFormDialogListener(request);
    return _dialogCompleter.future;
  }
}
