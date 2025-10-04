import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import './widgets/action_buttons_section.dart';
import './widgets/order_history_section.dart';
import './widgets/order_status_card.dart';
import './widgets/order_timeline.dart';
import '../../services/order_service.dart';
import '../../services/cart_service.dart';

class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  bool _isRefreshing = false;
  bool _didInit = false;
  int? _routeOrderId;

  Map<String, dynamic> currentOrder = {};

  List<Map<String, dynamic>> orderHistory = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['orderId'] != null) {
        final raw = args['orderId'];
        int? id;
        if (raw is int) id = raw;
        else if (raw is String) id = int.tryParse(raw);
        _routeOrderId = id;
      }
      _loadInitial();
      _didInit = true;
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      final service = OrderService();
      final listResp = await service.getOrders(page: 1);
      if (listResp.success) {
        final data = listResp.data;
        final orders = (data is Map && data['data'] is List) ? data['data'] as List : (data as List? ?? []);
        orderHistory = orders.map<Map<String, dynamic>>((o) {
          final m = Map<String, dynamic>.from(o as Map);
          return {
            'orderId': m['id']?.toString() ?? 'N/A',
            'date': m['created_at']?.toString() ?? 'N/A',
            'status': m['status']?.toString() ?? 'Pending',
            'total': (m['total'] ?? m['total_amount'] ?? m['subtotal'])?.toString() ?? 'N/A',
          };
        }).toList();

        dynamic firstId = _routeOrderId;
        if (firstId == null && orders.isNotEmpty) {
          firstId = orders.first['id'];
        }
        if (firstId != null) {
          final id = firstId is int ? firstId : int.tryParse(firstId.toString());
          if (id != null) {
            final detailResp = await service.getOrder(id);
            if (detailResp.success) {
              currentOrder = Map<String, dynamic>.from(detailResp.data as Map);
            }
          }
        }
      }
    } catch (_) {}
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isTrackingAvailable = currentOrder["status"] == "Out for Delivery";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Order Tracking',
        showBackButton: true,
        centerTitle: true,
        showCartAction: true,
        cartItemCount: CartService().totalItems,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              OrderStatusCard(orderData: currentOrder.isNotEmpty ? currentOrder : {
                "orderId": "N/A",
                "orderDate": "N/A",
                "status": "Pending",
                "estimatedDelivery": "N/A",
                "deliveryAddress": "N/A",
              }),

              // Order Progress Timeline
              OrderTimeline(currentStatus: (currentOrder["status"] ?? "Pending")),

              // Action Buttons Section
              ActionButtonsSection(
                orderStatus: (currentOrder["status"] ?? "Pending"),
                deliveryPersonPhone: isTrackingAvailable ? "+1 (555) 987-6543" : null,
              ),

              // Order History Section
              OrderHistorySection(orderHistory: orderHistory),

              // Bottom padding for navigation
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      final service = OrderService();
      final listResp = await service.getOrders(page: 1);
      if (listResp.success) {
        final data = listResp.data;
        final orders = (data is Map && data['data'] is List) ? data['data'] as List : (data as List? ?? []);
        orderHistory = orders.map<Map<String, dynamic>>((o) {
          final m = Map<String, dynamic>.from(o as Map);
          return {
            'orderId': m['id']?.toString() ?? 'N/A',
            'date': m['created_at']?.toString() ?? 'N/A',
            'status': m['status']?.toString() ?? 'Pending',
            'total': (m['total'] != null) ? '\\${m['total']}' : 'N/A',
          };
        }).toList();

        if (orders.isNotEmpty) {
          final firstId = orders.first['id'];
          final detailResp = await service.getOrder(firstId);
          if (detailResp.success) {
            currentOrder = Map<String, dynamic>.from(detailResp.data as Map);
          }
        }
      }
    } catch (_) {}
    setState(() {
      _isRefreshing = false;
    });
    Fluttertoast.showToast(msg: "Order status updated");
  }
}
