import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:super_store_e_commerce_flutter/model/cart_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user's cart collection reference
  CollectionReference _userCartRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  // Get current user's cart
  Future<List<CartModel>> getUserCart() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return [];
      }

      final QuerySnapshot querySnapshot = await _userCartRef(user.uid).get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CartModel.fromJson({
          'id': int.tryParse(doc.id) ?? 0,
          ...data,
        });
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user cart: $e');
      }
      return [];
    }
  }

  // Add item to cart
  Future<void> addToCart(CartModel cartItem) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return;
      }

      // Check if item already exists in cart
      final DocumentSnapshot existingItem =
          await _userCartRef(user.uid).doc(cartItem.id.toString()).get();

      if (existingItem.exists) {
        // Update quantity and total price
        Map<String, dynamic> data = existingItem.data() as Map<String, dynamic>;
        int currentQuantity = data['quantity'] ?? 0;
        double currentPrice = data['price'] ?? 0.0;

        await _userCartRef(user.uid).doc(cartItem.id.toString()).update({
          'quantity': currentQuantity + (cartItem.quantity ?? 1),
          'totalPrice':
              (currentQuantity + (cartItem.quantity ?? 1)) * currentPrice,
        });
      } else {
        // Add new item
        await _userCartRef(user.uid)
            .doc(cartItem.id.toString())
            .set(cartItem.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to cart: $e');
      }
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(int itemId) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return;
      }

      await _userCartRef(user.uid).doc(itemId.toString()).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error removing from cart: $e');
      }
    }
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity(int itemId, int quantity) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return;
      }

      // Get the current item
      final DocumentSnapshot item =
          await _userCartRef(user.uid).doc(itemId.toString()).get();

      if (item.exists) {
        Map<String, dynamic> data = item.data() as Map<String, dynamic>;
        double price = data['price'] ?? 0.0;

        await _userCartRef(user.uid).doc(itemId.toString()).update({
          'quantity': quantity,
          'totalPrice': quantity * price,
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating cart: $e');
      }
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return;
      }

      final QuerySnapshot querySnapshot = await _userCartRef(user.uid).get();

      final WriteBatch batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cart: $e');
      }
    }
  }

  // Listen to cart changes
  Stream<List<CartModel>> cartStream() {
    final User? user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _userCartRef(user.uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CartModel.fromJson({
          'id': int.tryParse(doc.id) ?? 0,
          ...data,
        });
      }).toList();
    });
  }
}
