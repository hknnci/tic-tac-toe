class Game {
  final String id;
  final String gameName;
  final String boardColor;
  final String player1Id;
  final String player2Id;
  final List<int> boardState;
  final String currentTurn;
  final String status;

  Game({
    required this.id,
    required this.gameName,
    required this.boardColor,
    required this.player1Id,
    required this.player2Id,
    required this.boardState,
    required this.currentTurn,
    required this.status,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      gameName: json['game_name'],
      boardColor: json['board_color'],
      player1Id: json['player1_id'],
      player2Id: json['player2_id'],
      boardState: List<int>.from(json['board_state']),
      currentTurn: json['current_turn'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_name': gameName,
      'board_color': boardColor,
      'player1_id': player1Id,
      'player2_id': player2Id,
      'board_state': boardState,
      'current_turn': currentTurn,
      'status': status,
    };
  }
}
