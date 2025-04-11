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

      // If no products exist, initialize with sample data
      if (querySnapshot.docs.isEmpty) {
        await initializeProducts(getSampleProducts());
        // Fetch again after initialization
        final newSnapshot = await _firestore.collection('products').get();
        return newSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return ProductModel.fromJson({
            'id': int.tryParse(doc.id) ?? 0,
            ...data,
          });
        }).toList();
      }

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

  // Get products by gender
  Future<List<ProductModel>> getProductsByGender(String gender) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('gender', isEqualTo: gender)
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
        print('Error getting products by gender: $e');
      }
      return [];
    }
  }

  // Get products by subcategory
  Future<List<ProductModel>> getProductsBySubCategory(
      String subCategory) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('subCategory', isEqualTo: subCategory)
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
        print('Error getting products by subCategory: $e');
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

  // Initialize Firestore with sample products
  Future<void> initializeProducts(List<ProductModel> products) async {
    try {
      // First clear existing products
      await clearProducts();

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
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing products: $e');
      }
    }
  }

  // Clear all products from Firestore
  Future<void> clearProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();

      if (snapshot.docs.isNotEmpty) {
        final WriteBatch batch = _firestore.batch();

        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
        if (kDebugMode) {
          print('Cleared products from Firestore');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing products: $e');
      }
    }
  }

  // Sample products with added women's clothing items
  List<ProductModel> getSampleProducts() {
    // Rating for products
    final Rating rating = Rating(rate: 4.5, count: 120);

    return [
      // Women's Clothing Items
      ProductModel(
        id: 1,
        title: "Summer Dress",
        price: 1299.99,
        description:
            "Beautiful summer dress perfect for beach outings and casual day wear.",
        category: "clothing",
        subCategory: "dress",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1618932260643-eee4a2f652a6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["XS", "S", "M", "L", "XL"],
        rating: rating,
      ),
      ProductModel(
        id: 2,
        title: "Winter Jacket",
        price: 2499.99,
        description:
            "Warm and comfortable winter jacket for cold weather. Water-resistant and windproof.",
        category: "clothing",
        subCategory: "jacket",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1548126032-079a0fb0099d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["S", "M", "L", "XL"],
        rating: rating,
      ),
      ProductModel(
        id: 3,
        title: "Skinny Jeans",
        price: 999.99,
        description:
            "Classic skinny jeans that provide comfort and style for everyday wear.",
        category: "clothing",
        subCategory: "jeans",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["26", "28", "30", "32", "34"],
        rating: rating,
      ),
      ProductModel(
        id: 4,
        title: "Yoga Pants",
        price: 599.99,
        description:
            "High-quality yoga pants designed for maximum flexibility and comfort during workouts.",
        category: "clothing",
        subCategory: "activewear",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1506629082955-511b1aa562c8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["XS", "S", "M", "L"],
        rating: rating,
      ),
      ProductModel(
        id: 5,
        title: "Formal Blazer",
        price: 1899.99,
        description:
            "Professional-looking blazer for formal occasions, meetings, and office wear.",
        category: "clothing",
        subCategory: "blazer",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1608234808654-2a8875faa7fd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["S", "M", "L", "XL"],
        rating: rating,
      ),
      ProductModel(
        id: 6,
        title: "Casual T-Shirt",
        price: 499.99,
        description:
            "Comfortable casual t-shirt for everyday wear made from 100% cotton.",
        category: "clothing",
        subCategory: "tshirt",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["XS", "S", "M", "L", "XL", "XXL"],
        rating: rating,
      ),
      ProductModel(
        id: 7,
        title: "Denim Jacket",
        price: 1599.99,
        description:
            "Classic denim jacket that never goes out of style. Perfect for layering in all seasons.",
        category: "clothing",
        subCategory: "jacket",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1592878904946-b3cd8ae243d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["S", "M", "L"],
        rating: rating,
      ),
      ProductModel(
        id: 8,
        title: "Leggings - Workout Edition",
        price: 699.99,
        description:
            "High-performance leggings for workouts and yoga with moisture-wicking fabric.",
        category: "clothing",
        subCategory: "leggings",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["XS", "S", "M", "L"],
        rating: rating,
      ),
      ProductModel(
        id: 10,
        title: "Party Wear Crop Top",
        price: 799.99,
        description:
            "Stylish crop top for parties and casual outings with friends.",
        category: "clothing",
        subCategory: "top",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["XS", "S", "M", "L"],
        rating: rating,
      ),

      // Men's Clothing Items
      ProductModel(
        id: 11,
        title: "Formal Shirt",
        price: 899.99,
        description: "Classic formal shirt for office and meetings.",
        category: "clothing",
        subCategory: "shirt",
        gender: "men",
        image:
            "https://images.unsplash.com/photo-1598033129183-c4f50c736f10?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["38", "40", "42", "44"],
        rating: rating,
      ),
      ProductModel(
        id: 12,
        title: "Relaxed Fit Jeans",
        price: 1199.99,
        description: "Comfortable relaxed fit jeans for casual wear.",
        category: "clothing",
        subCategory: "jeans",
        gender: "men",
        image:
            "https://images.unsplash.com/photo-1542272604-787c3835535d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["30", "32", "34", "36", "38"],
        rating: rating,
      ),

      // Kids' Clothing
      ProductModel(
        id: 13,
        title: "Cute Summer Dress",
        price: 599.99,
        description:
            "Adorable summer dress for little girls with colorful patterns.",
        category: "clothing",
        subCategory: "dress",
        gender: "kids",
        image:
            "https://images.unsplash.com/photo-1476234251651-f353703a034d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["2T", "3T", "4T", "5T"],
        rating: rating,
      ),
      ProductModel(
        id: 14,
        title: "Boys' T-Shirt Set",
        price: 699.99,
        description: "Set of 3 comfortable t-shirts for boys with fun designs.",
        category: "clothing",
        subCategory: "tshirt",
        gender: "kids",
        image:
            "https://images.unsplash.com/photo-1519238359922-989348752efb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["4-5Y", "6-7Y", "8-9Y", "10-12Y"],
        rating: rating,
      ),

      // Accessories
      ProductModel(
        id: 15,
        title: "Stylish Handbag",
        price: 1299.99,
        description:
            "Elegant handbag with multiple compartments, perfect for daily use.",
        category: "accessories",
        subCategory: "handbag",
        gender: "women",
        image:
            "https://images.unsplash.com/photo-1584917865442-de89df76afd3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["One Size"],
        rating: rating,
      ),
      ProductModel(
        id: 16,
        title: "Men's Leather Wallet",
        price: 799.99,
        description:
            "Premium leather wallet with multiple card slots and coin pocket.",
        category: "accessories",
        subCategory: "wallet",
        gender: "men",
        image:
            "https://images.unsplash.com/photo-1627123424574-724758594e93?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        availableSizes: ["One Size"],
        rating: rating,
      ),

      // Add a backpack item matching the screenshot
      ProductModel(
        id: 17,
        title: "Fjallraven - Foldsack No. 1 Backpack",
        price: 110.00,
        description:
            "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        category: "clothing",
        subCategory: "backpack",
        gender: "men",
        image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        availableSizes: ["One Size"],
        rating: rating,
      ),
    ];
  }
}
