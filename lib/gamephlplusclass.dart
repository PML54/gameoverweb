import 'dart:core';

// Das cette classe on met à jour  des données sensibles sans relire  la totale
//C'est de l'update
// UN statut de Game ne  nécessite  pas de tout relire

class GamesPlus {
  int gamecode = 0;
  int gamestatus = 0;

  GamesPlus({
    required this.gamecode,
    required this.gamestatus,
  });

  factory GamesPlus.fromJson(Map<String, dynamic> json) {
    return GamesPlus(
      gamecode: int.parse(json['GAMECODE']),
      gamestatus: int.parse(json['GAMESTATUS']),
    );
  }
}

class GamersPlus {
  int uid = 0;
  int gamecode = 0;
  int gustatus = 0;

  GamersPlus({
    required this.uid,
    required this.gamecode,
    required this.gustatus,
  });

  factory GamersPlus.fromJson(Map<String, dynamic> json) {
    return GamersPlus(
      uid: int.parse(json['UID']),
      gamecode: int.parse(json['GAMECODE']),
      gustatus: int.parse(json['GUSTATUS']),
    );
  }
}
