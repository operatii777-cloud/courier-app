import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/delivery_order.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/order_card.dart';
import 'delivery_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DeliveryOrder> _orders = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
    
    // Auto-refresh la fiecare 30 secunde
    Future.delayed(const Duration(seconds: 30), _autoRefresh);
    
    // Start GPS tracking
    _startLocationTracking();
  }

  void _autoRefresh() {
    if (mounted) {
      _loadOrders(showRefresh: false);
      Future.delayed(const Duration(seconds: 30), _autoRefresh);
    }
  }

  /// Verifică și solicită permisiuni GPS
  Future<bool> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('⚠️ Serviciul de locație este dezactivat');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('⚠️ Permisiunea de locație a fost refuzată');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('⚠️ Permisiunea de locație este refuzată permanent');
      return false;
    }

    return true;
  }

  /// Obține locația curentă și o trimite la server
  Future<void> _updateLocation() async {
    try {
      print('📍 [GPS] Încep actualizarea locației...');
      final hasPermission = await _checkLocationPermissions();
      if (!hasPermission) {
        print('⚠️ [GPS] Permisiunea GPS nu este acordată');
        return;
      }

      print('📍 [GPS] Obțin locația curentă...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print('📍 [GPS] Locație obținută: ${position.latitude}, ${position.longitude}');
      print('📍 [GPS] Trimite la server...');

      final success = await ApiService.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (success) {
        print('✅ [GPS] Locație actualizată cu succes: ${position.latitude}, ${position.longitude}');
      } else {
        print('❌ [GPS] Eroare la actualizarea locației (server returned false)');
      }
    } catch (e, stackTrace) {
      print('❌ [GPS] Eroare: $e');
      print('❌ [GPS] Stack trace: $stackTrace');
    }
  }

  /// Pornește tracking-ul GPS (la fiecare 30 secunde)
  void _startLocationTracking() {
    // Actualizează imediat
    _updateLocation();
    
    // Apoi la fiecare 30 secunde
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _updateLocation();
        _startLocationTracking(); // Recursiv pentru tracking continuu
      }
    });
  }

  Future<void> _loadOrders({bool showRefresh = true}) async {
    if (showRefresh) {
      setState(() {
        _isRefreshing = true;
      });
    }

    try {
      final orders = await ApiService.getAssignments();
      print('🏠 HomeScreen: Received ${orders.length} orders');
      print('🏠 Active orders: ${orders.where((o) => o.isActive).length}');
      print('🏠 Delivered orders: ${orders.where((o) => o.isDelivered).length}');
      
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      print('❌ HomeScreen error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  int _calculateEarnings() {
    final delivered = _orders.where((o) => o.isDelivered).length;
    return delivered * 15; // 15 RON per livrare
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deconectare'),
        content: const Text('Ești sigur că vrei să te deconectezi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anulează'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deconectează'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AuthService.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = _orders.where((o) => o.isActive).toList();
    final historyOrders = _orders.where((o) => o.isDelivered).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0f172a), // slate-900
      appBar: AppBar(
        backgroundColor: const Color(0xFF1e293b), // slate-800
        elevation: 0,
        title: const Text(
          'Mod Curier',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isRefreshing ? null : () => _loadOrders(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF6366f1),
          tabs: [
            Tab(
              icon: const Icon(Icons.delivery_dining),
              text: 'Active (${activeOrders.length})',
            ),
            Tab(
              icon: const Icon(Icons.history),
              text: 'Istoric (${historyOrders.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366f1)),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                // Active Tab
                activeOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nicio livrare activă',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadOrders(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: activeOrders.length,
                          itemBuilder: (context, index) {
                            final order = activeOrders[index];
                            return OrderCard(
                              order: order,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeliveryDetailScreen(
                                      order: order,
                                      onStatusUpdated: () => _loadOrders(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                
                // History Tab
                historyOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nicio livrare finalizată azi',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: historyOrders.length,
                        itemBuilder: (context, index) {
                          final order = historyOrders[index];
                          return Card(
                            color: const Color(0xFF1e293b),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                'Livrare #${order.orderNumber ?? order.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                order.deliveredAt != null
                                    ? 'Livrat: ${_formatTime(order.deliveredAt!)}'
                                    : 'Livrat',
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    color: Colors.green.shade400,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+15 RON',
                                    style: TextStyle(
                                      color: Colors.green.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
      // Earnings banner
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1e293b),
          border: Border(
            top: BorderSide(color: Colors.grey.shade800),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Câștig Azi',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_calculateEarnings()} RON',
              style: const TextStyle(
                color: Color(0xFF10b981),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

