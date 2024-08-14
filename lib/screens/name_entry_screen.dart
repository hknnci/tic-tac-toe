import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/user_provider.dart';
import 'package:tic_tac_toe/screens/game_list_screen.dart';
import 'package:tic_tac_toe/widgets/generic_widgets.dart';

class NameEntryScreen extends StatelessWidget {
  final _controller = TextEditingController();

  NameEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Username')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GenericTextFormField(
                controller: _controller,
                hintText: 'Name',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final name = _controller.text.trim();
                  if (name.isNotEmpty) {
                    Provider.of<UserProvider>(context, listen: false)
                        .setUserName(name)
                        .then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameListScreen(),
                        ),
                      );
                    });
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
