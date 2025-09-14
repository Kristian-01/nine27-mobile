import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/action_buttons_section.dart';
import './widgets/delivery_info_card.dart';
import './widgets/gps_tracking_section.dart';
import './widgets/order_details_section.dart';
import './widgets/order_history_section.dart';
import './widgets/order_status_card.dart';
import './widgets/order_timeline.dart';

class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  bool _isRefreshing = false;

  // Mock data for current order
  final Map<String, dynamic> currentOrder = {
  };

  // Mock data for order items
  final List<Map<String, dynamic>> orderItems = [
    {
      "id": 1,
      "name": "Paracetamol 500mg Tablets",
      "image":
          "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "quantity": 2,
      "price": "\$12.99",
      "isPrescription": false,
    },
    {
      "id": 2,
      "name": "Amoxicillin 250mg Capsules",
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "quantity": 1,
      "price": "\$24.50",
      "isPrescription": true,
    },
    {
      "id": 3,
      "name": "Vitamin D3 1000 IU Softgels",
      "image":
          "https://images.unsplash.com/photo-1550572017-edd951aa8f72?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "quantity": 1,
      "price": "\$18.75",
      "isPrescription": false,
    },
  ];

  // Mock data for order summary
  final Map<String, dynamic> orderSummary = {
    "subtotal": "\$56.24",
    "deliveryFee": "\$5.99",
    "tax": "\$4.97",
    "total": "\$67.20",
  };

  // Mock data for delivery information
  final Map<String, dynamic> deliveryInfo = {
    "address": "123 Main Street, Apartment 4B, New York, NY 10001",
    "contactName": "John Smith",
    "phoneNumber": "+1 (555) 123-4567",
    "deliveryInstructions":
        "Please ring the doorbell twice and leave at the door if no answer.",
  };

  // Mock data for GPS tracking
  final Map<String, dynamic> trackingData = {
    "deliveryPersonLat": 40.7589,
    "deliveryPersonLng": -73.9851,
    "deliveryLat": 40.7614,
    "deliveryLng": -73.9776,
    "estimatedArrival": "25-30 minutes",
  };

  // Mock data for order history
  final List<Map<String, dynamic>> orderHistory = [
    {
      "orderId": "MED2024089",
      "date": "Dec 28, 2024",
      "status": "Delivered",
      "total": "\$45.30",
    },
    {
      "orderId": "MED2024076",
      "date": "Dec 15, 2024",
      "status": "Delivered",
      "total": "\$32.80",
    },
    {
      "orderId": "MED2024063",
      "date": "Nov 30, 2024",
      "status": "Cancelled",
      "total": "\$28.50",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isTrackingAvailable = currentOrder["status"] == "Out for Delivery";
    final canEditDelivery = currentOrder["status"] == "Pending";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CustomAppBar(
        title: 'Order Tracking',
        showBackButton: true,
        centerTitle: true,
        showCartAction: true,
        cartItemCount: 3,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Current Order Status Card
             // Current Order Status Card
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
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 4,
        cartItemCount: 3,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    Fluttertoast.showToast(
      msg: "Order status updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
