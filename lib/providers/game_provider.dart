import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'dart:developer';
import 'package:tic_tac_toe/widgets/generic_widgets.dart';

class GameProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  List<Game> _games = [];
  Game? _currentGame;
  bool _isLoading = false;

  List<Game> get games => _games;
  Game? get currentGame => _currentGame;
  bool get isLoading => _isLoading;

  Future<void> fetchGames(String userId) async {
    _isLoading = true;
    // Used Future.microtask to notify listeners after the current build phase
    Future.microtask(() => notifyListeners());

    try {
      //it will list games by filtering with user_id
      final response =
          await _client.from('games').select().eq('user_id', userId);
      if (response.isNotEmpty) {
        _games = response.map((game) => Game.fromJson(game)).toList();
        notifyListeners();
      } else {
        log('No games found.');
        _games = [];
      }
    } catch (error) {
      log('Error fetching games: $error');
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  Future<void> createGame(Game game) async {
    try {
      final response =
          await _client.from('games').insert(game.toJson()).select().single();
      if (response.isNotEmpty) {
        final createdGame = Game.fromJson(response);
        _games.add(createdGame);
        _currentGame = createdGame;
        notifyListeners();
      } else {
        log('Failed to create game.');
      }
    } catch (error) {
      log('Error creating game: $error');
    }
  }

  Future<void> updateBoard(
    Game game,
    List<int> newBoardState,
    String newTurn,
  ) async {
    // checking if game.id is null
    if (game.id == null) {
      log('Game ID is null. Cannot update the board.');
      return;
    }

    final updatedGame = game.toJson();
    updatedGame['board_state'] = newBoardState;
    updatedGame['current_turn'] = newTurn;

    try {
      final response = await _client
          .from('games')
          .update(updatedGame)
          .eq('id', game.id!)
          .select()
          .single();
      if (response.isNotEmpty) {
        _currentGame = Game.fromJson(response);
        notifyListeners();
      } else {
        log('Failed to update board.');
      }
    } catch (error) {
      log('Error updating board: $error');
    }
  }

  Future<void> makeMove(BuildContext context, index) async {
    if (_currentGame == null || _currentGame!.status == 'Completed') return;

    // Prevent move if the cell is already taken
    if (_currentGame!.boardState![index] != 0) return;

    // Update board state
    _currentGame!.boardState![index] = _currentGame!.currentTurn == 'X' ? 1 : 2;

    // Check for win or draw
    final result = _checkGameResult(_currentGame!.boardState!);
    if (result != null) {
      if (result == 'Draw') {
        // Board resetting after draw
        GenericFlushbar.showInfoFlushbar(
          context,
          'It\'s a Draw! The game has been restarted.',
        );
        _currentGame!.boardState = List.filled(9, 0);
        _currentGame!.currentTurn = 'X';
      } else {
        _currentGame!.status = 'Completed';
        _currentGame!.winnerSymbol = result;
        _currentGame!.winnerName =
            result == 'X' ? _currentGame!.playerOne : currentGame!.playerTwo;

        GenericFlushbar.showSuccessFlushbar(
          context,
          'Player $result wins! You may back to game list screen after review your marvelous win!',
        );
      }

      await updateBoard(
        _currentGame!,
        _currentGame!.boardState!,
        _currentGame!.currentTurn!,
      );

      notifyListeners();
      return;
    }

    // Switch turn
    _currentGame!.currentTurn = _currentGame!.currentTurn == 'X' ? 'O' : 'X';

    await updateBoard(
      _currentGame!,
      _currentGame!.boardState!,
      _currentGame!.currentTurn!,
    );
  }

  String? _checkGameResult(List<int> boardState) {
    // Check for a win
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      final a = boardState[pattern[0]];
      final b = boardState[pattern[1]];
      final c = boardState[pattern[2]];

      if (a != 0 && a == b && a == c) {
        return a == 1 ? 'X' : 'O';
      }
    }

    // Check for a draw
    if (!boardState.contains(0)) {
      return 'Draw';
    }

    return null;
  }

  Future<void> deleteGame(
    String gameId,
    VoidCallback onSuccess,
    void Function(String message) onError,
  ) async {
    try {
      await _client.from('games').delete().eq('id', gameId);
      _games.removeWhere((game) => game.id == gameId);
      notifyListeners();
      onSuccess();
    } catch (error) {
      log('Error deleting game: $error');
      onError('Error deleting game: $error');
    }
  }

  void setCurrentGame(Game game) {
    _currentGame = game;
    notifyListeners();
  }
}
