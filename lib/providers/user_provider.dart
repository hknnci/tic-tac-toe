import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _userName;

  String? get userName => _userName;

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName');
    print('Loaded user name: $_userName'); // Debugging log
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _userName = name;
    await prefs.setString('userName', name);
    print('Set user name: $name'); // Debugging log
    notifyListeners();
  }
}
