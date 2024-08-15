# tic_tac_toe

This is a turn-based Tic Tac Toe game developed using Flutter. The app uses Supabase for real-time data updates. Players can create games, join existing games, and view a list of games. The app also features user authentication and personalized settings.

# Features

**User Authentication**
- Users can enter their name, which will be associated with their gameplay. The name is stored locally using SharedPreferences and is also saved to Supabase for listing games with related user_id.

**Game Creation**
- Users can create a new Tic Tac Toe game by specifying a game name, selecting a board background color, and inviting two participants.

**Real-Time Game Updates**
- The app uses Supabase for real-time updates, ensuring that all players see the current state of the game board as moves are made.

**Game List**
- Users can view a list of available games. The list includes information about the participants and the current status of each game.
- The app displays the winner's name and marker (X or O) once a game is completed.
- Games can be deleted, with a confirmation dialog shown before deletion.

# Technologies Used

- Flutter (Channel beta, 3.23.0-0.1.pre)
- Supabase
- Provider
- another_flushbar
- flutter_colorpicker
- flutter_dotenv
- shared_preferences

# Getting Started

- Clone the project => `git clone https://github.com/hknnci/tic-tac-toe.git`
- Navigate to the project folder => `cd tic_tac_toe`
- Install dependencies => `flutter pub get`
- Run the app => `flutter run`

## License

This project is licensed under the MIT License. For more information, see the LICENSE file.
