import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';

class GameCreateScreen extends StatefulWidget {
  const GameCreateScreen({super.key});

  @override
  State<GameCreateScreen> createState() => _GameCreateScreenState();
}

class _GameCreateScreenState extends State<GameCreateScreen> {
  final _gameNameController = TextEditingController();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  Color _backgroundColor = Colors.white;
  final _gameNameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _gameNameController,
              focusNode: _gameNameFocus,
              decoration: const InputDecoration(
                labelText: 'Game Name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _player1Controller,
              decoration: const InputDecoration(
                labelText: 'Player 1 Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _player2Controller,
              decoration: const InputDecoration(
                labelText: 'Player 2 Name',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Background Color:'),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _pickColor,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: _backgroundColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createGame,
              child: const Text('Create Game'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickColor() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            onColorChanged: (Color color) {
              setState(() {
                _backgroundColor = color;
              });
            },
            pickerColor: _backgroundColor,
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: true,
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Done'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _createGame() async {
    final gameName = _gameNameController.text;
    final player1Name = _player1Controller.text;
    final player2Name = _player2Controller.text;

    if (gameName.isEmpty || player1Name.isEmpty || player2Name.isEmpty) return;

    final game = Game(
      gameName: gameName,
      boardColor: _backgroundColor.value.toRadixString(16),
      player1Id: player1Name,
      player2Id: player2Name,
    );

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.createGame(game);

    // checking if the widget is still mounted before navigating
    if (!mounted || gameProvider.currentGame == null) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/gameScreen',
      (Route<dynamic> route) => false, // clearing all previous routes
    );
  }
}
