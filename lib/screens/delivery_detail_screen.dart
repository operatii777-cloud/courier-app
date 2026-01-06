import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../models/delivery_order.dart';
import '../services/api_service.dart';
import '../utils/navigation_utils.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final DeliveryOrder order;
  final VoidCallback onStatusUpdated;

  const DeliveryDetailScreen({
    super.key,
    required this.order,
    required this.onStatusUpdated,
  });

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool _isUpdating = false;

  Future<void> _updateStatus(String status) async {
    setState(() {
      _isUpdating = true;
    });

    final success = await ApiService.updateDeliveryStatus(
      deliveryId: widget.order.id,
      status: status,
    );

    if (mounted) {
      setState(() {
        _isUpdating = false;
      });

      if (success) {
        widget.onStatusUpdated();
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Eroare la actualizarea statusului'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleAction() async {
    if (widget.order.status == 'assigned') {
      // Preia comanda
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Preia Comanda'),
          content: const Text('Preiei comanda și pleci spre client?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Anulează'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Preia'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await _updateStatus('picked_up');
      }
    } else if (widget.order.status == 'picked_up') {
      // Confirmă livrare cu semnătură
      _showSignatureDialog();
    }
  }

  void _showSignatureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📝 Semnătură Client'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Signature(
            controller: _signatureController,
            backgroundColor: Colors.grey.shade100,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _signatureController.clear();
            },
            child: const Text('Șterge'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Anulează'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_signatureController.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semnătură obligatorie'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              Navigator.pop(context);
              await _updateStatus('delivered');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10b981),
            ),
            child: const Text('Confirmă Livrarea'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f172a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1e293b),
        title: Text(
          'Comandă #${widget.order.orderNumber ?? widget.order.id}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.customerName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          widget.order.customerPhone,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Address
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        const Text(
                          'Adresă Livrare',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.order.deliveryAddress,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Order info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.order.total.toStringAsFixed(0)} RON',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366f1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => NavigationUtils.makePhoneCall(widget.order.customerPhone),
                    icon: const Icon(Icons.phone),
                    label: const Text('Sună'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => NavigationUtils.openGoogleMaps(widget.order.deliveryAddress),
                    icon: const Icon(Icons.map),
                    label: const Text('Maps'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => NavigationUtils.openWaze(widget.order.deliveryAddress),
                    icon: const Icon(Icons.navigation),
                    label: const Text('Waze'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Main action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUpdating ? null : _handleAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.order.status == 'picked_up'
                      ? const Color(0xFF10b981)
                      : const Color(0xFF6366f1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.order.status == 'picked_up'
                            ? 'CONFIRMĂ LIVRAREA (POD)'
                            : 'PREIA COMANDA',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }
}

