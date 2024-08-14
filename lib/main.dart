import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<UserProvider>(
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
                theme: ThemeData(
                  primaryColor: const Color(0xFF4c662b),
                  scaffoldBackgroundColor: const Color(0xFFDCE7C8),
                  appBarTheme: const AppBarTheme(color: Color(0xFFf9faef)),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4c662b),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
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
      ),
    );
  }
}
