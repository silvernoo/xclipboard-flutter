import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:xclipboard/util/target.dart';
import 'package:xclipboard/util/websocket.dart';

void main() => runApp(MyApp());

class ConstValue {}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xClipboard',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: MyHomePage(title: 'xClipboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var lastText;
  List record = [];

  @override
  void initState() {
    super.initState();
    var webSocket = WebSocket(Target("ws://172.24.3.227:9000", "default", "&*……UJM·12"));
    Timer(Duration(seconds: 1), () {
      FlutterClipboard.paste().then((value) {
        if (lastText != value) {
          webSocket.send(lastText);
          setState(() {
            record.add(value);
          });
        }
      });
    });
    webSocket.handle((event) {
      if (lastText != event && event != null && event != "") {
        print(event);
        FlutterClipboard.copy(event).then((value) => print('copied'));
        lastText = event;
        setState(() {
          record.add(event);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black87,
        child: ListView.builder(
          itemCount: record.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${record[index]}'),
                Divider(
                  height: 1,
                  color: Colors.white,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Server address',
        onPressed: _showServerDetails,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showServerDetails() {}
}
