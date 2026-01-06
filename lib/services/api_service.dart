import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/delivery_order.dart';
import 'auth_service.dart';

class ApiService {
  /// Obține comenzile atribuite curierului
  static Future<List<DeliveryOrder>> getAssignments({
    String? status,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Nu ești autentificat');
      }

      // Include toate statusurile pentru a obține și istoricul (delivered)
      final statusParam = status ?? 'assigned,picked_up,in_transit,delivered';
      final response = await http.get(
        Uri.parse(ApiConfig.assignments(status: statusParam)),
        headers: ApiConfig.headers(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📦 API Response: success=${data['success']}, deliveries count=${data['deliveries']?.length ?? 0}');
        
        if (data['success'] == true) {
          final deliveries = data['deliveries'] ?? data['assignments'] ?? [];
          print('📋 Raw deliveries: $deliveries');
          
          final orders = (deliveries as List)
              .map((json) {
                print('🔄 Parsing delivery: id=${json['id']}, status=${json['status']}');
                return DeliveryOrder.fromJson(json);
              })
              .toList();
          
          print('✅ Parsed orders: ${orders.length}, delivered: ${orders.where((o) => o.isDelivered).length}');
          return orders;
        } else {
          print('❌ API returned success=false: ${data['error']}');
        }
      } else {
        print('❌ HTTP ${response.statusCode}: ${response.body}');
      }
      
      return [];
    } catch (e, stackTrace) {
      print('❌ Error fetching assignments: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Actualizează statusul unei livrări
  static Future<bool> updateDeliveryStatus({
    required int deliveryId,
    required String status,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Nu ești autentificat');
      }

      final response = await http.put(
        Uri.parse(ApiConfig.updateDeliveryStatus(deliveryId)),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      
      return false;
    } catch (e) {
      print('Error updating delivery status: $e');
      return false;
    }
  }

  /// Actualizează locația curierului (GPS tracking)
  static Future<bool> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      print('📍 [API] updateLocation called: lat=$latitude, lng=$longitude');
      final token = await AuthService.getToken();
      if (token == null) {
        print('❌ [API] Token lipsește');
        throw Exception('Nu ești autentificat');
      }

      print('📍 [API] Sending PUT request to ${ApiConfig.updateLocation()}');
      final response = await http.put(
        Uri.parse(ApiConfig.updateLocation()),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode({
          'lat': latitude,
          'lng': longitude,
        }),
      );

      print('📍 [API] Response status: ${response.statusCode}');
      print('📍 [API] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final success = data['success'] == true;
        print('📍 [API] Update success: $success');
        return success;
      } else {
        print('❌ [API] HTTP error: ${response.statusCode} - ${response.body}');
      }
      
      return false;
    } catch (e, stackTrace) {
      print('❌ [API] Error updating location: $e');
      print('❌ [API] Stack trace: $stackTrace');
      return false;
    }
  }
}

