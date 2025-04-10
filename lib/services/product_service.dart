import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:super_store_e_commerce_flutter/model/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products from Firestore
  Future<List<ProductModel>> getProducts() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromJson({
          'id': int.tryParse(doc.id) ?? 0,
          ...data,
        });
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting products: $e');
      }
      return [];
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromJson({
          'id': int.tryParse(doc.id) ?? 0,
          ...data,
        });
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting products by category: $e');
      }
      return [];
    }
  }

  // Get a single product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('products').doc(productId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromJson({
          'id': int.tryParse(doc.id) ?? 0,
          ...data,
        });
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting product: $e');
      }
      return null;
    }
  }

  // Initialize Firestore with sample products (for first-time setup)
  Future<void> initializeProducts(List<ProductModel> products) async {
    try {
      // Check if products collection is empty
      final snapshot = await _firestore.collection('products').limit(1).get();

      if (snapshot.docs.isEmpty) {
        // Batch write products to Firestore
        final WriteBatch batch = _firestore.batch();

        for (var product in products) {
          final docRef =
              _firestore.collection('products').doc(product.id.toString());
          batch.set(docRef, product.toJson());
        }

        await batch.commit();
        if (kDebugMode) {
          print('Initialized products in Firestore');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing products: $e');
      }
    }
  }
}
