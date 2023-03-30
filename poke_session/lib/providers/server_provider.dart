import 'dart:io';

import 'package:flutter/material.dart';

import '../utility.dart';

class ServerProvider extends ChangeNotifier {
  ServerSocket? server;
  List<Socket> clients = <Socket>[];

  /// Create a new server on the network and handle incoming connections
  Future<void> createServer() async {
    // Start server
    server = await ServerSocket.bind(InternetAddress.anyIPv4, 8080);
    Utility.printDebug(
        "Server listening on ${server!.address}:${server!.port}");

    // Handle incoming connections
    server!.listen((clientSocket) {
      Utility.printDebug(
          "New client connected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}");

      // Add the new client to the list of connected clients
      clients.add(clientSocket);

      // Notify all connected clients that a new client has connected
      final message =
          'New client connected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}\n';
      for (final client in clients) {
        if (client != clientSocket) {
          client.write(message);
        }
      }

      // Listen for data drom the client
      clientSocket.listen(
        (data) {
          Utility.printInfo(
              'Data from ${clientSocket.remoteAddress}:${clientSocket.remotePort}: $data');

          // Broadcast the received data to all connected clients
          for (final client in clients) {
            if (client != clientSocket) {
              client.write(data);
            }
          }
        },
        onDone: () {
          // Remove the disconnected client from the list of connected clients
          clients.remove(clientSocket);
          Utility.printDebug(
              'Client disconnected: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
        },
        onError: (e) {
          Utility.printError(
              'Error from ${clientSocket.remoteAddress}:${clientSocket.remotePort}: $e');
        },
      );
    });
  }
}
