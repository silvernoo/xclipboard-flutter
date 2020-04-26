import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xclipboard/util/model.dart';
import 'package:xclipboard/util/store.dart';

// ignore: must_be_immutable
class SystemPadding extends StatelessWidget {
  SystemPadding({Key key}) : super(key: key);

  TextEditingController _addressController = new TextEditingController(text: "172.16.16.169:9000");
  TextEditingController _keyController = new TextEditingController(text: "123");
  TextEditingController _userController = new TextEditingController(text: "mato");

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new TextField(
            autofocus: true,
            decoration: new InputDecoration(labelText: 'Address and Port'),
            controller: _addressController,
          ),
          new TextField(
            autofocus: true,
            decoration: new InputDecoration(labelText: 'Key'),
            controller: _keyController,
          ),
          new TextField(
            autofocus: true,
            decoration: new InputDecoration(labelText: 'User'),
            controller: _userController,
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: const Text('SAVE'),
            onPressed: () {
              _save(context);
            }),
      ],
    );
  }

  void _save(BuildContext context) async {
    await dataManager.save(ServerInfo(_addressController.text, _keyController.text, _userController.text));
    Navigator.pop(context);
  }
}
