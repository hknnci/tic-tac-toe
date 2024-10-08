import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
import 'package:tic_tac_toe/widgets/generic_widgets.dart';

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

            // Determined the text color based on background brightness
            final isDarkBackground = _isDark(backgroundColor);
            final textColor = isDarkBackground ? Colors.white : Colors.black;

            final currentPlayer =
                game.currentTurn == 'X' ? game.playerOne : game.playerTwo;

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GenericText(
                      text: 'Game Name: ${game.gameName}',
                      fontSize: 24,
                    ),
                    const SizedBox(height: 8),
                    GenericText(
                      text:
                          'Current Turn: ${game.currentTurn} (${currentPlayer ?? 'Not determined'})',
                      fontSize: 24,
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      padding: const EdgeInsets.all(12),
                      itemCount: 9,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          context.read<GameProvider>().makeMove(context, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: textColor),
                            color: backgroundColor,
                          ),
                          child: Center(
                            child: Text(
                              game.boardState![index] == 0
                                  ? ''
                                  : game.boardState![index] == 1
                                      ? 'X'
                                      : 'O',
                              style: TextStyle(
                                fontSize: 32,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isDark(Color color) {
    // Used the luminance method to determine if the color is dark
    return color.computeLuminance() < 0.5;
  }
}
