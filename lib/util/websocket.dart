import 'package:web_socket_channel/io.dart';
import 'package:xclipboard/util/target.dart';

class WebSocket {
  IOWebSocketChannel ioWebSocketChannel;
  var onData;

  WebSocket(Target t) {
    print(t.rawAddress);
    ioWebSocketChannel = IOWebSocketChannel.connect(t.rawAddress);
  }

  handle(void onData(dynamic event)) {
    this.onData = onData;
    ioWebSocketChannel.stream.listen((event) {
      onData(event);
    });
  }

  send(String data) {
    ioWebSocketChannel.sink.add(data);
  }
}
