import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
import 'package:tic_tac_toe/screens/game_create_screen.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  @override
  void initState() {
    super.initState();
    // GameProvider'dan oyunları çekmek
    context.read<GameProvider>().fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game List'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.games.isEmpty) {
            return const Center(child: Text('No games available.'));
          }

          return ListView.builder(
            itemCount: gameProvider.games.length,
            itemBuilder: (context, index) {
              final game = gameProvider.games[index];
              return ListTile(
                title: Text(game.gameName ?? 'Unnamed Game'),
                subtitle: Text(game.status ?? 'Status not available'),
                onTap: () {
                  gameProvider.setCurrentGame(game);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/gameScreen',
                    (Route<dynamic> route) => false,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GameCreateScreen(),
            ),
          );
        },
        tooltip: 'Create Game',
        child: const Icon(Icons.add),
      ),
    );
  }
}
