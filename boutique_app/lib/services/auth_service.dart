import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // For persistent storage
import 'dart:convert';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserRole; // Store user role (admin/customer)
  Map<String, dynamic>? _currentUser; // Store full user details

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserRole => _currentUserRole;
  Map<String, dynamic>? get currentUser => _currentUser;

  final String baseUrl =
      'http://localhost:5000/auth'; // Replace with your backend URL

  /// **Sign In Function**
  Future<String?> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Parse and save user data
      _isAuthenticated = true;
      _currentUserRole = data['role'];
      _currentUser = {
        'id': data['id'], // User ID
        'email': data['email'],
        'name': data['name'],
        'role': data['role'],
      };

      // Persist user data in shared preferences
      await _saveUserData();

      notifyListeners(); // Notify UI about state changes

      print('User logged in: $_currentUser'); // Log user details

      return _currentUserRole; // Return role for redirection
    } else {
      throw Exception('Failed to sign in');
    }
  }

  /// **Logout Function**
  void logout() async {
    _isAuthenticated = false;
    _currentUserRole = null;
    _currentUser = null;

    // Clear persisted data
    await _clearUserData();

    notifyListeners(); // Notify UI about logout
  }

  /// **Save User Data to SharedPreferences**
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isAuthenticated', _isAuthenticated);
    await prefs.setString('currentUserRole', _currentUserRole ?? '');
    await prefs.setString('currentUser', jsonEncode(_currentUser));
  }

  /// **Load User Data from SharedPreferences**
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentUserRole = prefs.getString('currentUserRole');
    final userData = prefs.getString('currentUser');

    if (userData != null) {
      _currentUser = jsonDecode(userData);
    }

    notifyListeners(); // Notify UI about state changes
  }

  /// **Clear User Data from SharedPreferences**
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
  }
}
