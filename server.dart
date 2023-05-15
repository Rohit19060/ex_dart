import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  final ip = InternetAddress.anyIPv4;
  final server = await ServerSocket.bind(ip, 3000);
  print("Server is running on port ${server.address.address}:${server.port}");
  server.listen((event) {
    handleConnection(event);
  });
}

List<Socket> clients = [];

void handleConnection(Socket client) {
  print(
      "Server: Connection from ${client.remoteAddress.address}:${client.remotePort}");
  client.listen(
    (Uint8List data) {
      final msg = String.fromCharCodes(data).trim();
      clients.forEach((c) {
        c.write('Server: $msg');
      });
      clients.add(client);
      client.write('Server you are logged in $msg');
    },
    onError: (e) {
      print(e);
      client.close();
    },
    onDone: () {
      print('Client disconnected');
      client.close();
    },
  );
}
