import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
import 'package:tic_tac_toe/widgets/generic_widgets.dart';

class GameCreateScreen extends StatefulWidget {
  const GameCreateScreen({super.key});

  @override
  State<GameCreateScreen> createState() => _GameCreateScreenState();
}

class _GameCreateScreenState extends State<GameCreateScreen> {
  final _gameNameController = TextEditingController();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  Color _backgroundColor = const Color(0xFFf9faef);

  @override
  void initState() {
    super.initState();
    _player1Controller.text = _generateRandomPlayerName();
    _player2Controller.text = _generateRandomPlayerName();
  }

  String _generateRandomPlayerName() {
    final random = Random();
    final randomNumber = random.nextInt(9000) + 1000;
    return 'Player$randomNumber';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GenericTextFormField(
                controller: _gameNameController,
                hintText: 'Game Name',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlayerBox(_player1Controller, 'Player 1'),
                  const SizedBox(width: 16),
                  _buildPlayerBox(_player2Controller, 'Player 2'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  Widget _buildPlayerBox(TextEditingController controller, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(Icons.person, size: 50, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          GenericTextFormField(
            controller: controller,
            hintText: label,
          ),
        ],
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
      playerOne: player1Name,
      playerTwo: player2Name,
    );

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.createGame(game);

    if (!mounted || gameProvider.currentGame == null) return;

    Navigator.of(context).pushNamed('/gameScreen');
  }
}
