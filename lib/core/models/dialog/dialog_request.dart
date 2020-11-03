import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DialogRequest {
  String title;
  String description;
  String okButton;
  String cancelButton;

  DialogRequest({
    @required this.title,
    @required this.description,
    this.okButton,
    this.cancelButton,
  }) {
    if (okButton == null) {
      this.okButton = translate('button.ok');
    }
  }
}

enum FieldType { Text, DatePicker, ImagePicker }

class DialogField {
  final FieldType type;
  final value;
  final String label;

  DialogField({@required this.type, this.value, @required this.label});
}

class DialogFormRequest {
  final String title;
  final String description;
  final Map<String, DialogField> fields;
  String okButton;
  String cancelButton;

  DialogFormRequest({
    @required this.title,
    this.description,
    this.okButton,
    this.cancelButton,
    @required this.fields,
  }) {
    if (cancelButton == null) {
      this.cancelButton = translate('button.cancel');
    }
    if (okButton == null) {
      this.cancelButton = translate('button.ok');
    }
  }
}
