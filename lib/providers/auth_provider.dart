import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _userRole;
  String? _userName;
  String? _userEmail;
  bool _isLoggedIn = false;

  String? get userRole => _userRole;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userRole = prefs.getString('userRole');
    _userName = prefs.getString('userName');
    _userEmail = prefs.getString('userEmail');
    _isLoggedIn = _userRole != null;
    notifyListeners();
  }

  Future<void> login(String role, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    
    _userRole = role;
    _userName = name;
    _userEmail = email;
    _isLoggedIn = true;
    
    await prefs.setString('userRole', role);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    _userRole = null;
    _userName = null;
    _userEmail = null;
    _isLoggedIn = false;
    
    await prefs.clear();
    
    notifyListeners();
  }

  // Mock login for staff
  Future<void> loginAsStaff() async {
    await login('staff', 'Sarah Martinez', 'sarah.martinez@email.com');
  }

  // Mock login for manager
  Future<void> loginAsManager() async {
    await login('manager', 'John Davis', 'john.davis@mercygeneral.com');
  }
}