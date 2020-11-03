import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/dialog/dialog_request.dart';
import 'package:flutter_chat/core/models/dialog/dialog_response.dart';
import 'package:flutter_chat/core/services/dialog/dialog_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/validators.dart';
import 'package:flutter_translate/global.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final _dialogService = locator<DialogService>();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _answers = new Map();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
    _dialogService.registerFormDialogListener(_showFormDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelButton != null;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(request.title ?? ''),
              content: Text(request.description ?? ''),
              actions: <Widget>[
                if (isConfirmationDialog)
                  FlatButton(
                    child: Text(request.cancelButton),
                    onPressed: () {
                      _dialogService.dialogComplete(DialogResponse(confirmed: false));
                    },
                  ),
                FlatButton(
                  child: Text(request.okButton),
                  onPressed: () {
                    _dialogService.dialogComplete(DialogResponse(confirmed: true));
                  },
                ),
              ],
            ));
  }

  void _showFormDialog(DialogFormRequest request) {
    if (_answers.isEmpty) {
      request.fields.forEach((key, value) {
        _answers.putIfAbsent(key, () => value.value);
      });
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(request.title ?? ''),
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildFields(request.fields),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(request.cancelButton),
                onPressed: () {
                  _formKey.currentState.reset();
                  _answers = new Map();
                  _dialogService.dialogComplete(DialogResponse(confirmed: false));
                },
              ),
              FlatButton(
                child: Text(request.okButton),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _dialogService.dialogComplete(DialogResponse(
                      answers: _answers,
                      confirmed: true,
                    ));
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> _selectDate(MapEntry<String, DialogField> entry) async {
    _answers[entry.key] = await showDatePicker(
      context: context,
      initialDate: entry.value.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 5)),
    );
  }

  List<Widget> _buildFields(Map<String, DialogField> fields) {
    return fields.entries.map((entry) {
      switch (entry.value.type) {
        case FieldType.DatePicker:
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(entry.value.label),
                MaterialButton(
                  child: Text(translate('buttons.pickDate')),
                  onPressed: () => _selectDate(entry),
                )
              ],
            ),
          );
        case FieldType.ImagePicker:
          //todo?
          return Container();
        case FieldType.Text:
          {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(children: [
                Text(entry.value.label),
                TextFormField(
                  initialValue: entry.value.value,
                  onChanged: (value) => _answers[entry.key] = value,
                  validator: validateRequired,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ]),
            );
          }
        default:
          return Container();
      }
    }).toList();
  }
}
