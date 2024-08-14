import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
import 'package:tic_tac_toe/screens/game_create_screen.dart';
import 'package:tic_tac_toe/widgets/generic_widgets.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  @override
  void initState() {
    super.initState();
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
          if (gameProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (gameProvider.games.isEmpty) {
            return const Center(
              child: GenericText(
                text: 'No games available',
                fontSize: 18,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: gameProvider.games.length,
            itemBuilder: (context, index) {
              final game = gameProvider.games[index];
              return Card(
                elevation: 4.0,
                color: const Color(0xFFf9faef),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(
                    color: Color(0xFFf9faef),
                    width: 1.0,
                  ),
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: ListTile(
                  title: GenericText(text: game.gameName ?? 'Unnamed Game'),
                  subtitle: GenericText(text: game.status ?? 'Game Continues'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _confirmDelete(context, game, gameProvider),
                  ),
                  onTap: game.status == 'Completed'
                      ? null
                      : () {
                          context.read<GameProvider>().setCurrentGame(game);
                          Navigator.of(context).pushNamed('/gameScreen');
                        },
                ),
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
        backgroundColor: const Color(0xFF4c662b),
        tooltip: 'Create Game',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    Game game,
    GameProvider gameProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: const Text('Are you sure you want to delete this game?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();

                await gameProvider.deleteGame(
                  game.id!,
                  () => GenericFlushbar.showSuccessFlushbar(
                    context,
                    'Game deleted successfully!',
                  ),
                  (message) => GenericFlushbar.showErrorFlushbar(
                    context,
                    message,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
