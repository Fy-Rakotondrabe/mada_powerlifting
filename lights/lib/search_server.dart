import 'dart:io';

void searchForServer() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345);

  socket.listen((RawSocketEvent e) {
    print(e);
    if (e == RawSocketEvent.read) {
      Datagram? datagram = socket.receive();
      if (datagram != null) {
        String message = String.fromCharCodes(datagram.data);
        if (message.startsWith('FlutterServer')) {
          List<String> parts = message.split(':');
          String serverIp = parts[1];
          int serverPort = int.parse(parts[2]);
          print('Server found at $serverIp:$serverPort');
          // Use this IP and port to connect via HTTP
        }
      }
    }
  });
}
