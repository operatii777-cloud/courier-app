/// Model pentru comanda de livrare
class DeliveryOrder {
  final int id;
  final int orderId;
  final String? orderNumber;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;

  DeliveryOrder({
    required this.id,
    required this.orderId,
    this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.total,
    required this.status,
    required this.createdAt,
    this.pickedUpAt,
    this.deliveredAt,
  });

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    // Backend returnează assigned_at, nu created_at
    DateTime parseDateTime(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        // Format: "2026-01-06 17:01:31"
        return DateTime.parse(dateStr.replaceAll(' ', 'T'));
      } catch (e) {
        print('⚠️ Error parsing date: $dateStr - $e');
        return DateTime.now();
      }
    }
    
    final status = (json['status'] ?? 'assigned').toString().toLowerCase();
    print('📦 Creating DeliveryOrder: id=${json['id']}, status=$status, order_id=${json['order_id']}');
    
    return DeliveryOrder(
      id: json['id'] ?? json['order_id'] ?? 0,
      orderId: json['order_id'] ?? json['id'] ?? 0,
      orderNumber: json['order_number']?.toString(),
      customerName: json['customer_name'] ?? 'Fără nume',
      customerPhone: json['customer_phone'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      status: status,
      createdAt: parseDateTime(json['assigned_at'] ?? json['created_at']),
      pickedUpAt: json['picked_up_at'] != null
          ? parseDateTime(json['picked_up_at'])
          : null,
      deliveredAt: json['delivered_at'] != null
          ? parseDateTime(json['delivered_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'order_number': orderNumber,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'total': total,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'picked_up_at': pickedUpAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }

  bool get isActive => status == 'assigned' || status == 'picked_up' || status == 'in_transit';
  bool get isDelivered {
    final result = status == 'delivered';
    if (result) {
      print('✅ Order $id is delivered (status: $status)');
    }
    return result;
  }
  
  String get statusText {
    switch (status) {
      case 'assigned':
        return 'Pregătit';
      case 'picked_up':
        return 'În Transit';
      case 'delivered':
        return 'Livrat';
      default:
        return status;
    }
  }
}

