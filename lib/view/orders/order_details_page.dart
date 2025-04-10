import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_store_e_commerce_flutter/controller/order_provider.dart';
import 'package:super_store_e_commerce_flutter/imports.dart';
import 'package:super_store_e_commerce_flutter/model/cart_model.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch order details when page loads
    Future.microtask(() => Provider.of<OrderProvider>(context, listen: false)
        .fetchOrderDetails(widget.orderId));
  }

  @override
  void dispose() {
    // Clear selected order when leaving the page
    if (mounted) {
      Provider.of<OrderProvider>(context, listen: false).clearSelectedOrder();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  TextBuilder(
                    text: orderProvider.error!,
                    fontSize: 16,
                    color: Colors.red,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      orderProvider.fetchOrderDetails(widget.orderId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (orderProvider.selectedOrder == null) {
            return const Center(
              child: TextBuilder(
                text: 'Order not found',
                fontSize: 18,
              ),
            );
          }

          final order = orderProvider.selectedOrder!;
          final items = order['items'] as List<CartModel>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderHeader(order),
                const SizedBox(height: 24),
                _buildStatusSection(order['status']),
                const SizedBox(height: 24),
                _buildShippingSection(order['shippingAddress']),
                const SizedBox(height: 24),
                _buildPaymentSection(
                    order['paymentMethod'], order['totalAmount']),
                const SizedBox(height: 24),
                _buildItemsList(items),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(Map<String, dynamic> order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBuilder(
                  text: 'Order #${order['orderId'].substring(0, 8)}...',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                _buildStatusChip(order['status']),
              ],
            ),
            const SizedBox(height: 10),
            TextBuilder(
              text: 'Date: ${order['date'].substring(0, 16)}',
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(String status) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextBuilder(
              text: 'Order Status',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            _buildStatusProgressBar(status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusProgressBar(String currentStatus) {
    final statuses = ['pending', 'processing', 'shipped', 'delivered'];
    final currentIndex = statuses.indexOf(currentStatus.toLowerCase());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: statuses.asMap().entries.map((entry) {
        int index = entry.key;
        String status = entry.value;

        bool isActive = index <= (currentIndex != -1 ? currentIndex : 0);

        return Expanded(
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.green : Colors.grey[300],
                ),
                child: Icon(
                  _getStatusIcon(status),
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                status[0].toUpperCase() + status.substring(1),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'processing':
        return Icons.inventory;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildShippingSection(String address) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, size: 20),
                SizedBox(width: 8),
                TextBuilder(
                  text: 'Shipping Address',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextBuilder(
              text: address,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(String method, double amount) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.payment, size: 20),
                SizedBox(width: 8),
                TextBuilder(
                  text: 'Payment Details',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBuilder(
                  text: 'Payment Method:',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                TextBuilder(
                  text: method,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBuilder(
                  text: 'Total Amount:',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                TextBuilder(
                  text: '\$${amount.toStringAsFixed(2)}',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(List<CartModel> items) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextBuilder(
              text: 'Order Items',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildItemCard(item)).toList(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextBuilder(
                    text: 'Total Items:',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  TextBuilder(
                    text:
                        '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(CartModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(item.image ?? ''),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBuilder(
                  text: item.title ?? 'Product',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                TextBuilder(
                  text: 'Quantity: ${item.quantity}',
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
          TextBuilder(
            text: '\$${item.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case 'processing':
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        break;
      case 'shipped':
        backgroundColor = Colors.purple[100]!;
        textColor = Colors.purple[800]!;
        break;
      case 'delivered':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'cancelled':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1).toLowerCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
