import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poke_session/utility.dart';

class ClientProvider extends ChangeNotifier {
  Socket? client;

  /// Create a client and connect to the specified IP
  // ignore: non_constant_identifier_names
  Future<void> createClient(String IP) async {
    // Connect to the server
    client = await Socket.connect(IP, 8080);
    Utility.printDebug(
        "Connected to ${client!.remoteAddress}:${client!.remotePort}");

    // Listen for data from the server
    client!.listen(
      (data) {
        Utility.printInfo("Data from server: $data");
      },
      onError: (e) {
        Utility.printError("Error from server: $e");
      },
      onDone: () {
        Utility.printAttention("Server disconnected");
        client!.destroy();
      },
    );
  }
}
