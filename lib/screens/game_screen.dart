import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          Navigator.of(context).pushNamedAndRemoveUntil(
        '/gameListScreen',
        (Route<dynamic> route) => false,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final game = gameProvider.currentGame;

            if (game == null) {
              return const Center(child: Text('No game selected.'));
            }

            final backgroundColor = game.boardColor!.isNotEmpty
                ? Color(int.parse(game.boardColor!.replaceFirst('ff', '0xff')))
                : Colors.white;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Turn: ${game.currentTurn ?? 'Not determined'}',
                  style: const TextStyle(fontSize: 24),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<GameProvider>().makeMove(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: backgroundColor,
                        ),
                        child: Center(
                          child: Text(
                            game.boardState![index] == 0
                                ? ''
                                : game.boardState![index] == 1
                                    ? 'X'
                                    : 'O',
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
