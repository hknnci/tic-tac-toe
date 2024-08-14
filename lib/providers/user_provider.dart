import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider with ChangeNotifier {
  String? _userName;
  String? _userId;
  final SupabaseClient _client = Supabase.instance.client;

  String? get userName => _userName;
  String? get userId => _userId;

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName');
    _userId = prefs.getString('userId');
    log('Loaded user name: $_userName, user ID: $_userId');
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _userName = name;
    await prefs.setString('userName', name);
    log('Set user name: $name');

    // Create a new user in the database
    await _createUserInDatabase(name);

    notifyListeners();
  }

  Future<void> _createUserInDatabase(String name) async {
    try {
      final response =
          await _client.from('users').insert({'name': name}).select().single();
      if (response.isNotEmpty) {
        _userId = response['id'];
        log('User created successfully: $_userId');

        // Store the user ID in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', _userId!);
      } else {
        log('Failed to create user.');
      }
    } catch (error) {
      log('Error creating user: $error');
    }
  }
}
