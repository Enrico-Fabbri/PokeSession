import 'package:flutter/material.dart';
import 'package:poke_session/providers/player_provider.dart';
import 'package:provider/provider.dart';

class TrainerCardPage extends StatefulWidget {
  const TrainerCardPage({super.key});

  @override
  State<TrainerCardPage> createState() => _TrainerCardPageState();
}

class _TrainerCardPageState extends State<TrainerCardPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeTitle = FocusNode();
  bool _isKeyboardVisible = false;

  int _selectedPokemonIndex = -1;
  int _selectedIconIndex = 0;

  bool dataReloaded = false;

  @override
  void initState() {
    super.initState();

    focusNodeName.addListener(() {
      setState(() {
        _isKeyboardVisible = focusNodeName.hasFocus;
      });
    });
    focusNodeTitle.addListener(() {
      setState(() {
        _isKeyboardVisible = focusNodeTitle.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNodeName.dispose();
    focusNodeTitle.dispose();
    super.dispose();
  }

  void _onItemPressed(int index, PlayerProvider provider) {
    setState(() {
      if (!provider.hasStarter) {
        _selectedPokemonIndex = index;
      }
    });
  }

  void _reloadData(PlayerProvider playerProvider) {
    if (dataReloaded) return;
    // Reload saved data
    nameController.text = playerProvider.userName;
    titleController.text = playerProvider.title;

    _selectedIconIndex = playerProvider.playerIconIndex;
    _selectedPokemonIndex = playerProvider.starterIndex;
    dataReloaded = true;
  }

  @override
  Widget build(BuildContext context) {
    var playerProvider = Provider.of<PlayerProvider>(context);

    // TODO: substitute images with player animation

    _reloadData(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheda Allenatore"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flex(
              crossAxisAlignment: CrossAxisAlignment.start,
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Nome",
                            hintText: "Francesco Ferdinando",
                          ),
                          focusNode: focusNodeName,
                          onTapOutside: (_) => focusNodeName.unfocus(),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: "Titolo",
                            hintText: "Il mangiatore di slowpoke",
                          ),
                          focusNode: focusNodeTitle,
                          onTapOutside: (_) => focusNodeName.unfocus(),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: IconButton(
                      icon: SizedBox(
                        width: 144,
                        height: 144,
                        child: Image(
                          image: playerProvider.playerIcon(_selectedIconIndex),
                          fit: BoxFit.cover,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Scelta aspetto giocatore"),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: playerProvider.icons.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Center(
                                        child: SizedBox(
                                          width: 116,
                                          height: 116,
                                          child: Image(
                                            image: playerProvider
                                                .playerIcon(index),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedIconIndex = index;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Pokemon iniziale"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 200,
                    child: GridView.builder(
                      itemCount: playerProvider.starters.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _onItemPressed(index, playerProvider),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedPokemonIndex == index
                                    ? Colors.blue
                                    : Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  playerProvider.starters[index].imageUrl,
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  playerProvider.starters[index].name,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !_isKeyboardVisible,
              child: Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Save the username
                      playerProvider.userName = nameController.text;
                      // Save the title
                      playerProvider.title = titleController.text;
                      // Save the icon index
                      playerProvider.playerIconIndex = _selectedIconIndex;

                      if (_selectedPokemonIndex == -1) return;
                      // Save the starter index
                      playerProvider.starterIndex = _selectedPokemonIndex;
                      // Add the pokemon to the squad
                      playerProvider.addPokemonToSquad(
                          playerProvider.starters[_selectedPokemonIndex]);
                    },
                    tooltip: 'Save',
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.save),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
