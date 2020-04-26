import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:xclipboard/dialog/add_address_dialog.dart';
import 'package:xclipboard/util/store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XClipboard',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: MyHomePage(title: 'XClipboard'),
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
  IOWebSocketChannel ioWebSocketChannel;

  String _text;

  IconData _icon = Icons.add;

  @override
  void initState() {
    dataManager.serverInfoController.stream.listen((data) {
      var uri = Uri(
        scheme: "ws",
        host: data.address.split(":")[0],
        port: int.parse(data.address.split(":")[1]),
        queryParameters: {"user": data.user},
      );
      print(uri.toString());
      ioWebSocketChannel = IOWebSocketChannel.connect(uri.toString());
      ioWebSocketChannel.stream.listen((data) {
        setState(() {
          _text = data;
        });
      });
      setState(() {
        _icon = Icons.delete_outline;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.red,
        child: Column(
          children: <Widget>[
            Text("$_text"),
            FlatButton(
              onPressed: () {
                _send();
              },
              child: Text("SEND"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addServerAddress,
        tooltip: 'Add Server address',
        child: Icon(_icon),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _addServerAddress() {
    showDialog<String>(
        context: context,
        builder: (BuildContext buildContext) {
          return SystemPadding();
        });
  }

  void _send() async {
    var data = await Clipboard.getData('text/plain');
    ioWebSocketChannel.sink.add(data.text);
  }
}
