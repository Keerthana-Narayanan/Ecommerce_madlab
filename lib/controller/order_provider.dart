import 'package:flutter/foundation.dart';
import 'package:super_store_e_commerce_flutter/model/cart_model.dart';
import 'package:super_store_e_commerce_flutter/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Map<String, dynamic>> _orders = [];
  Map<String, dynamic>? _selectedOrder;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get orders => [..._orders];
  Map<String, dynamic>? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch user's orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _orderService.getUserOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load orders.';
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching orders: $e');
      }
    }
  }

  // Fetch order details
  Future<void> fetchOrderDetails(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedOrder = await _orderService.getOrderDetails(orderId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load order details.';
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching order details: $e');
      }
    }
  }

  // Place new order
  Future<bool> placeOrder({
    required List<CartModel> cartItems,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String? orderId = await _orderService.placeOrder(
        cartItems: cartItems,
        totalAmount: totalAmount,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
      );

      _isLoading = false;

      if (orderId != null) {
        await fetchOrders(); // Refresh orders list
        return true;
      } else {
        _error = 'Failed to place order.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'An error occurred while placing your order.';
      notifyListeners();
      if (kDebugMode) {
        print('Error placing order: $e');
      }
      return false;
    }
  }

  // Clear selected order
  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }
}
