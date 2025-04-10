import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:super_store_e_commerce_flutter/model/cart_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Place an order
  Future<String?> placeOrder({
    required List<CartModel> cartItems,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return null;
      }

      // Create order document
      final docRef = await _firestore.collection('orders').add({
        'userId': user.uid,
        'items': cartItems.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'status': 'pending',
        'createdAt': Timestamp.now(),
      });

      // Add order ID to user's orders collection
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(docRef.id)
          .set({
        'orderId': docRef.id,
        'totalAmount': totalAmount,
        'createdAt': Timestamp.now(),
        'status': 'pending',
      });

      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        print('Error placing order: $e');
      }
      return null;
    }
  }

  // Get user's orders
  Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return [];
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Convert Timestamp to readable date string
        Timestamp timestamp = data['createdAt'] as Timestamp;
        String dateString = DateTime.fromMillisecondsSinceEpoch(
                timestamp.millisecondsSinceEpoch)
            .toString()
            .split(' ')[0];

        return {
          'orderId': doc.id,
          'totalAmount': data['totalAmount'],
          'status': data['status'],
          'date': dateString,
        };
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting orders: $e');
      }
      return [];
    }
  }

  // Get order details
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      final DocumentSnapshot orderDoc =
          await _firestore.collection('orders').doc(orderId).get();

      if (!orderDoc.exists) {
        return null;
      }

      Map<String, dynamic> data = orderDoc.data() as Map<String, dynamic>;

      // Convert Timestamp to readable date string
      Timestamp timestamp = data['createdAt'] as Timestamp;
      String dateString =
          DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch)
              .toString();

      List<dynamic> itemsList = data['items'] as List<dynamic>;
      List<CartModel> items = itemsList
          .map((item) => CartModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return {
        'orderId': orderId,
        'totalAmount': data['totalAmount'],
        'status': data['status'],
        'date': dateString,
        'shippingAddress': data['shippingAddress'],
        'paymentMethod': data['paymentMethod'],
        'items': items,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting order details: $e');
      }
      return null;
    }
  }
}
