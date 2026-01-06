import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/courier.dart';

class AuthService {
  static const String _tokenKey = 'courier_api_token';
  static const String _courierIdKey = 'courier_id';

  /// Login cu username și password
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login()),
        headers: ApiConfig.headers(),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['token'] != null) {
          // Salvează token-ul
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, data['token']);
          await prefs.setInt(_courierIdKey, data['courier']['id']);
          
          return {
            'success': true,
            'token': data['token'],
            'courier': Courier.fromJson(data['courier']),
          };
        } else {
          return {
            'success': false,
            'error': data['error'] ?? 'Autentificare eșuată',
          };
        }
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['error'] ?? 'Eroare la autentificare',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Eroare de conexiune: ${e.toString()}',
      };
    }
  }

  /// Verifică token-ul și obține info curier
  static Future<Courier?> verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.me()),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['courier'] != null) {
          return Courier.fromJson(data['courier']);
        }
      }
      return null;
    } catch (e) {
      print('Error verifying token: $e');
      return null;
    }
  }

  /// Obține token-ul salvat
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Obține ID-ul curierului salvat
  static Future<int?> getCourierId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_courierIdKey);
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_courierIdKey);
  }

  /// Verifică dacă utilizatorul este autentificat
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;
    
    final courier = await verifyToken(token);
    return courier != null;
  }
}

