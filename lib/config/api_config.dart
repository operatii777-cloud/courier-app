/// Configurare API pentru aplicația curier
class ApiConfig {
  // ============================================
  // CONFIGURARE URL BACKEND
  // ============================================
  
  // Când telefonul face hotspot:
  // 1. Laptopul se conectează la hotspot
  // 2. Rulează: server/detect-hotspot-ip.ps1
  // 3. Scriptul detectează automat IP-ul laptopului în rețeaua hotspot
  // 4. Actualizează acest fișier cu IP-ul detectat
  
  // IP-uri comune pentru hotspot-uri:
  // - Android: 192.168.43.x sau 192.168.137.x
  // - iPhone: 172.20.10.x
  // - Windows Mobile Hotspot: 192.168.137.x
  
  // ============================================
  // CONFIGURARE ACTUALĂ
  // ============================================
  // TODO: Rulează detect-hotspot-ip.ps1 pentru a actualiza automat
  // SAU schimbă manual cu IP-ul laptopului în rețeaua hotspot
  // IMPORTANT: Dacă telefonul face hotspot, conectează laptopul la hotspot
  // și verifică IP-ul laptopului în rețeaua hotspot (de obicei 192.168.43.x)
  static const String baseUrl = 'http://192.168.50.238:3001';
  
  // ============================================
  // ENDPOINTS (nu modifica)
  // ============================================
  static String get apiUrl => '$baseUrl/api';
  
  // Courier endpoints
  static String login() => '$apiUrl/couriers/login';
  static String me() => '$apiUrl/couriers/me';
  static String assignments({String? status}) {
    final statusParam = status != null ? '?status=$status' : '';
    return '$apiUrl/couriers/me/assignments$statusParam';
  }
  static String updateDeliveryStatus(int deliveryId) => 
      '$apiUrl/couriers/delivery/$deliveryId/status';
  static String updateLocation() => '$apiUrl/couriers/me/location';
  
  // Headers
  static Map<String, String> headers({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}
