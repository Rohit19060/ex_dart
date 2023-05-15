import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  final socket = await Socket.connect("192.168.1.36", 3000);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
  socket.listen(
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      print("Client $serverResponse");
    },
    onError: (error) {
      print("Client: $error");
      socket.destroy();
    },
    onDone: () {
      print('Client: Server left.');
      socket.destroy();
    },
  );

  String? username;

  do {
    print("Client: Please enter your username");
    username = stdin.readLineSync();
  } while (username == null || username.isEmpty);

  socket.write(username);
}
