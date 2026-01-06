import 'package:url_launcher/url_launcher.dart';

class NavigationUtils {
  /// Deschide Google Maps cu adresa
  static Future<void> openGoogleMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$encodedAddress';
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Deschide Waze cu adresa
  static Future<void> openWaze(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = 'https://www.waze.com/ul?q=$encodedAddress';
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Deschide aplicația de telefon pentru apelare
  static Future<void> makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

