import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../model/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  User? _user;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;
  String? get token => _token;

  /// 🔐 LOGIN
  Future<void> login(String email, String password) async {
    final success = await AuthService.login(email, password);
    if (success) {
      _isAuthenticated = true;
      _token = await AuthService.getToken();
      notifyListeners();
    } else {
      throw Exception('Login gagal');
    }
  }

  /// 🧾 REGISTER
  Future<void> register(
      String name, String email, String password, String phone) async {
    final success = await AuthService.register(name, email, password, phone);
    if (success) {
      _isAuthenticated = true;
      _token = await AuthService.getToken();
      notifyListeners();
    } else {
      throw Exception('Registrasi gagal');
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    await AuthService.logout();
    _isAuthenticated = false;
    _user = null;
    _token = null;
    notifyListeners();
  }
}
