class Game {
  String? id;
  String? gameName;
  String? boardColor;
  String? player1Id;
  String? player2Id;
  List<int>? boardState;
  String? currentTurn;
  String? status;

  Game({
    this.id,
    this.gameName,
    this.boardColor,
    this.player1Id,
    this.player2Id,
    this.boardState,
    this.currentTurn,
    this.status,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      gameName: json['game_name'],
      boardColor: json['board_color'],
      player1Id: json['player1_id'],
      player2Id: json['player2_id'],
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
      'player1_id': player1Id,
      'player2_id': player2Id,
      'status': status,
    };
  }
}
