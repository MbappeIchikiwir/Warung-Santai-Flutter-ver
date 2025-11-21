// lib/config/api.dart
class ApiConfig {
  // Dev: Hotspot lu, Production: Ganti ke https://api.warungsantai.com/api
  static const String baseUrl =
      'http://10.20.30.14:8000/api'; // Port 8000 standar Laravel
  static const String loginEndpoint = '/login';
  static const String productsEndpoint = '/products';
  static const String postsEndpoint = '/posts';

  // Helper buat headers - pake di api_service
  static Map<String, String> authHeaders([String? token]) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
