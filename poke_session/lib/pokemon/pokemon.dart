enum PokemonType {
  normal,
  fire,
  water,
  electric,
  grass,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dragon,
  dark,
  steel,
  fairy
}

class Pokemon {
  final String name;
  String? nickname;
  final String imageUrl;
  final List<PokemonType> types;
  int level;
  int xp;
  int maxHp;
  int currentHp;
  int attack;
  int defense;
  int specialAttack;
  int specialDefense;
  int speed;

  Pokemon({
    required this.name,
    this.nickname,
    required this.imageUrl,
    required this.types,
    this.level = 1,
    this.xp = 0,
    this.maxHp = 10,
    this.currentHp = 10,
    this.attack = 10,
    this.defense = 10,
    this.specialAttack = 10,
    this.specialDefense = 10,
    this.speed = 10,
  });

  factory Pokemon.Torchic() {
    return Pokemon(
      name: 'Torchic',
      imageUrl:
          'https://archives.bulbagarden.net/media/upload/7/7d/0255Torchic.png',
      types: [PokemonType.fire],
      maxHp: 45,
      attack: 60,
      defense: 40,
      specialAttack: 70,
      specialDefense: 50,
      speed: 45,
    );
  }

  factory Pokemon.Cubone() {
    return Pokemon(
      name: 'Cubone',
      imageUrl:
          'https://archives.bulbagarden.net/media/upload/1/19/0104Cubone.png',
      types: [PokemonType.ground],
      maxHp: 50,
      attack: 50,
      defense: 95,
      specialAttack: 40,
      specialDefense: 50,
      speed: 35,
    );
  }

  factory Pokemon.Phantump() {
    return Pokemon(
      name: 'Phantump',
      imageUrl:
          'https://archives.bulbagarden.net/media/upload/d/d8/0708Phantump.png',
      types: [PokemonType.ghost, PokemonType.grass],
      maxHp: 43,
      attack: 70,
      defense: 48,
      specialAttack: 50,
      specialDefense: 60,
      speed: 38,
    );
  }

  void levelUp() {
    // TODO: Implement leveling up logic
  }

  int get xpToNextLevel {
    // TODO: Implement XP to next level logic
    return 0;
  }
}
