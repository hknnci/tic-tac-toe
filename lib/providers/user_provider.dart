import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider with ChangeNotifier {
  String? _userName;
  final SupabaseClient _client = Supabase.instance.client;

  String? get userName => _userName;

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName');
    log('Loaded user name: $_userName'); // Debugging log
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _userName = name;
    await prefs.setString('userName', name);
    log('Set user name: $name'); // Debugging log

    // Create a new user in the database
    await _createUserInDatabase(name);

    notifyListeners();
  }

  Future<void> _createUserInDatabase(String name) async {
    try {
      final response =
          await _client.from('users').insert({'name': name}).select().single();
      if (response.isNotEmpty) {
        log('User created successfully: ${response['id']}');
      } else {
        log('Failed to create user.');
      }
    } catch (error) {
      log('Error creating user: $error');
    }
  }
}
