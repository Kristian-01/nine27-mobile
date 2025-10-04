import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/checkout_progress_widget.dart';
import './widgets/delivery_info_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/terms_conditions_widget.dart';
import './widgets/prescription_verification_widget.dart';
import '../../services/order_service.dart';
import '../../services/cart_service.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _termsAccepted = false;
  String _selectedPaymentMethod = 'cod';
  Map<String, String> _uploadedPrescriptions = {};

  Map<String, String> _deliveryData = {
    'name': '',
    'phone': '',
    'address': '',
    'city': '',
    'zip': '',
    'deliveryDate': '',
    'deliveryTime': '',
  };

  

  final List<String> _checkoutSteps = [
    'Delivery',
    'Review',
    'Payment',
    'Complete'
  ];

  List<Map<String, dynamic>> get _cartItems => CartService().cartItems;

  List<Map<String, dynamic>> get _prescriptionItems => _cartItems
      .where((item) => (item['prescription_required'] as bool?) == true)
      .toList();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
  switch (_currentStep) {
    case 0: // Delivery Information
      return _deliveryData['name']!.isNotEmpty &&
          _deliveryData['phone']!.isNotEmpty &&
          _deliveryData['address']!.isNotEmpty &&
          _deliveryData['city']!.isNotEmpty &&
          _deliveryData['zip']!.isNotEmpty;
    case 2: // Payment & Terms
      final requiresPrescription = _prescriptionItems.isNotEmpty;
      final hasAllPrescriptions = !requiresPrescription ||
          _prescriptionItems.every((item) =>
              _uploadedPrescriptions.containsKey(item['id'].toString()));
      return _termsAccepted &&
          _selectedPaymentMethod.isNotEmpty &&
          hasAllPrescriptions;
    default:
      return true;
  }
}


  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _checkoutSteps.length - 1) {
        setState(() {
          _currentStep++;
        });
        _scrollToTop();
      } else {
        _placeOrder();
      }
    } else {
      _showValidationError();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _scrollToTop();
    }
  }

  void _showValidationError() {
    String message = '';
    switch (_currentStep) {
      case 0:
        message = 'Please fill in all delivery information fields';
        break;
      case 2:
        final requiresPrescription = _prescriptionItems.isNotEmpty;
        final missingRx = requiresPrescription && !_prescriptionItems.every(
          (item) => _uploadedPrescriptions.containsKey(item['id'].toString()),
        );
        if (missingRx) {
          message = 'Please upload prescriptions for all required items';
        } else {
          message =
              'Please accept terms and conditions and select payment method';
        }
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
      ),
    );
  }

  Future<void> _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final orderService = OrderService();

      final billingAddress = {
        'name': _deliveryData['name'],
        'phone': _deliveryData['phone'],
        'address': _deliveryData['address'],
        'city': _deliveryData['city'],
        'postal_code': _deliveryData['zip'],
      };
      final shippingAddress = Map<String, dynamic>.from(billingAddress);

      // Prepare client-side cart line items (product_id, quantity)
      final items = _cartItems.map<Map<String, dynamic>>((i) => {
            'product_id': i['id'],
            'quantity': i['quantity'],
          }).toList();

      final response = await orderService.createOrder(
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        paymentMethod: _selectedPaymentMethod,
        items: items,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.success) {
        CartService().clearCart();
        _showOrderConfirmation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  void _showOrderConfirmation() {
    final orderId =
        'MD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final estimatedDelivery = DateTime.now().add(const Duration(days: 2));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 48,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Order Placed Successfully!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successLight,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ID:',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        orderId,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimated Delivery:',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        '${estimatedDelivery.day}/${estimatedDelivery.month}/${estimatedDelivery.year}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'You will receive SMS updates about your order status. Thank you for choosing MediCart!',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to tracking and pass orderId so it opens that order
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/order-tracking',
                (route) => false,
                arguments: {'orderId': orderId},
              );
            },
            child: Text('Track Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home-screen',
                (route) => false,
              );
            },
            child: Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      ),
      body: Column(
        children: [
          CheckoutProgressWidget(
            currentStep: _currentStep,
            steps: _checkoutSteps,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  if (_currentStep == 0) ...[
                    DeliveryInfoWidget(
                      deliveryData: _deliveryData,
                      onDataChanged: (data) {
                        setState(() {
                          _deliveryData = data;
                        });
                      },
                    ),
                  ],
                  if (_currentStep >= 1) ...[
                    OrderSummaryWidget(
                      cartItems: _cartItems,
                      onEditCart: () {
                        Navigator.pushNamed(context, '/shopping-cart');
                      },
                    ),
                   
                  ],
                  if (_currentStep >= 2) ...[
                    if (_prescriptionItems.isNotEmpty)
                      PrescriptionVerificationWidget(
                        prescriptionItems: _prescriptionItems,
                        uploadedPrescriptions: _uploadedPrescriptions,
                        onPrescriptionUploaded: (itemId, filePath) {
                          setState(() {
                            _uploadedPrescriptions[itemId] = filePath;
                          });
                        },
                      ),
                    PaymentMethodWidget(
                      selectedPaymentMethod: _selectedPaymentMethod,
                      onPaymentMethodChanged: (method) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                    ),
                    TermsConditionsWidget(
                      isAccepted: _termsAccepted,
                      onAcceptanceChanged: (accepted) {
                        setState(() {
                          _termsAccepted = accepted;
                        });
                      },
                    ),
                  ],
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentStep >= 1) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '\$${_calculateTotal().toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 3.w),
                  Expanded(
                    flex: _currentStep > 0 ? 2 : 1,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _currentStep == _checkoutSteps.length - 1
                                  ? 'Place Order'
                                  : 'Continue',
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotal() {
    final subtotal = _cartItems.fold(0.0, (sum, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = item['quantity'] as int? ?? 1;
      return sum + (price * quantity);
    });

    final tax = subtotal * 0.08;
    final deliveryFee = subtotal > 50 ? 0.0 : 5.99;

    return subtotal + tax + deliveryFee;
  }
}
