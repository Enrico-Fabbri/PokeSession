import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poke_session/providers/client_provider.dart';
import 'package:provider/provider.dart';

import '../providers/server_provider.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  // ignore: non_constant_identifier_names
  final TextEditingController IPController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var clientProvider = Provider.of<ClientProvider>(context);
    var serverProvider = Provider.of<ServerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheda Connessioni"),
        actions: [
          if (serverProvider.server != null)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.hub_outlined,
                color: Colors.blueAccent,
              ),
            ),
          if (clientProvider.client != null)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.share_outlined,
                color: Colors.blueAccent,
              ),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "IP",
                          ),
                          controller: IPController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () async {
                            if (IPController.text != "" &&
                                RegExp(r'^([^.]*.){3}[^.]*$')
                                    .hasMatch(IPController.text) &&
                                serverProvider.server == null) {
                              await clientProvider
                                  .createClient(IPController.text);
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.share_outlined,
                            color: serverProvider.server == null &&
                                    clientProvider.client == null
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: FutureBuilder(
                          future: _getDeviceIP(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return RichText(
                                text: TextSpan(
                                  text: "Hostando su ",
                                  children: [
                                    TextSpan(
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                      text: "${snapshot.data}",
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text('Error getting IP address');
                            } else {
                              return const Text('Getting IP address...');
                            }
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () async {
                            if (clientProvider.client == null) {
                              await serverProvider.createServer();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.hub_outlined,
                            color: clientProvider.client == null &&
                                    serverProvider.server == null
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get the device ip
  Future<String> _getDeviceIP() async {
    for (var interface in await NetworkInterface.list()) {
      for (var address in interface.addresses) {
        if (!address.isLoopback) {
          if (address.type == InternetAddressType.IPv4) {
            return address.address;
          }
        }
      }
    }
    return 'Unknown IP';
  }
}
