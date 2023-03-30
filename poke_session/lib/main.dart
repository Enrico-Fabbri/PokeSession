import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poke_session/pages/connections_page.dart';
import 'package:poke_session/pages/trainer_card.dart';
import 'package:poke_session/providers/client_provider.dart';
import 'package:poke_session/providers/player_provider.dart';
import 'package:poke_session/providers/server_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ServerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClientProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlayerProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // block landscape orientation
      DeviceOrientation.portraitDown, // block reverse portrait orientation
    ]);

    var playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("PokéSession"),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TrainerCardPage()),
              ),
              child: Text(playerProvider.userName == ""
                  ? "Premi per creare la tua scheda allenatore"
                  : "Premi per modificare la tua scheda allenatore"),
            ),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConnectionsPage()),
              ),
              child: const Text(
                  "Premi per accedere alla scheda delle Connessioni"),
            ),
          ],
        ),
      ),
    );
  }
}
