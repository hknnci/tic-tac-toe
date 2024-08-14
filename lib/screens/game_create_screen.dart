import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
import 'package:tic_tac_toe/providers/user_provider.dart';
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
  bool _isPlayer1Disabled = true; // Player 1 is disabled by default

  @override
  void initState() {
    super.initState();
    final userName = Provider.of<UserProvider>(context, listen: false).userName;
    _player2Controller.text = _generateRandomPlayerName();
    if (userName != null) {
      _player1Controller.text = userName;
    } else {
      _player1Controller.text = _generateRandomPlayerName();
    }
  }

  String _generateRandomPlayerName() {
    final random = Random();
    final randomNumber = random.nextInt(9000) + 1000;
    return 'Player$randomNumber';
  }

  void _swapPlayers() {
    final temp = _player1Controller.text;
    _player1Controller.text = _player2Controller.text;
    _player2Controller.text = temp;

    // Toggle the disabled state
    setState(() {
      _isPlayer1Disabled = !_isPlayer1Disabled;
    });
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
                  _buildPlayerBox(
                      _player1Controller, 'Player 1', _isPlayer1Disabled),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 54),
                    child: IconButton(
                      icon: Icon(
                        Icons.swap_horiz,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      onPressed: _swapPlayers,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildPlayerBox(
                      _player2Controller, 'Player 2', !_isPlayer1Disabled),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GenericText(
                    text: 'Background Color:',
                    fontWeight: FontWeight.normal,
                  ),
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

  Widget _buildPlayerBox(
    TextEditingController controller,
    String label,
    bool isDisabled,
  ) {
    return Expanded(
      child: Column(
        children: [
          const Icon(Icons.person, size: 50, color: Color(0xFF586249)),
          const SizedBox(height: 8),
          GenericTextFormField(
            controller: controller,
            hintText: label,
            enabled: !isDisabled,
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
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final gameName = _gameNameController.text;
    final player1Name = _player1Controller.text;
    final player2Name = _player2Controller.text;

    if (gameName.isEmpty || player1Name.isEmpty || player2Name.isEmpty) return;

    final game = Game(
      gameName: gameName,
      boardColor: _backgroundColor.value.toRadixString(16),
      playerOne: player1Name,
      playerTwo: player2Name,
      userId: userProvider.userId,
    );

    await gameProvider.createGame(game);

    if (!mounted || gameProvider.currentGame == null) return;

    Navigator.of(context).pushNamed('/gameScreen');
  }
}
