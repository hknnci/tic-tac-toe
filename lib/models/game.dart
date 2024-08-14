class Game {
  String? id;
  String? userId;
  String? gameName;
  String? boardColor;
  String? playerOne;
  String? playerTwo;
  List<int>? boardState;
  String? currentTurn;
  String? status;
  String? winnerSymbol;
  String? winnerName;

  Game({
    this.id,
    this.userId,
    this.gameName,
    this.boardColor,
    this.playerOne,
    this.playerTwo,
    this.boardState,
    this.currentTurn,
    this.status,
    this.winnerSymbol,
    this.winnerName,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      userId: json['user_id'],
      gameName: json['game_name'],
      boardColor: json['board_color'],
      playerOne: json['player_one'],
      playerTwo: json['player_two'],
      boardState: json["board_state"] == null
          ? []
          : List<int>.from(json["board_state"]!.map((x) => x)),
      currentTurn: json['current_turn'],
      status: json['status'],
      winnerSymbol: json['winner_symbol'],
      winnerName: json['winner_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'game_name': gameName,
      'board_color': boardColor,
      'player_one': playerOne,
      'player_two': playerTwo,
      'status': status,
      'winner_symbol': winnerSymbol,
      'winner_name': winnerName,
    };
  }
}
