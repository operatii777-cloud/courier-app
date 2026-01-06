/// Model pentru curier
class Courier {
  final int id;
  final String code;
  final String name;
  final String? phone;
  final String? email;
  final String status;
  final String? vehicleType;

  Courier({
    required this.id,
    required this.code,
    required this.name,
    this.phone,
    this.email,
    required this.status,
    this.vehicleType,
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? 'Curier',
      phone: json['phone'],
      email: json['email'],
      status: json['status'] ?? 'offline',
      vehicleType: json['vehicle_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'phone': phone,
      'email': email,
      'status': status,
      'vehicle_type': vehicleType,
    };
  }
}

