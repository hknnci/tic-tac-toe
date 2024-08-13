import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_toe/providers/user_provider.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
import 'package:tic_tac_toe/screens/game_create_screen.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/screens/name_entry_screen.dart';
import 'package:tic_tac_toe/screens/game_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://khcgsjvpphebxabzurdc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtoY2dzanZwcGhlYnhhYnp1cmRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM1NDYyMzcsImV4cCI6MjAzOTEyMjIzN30.Ik9KWdl9xizYRMNgi68EMgCioj6pMnHJJBVMI8Zs_2w',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return FutureBuilder(
          future: userProvider.loadUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            return MaterialApp(
              home: userProvider.userName == null
                  ? NameEntryScreen()
                  : const GameListScreen(),
              routes: {
                '/gameListScreen': (context) => const GameListScreen(),
                '/gameCreateScreen': (context) => const GameCreateScreen(),
                '/gameScreen': (context) => const GameScreen(),
                '/nameEntryScreen': (context) => NameEntryScreen(),
              },
            );
          },
        );
      },
    );
  }
}
