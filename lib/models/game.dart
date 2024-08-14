class Game {
  String? id;
  String? gameName;
  String? boardColor;
  String? playerOne;
  String? playerTwo;
  List<int>? boardState;
  String? currentTurn;
  String? status;

  Game({
    this.id,
    this.gameName,
    this.boardColor,
    this.playerOne,
    this.playerTwo,
    this.boardState,
    this.currentTurn,
    this.status,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      gameName: json['game_name'],
      boardColor: json['board_color'],
      playerOne: json['player_one'],
      playerTwo: json['player_two'],
      boardState: json["board_state"] == null
          ? []
          : List<int>.from(json["board_state"]!.map((x) => x)),
      currentTurn: json['current_turn'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_name': gameName,
      'board_color': boardColor,
      'player_one': playerOne,
      'player_two': playerTwo,
      'status': status,
    };
  }
}
