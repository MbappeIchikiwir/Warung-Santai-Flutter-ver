import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = 'http://192.168.44.82:8000/api'; // Ganti sesuai IP backend-mu
final storage = FlutterSecureStorage();

class AuthService {
  /// 🔐 LOGIN
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      if (token != null) {
        await storage.write(key: 'token', value: token);
        print('✅ Login sukses');
        return true;
      } else {
        print('❌ Token tidak ditemukan di response');
        return false;
      }
    } else {
      print('❌ Login gagal: ${response.body}');
      return false;
    }
  }

  /// 🧾 REGISTER
  static Future<bool> register(
      String name, String email, String password, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      if (token != null) {
        await storage.write(key: 'token', value: token);
        print('✅ Register sukses');
        return true;
      } else {
        print('❌ Token tidak ditemukan setelah register');
        return false;
      }
    } else {
      print('❌ Register gagal: ${response.body}');
      return false;
    }
  }

  /// 👤 GET USER
  static Future<void> getUser() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('👤 User data: ${response.body}');
    } else {
      print('❌ Gagal ambil data user: ${response.body}');
    }
  }

  /// 🚪 LOGOUT
  static Future<void> logout() async {
    final token = await storage.read(key: 'token');
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    await storage.delete(key: 'token');
    print('🚪 Logout berhasil');
  }

  /// 🔁 REFRESH TOKEN
  static Future<void> refreshToken() async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newToken = data['access_token'];
      await storage.write(key: 'token', value: newToken);
      print('♻️ Token diperbarui');
    } else {
      print('❌ Refresh gagal: ${response.body}');
    }
  }

  /// 🧰 Helper: Ambil token dari storage
  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}
