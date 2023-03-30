import 'package:flutter/cupertino.dart';
import 'package:poke_session/pokemon/pokemon.dart';

class PlayerProvider extends ChangeNotifier {
//region Player Info
  /// The username of the player
  String _userName = "";

  String _title = "";

  /// The images from which the player can choose from
  final List<AssetImage> _icons = <AssetImage>[
    const AssetImage("assets/images/player/1.png"),
    const AssetImage("assets/images/player/2.png"),
    const AssetImage("assets/images/player/3.png"),
    const AssetImage("assets/images/player/4.png"),
  ];

  /// Get the list of possible images for the player
  List<AssetImage> get icons => _icons;

  /// The image that represents the player
  int _playerIconIndex = 0;

  /// Get the player username
  String get userName => _userName;

  /// Set the player username
  set userName(String value) {
    if (value.isEmpty) {
      throw ArgumentError("Name must be not null");
    }
    _userName = value;
    notifyListeners();
  }

  /// Get the player title
  String get title => _title;

  /// Set the player title
  set title(String value) {
    if (value.isEmpty) {
      throw ArgumentError("Name must be not null");
    }
    _title = value;
    notifyListeners();
  }

  /// Get the player icon
  int get playerIconIndex => _playerIconIndex;

  /// Set the player icon
  set playerIconIndex(int value) {
    /*if (value.isEmpty) {
      throw ArgumentError("Name must be not null");
    }*/
    _playerIconIndex = value;
    notifyListeners();
  }

  /// Get the AssetImage of the specified index value
  AssetImage playerIcon(int value) {
    if (value < 0 || value > 4) throw ErrorDescription("Value not in range");

    return _icons[value];
  }

//endregion

//region Starter pokemon
  final List<Pokemon> _starters = <Pokemon>[
    Pokemon.Phantump(),
    Pokemon.Cubone(),
    Pokemon.Torchic(),
  ];

  List<Pokemon> get starters => _starters;

//endregion

//region Player squad
  final List<Pokemon> _squad = <Pokemon>[];

  int starterIndex = 0;

  List<Pokemon> get squad => _squad;

  bool get hasStarter => _squad.isNotEmpty;

  void addPokemonToSquad(Pokemon pokemon) {
    if (_squad.length > 5) {
      throw ErrorHint("Unable to add another pokemon to squad");
    }
    _squad.add(pokemon);

    notifyListeners();
  }
//endregion
}
