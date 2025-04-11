import 'package:flutter/foundation.dart';
import 'package:super_store_e_commerce_flutter/model/product_model.dart';
import 'package:super_store_e_commerce_flutter/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ProductModel> get products => [..._products];
  List<ProductModel> get filteredProducts => [..._filteredProducts];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all products from Firestore
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
      _filteredProducts = _products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load products. Please try again.';
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    }
  }

  // Fetch products by category
  Future<void> fetchProductsByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _filteredProducts = await _productService.getProductsByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load products for this category.';
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching products by category: $e');
      }
    }
  }

  // Fetch products by gender
  Future<void> fetchProductsByGender(String gender) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _filteredProducts = await _productService.getProductsByGender(gender);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load products for this gender.';
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching products by gender: $e');
      }
    }
  }

  // Fetch products by subcategory
  Future<void> fetchProductsBySubCategory(String subCategory) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _filteredProducts =
          await _productService.getProductsBySubCategory(subCategory);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load products for this subcategory.';
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching products by subcategory: $e');
      }
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(int productId) async {
    try {
      return await _productService.getProductById(productId.toString());
    } catch (e) {
      if (kDebugMode) {
        print('Error getting product by ID: $e');
      }
      return null;
    }
  }

  // Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products.where((product) {
        final titleMatch =
            product.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final descriptionMatch =
            product.description?.toLowerCase().contains(query.toLowerCase()) ??
                false;
        final categoryMatch =
            product.category?.toLowerCase().contains(query.toLowerCase()) ??
                false;
        final subCategoryMatch =
            product.subCategory?.toLowerCase().contains(query.toLowerCase()) ??
                false;
        return titleMatch ||
            descriptionMatch ||
            categoryMatch ||
            subCategoryMatch;
      }).toList();
    }
    notifyListeners();
  }

  // Filter products by size
  void filterBySize(String size) {
    _filteredProducts = _products.where((product) {
      return product.availableSizes?.contains(size) ?? false;
    }).toList();
    notifyListeners();
  }

  // Filter products by gender
  void filterByGender(String gender) {
    _filteredProducts = _products.where((product) {
      return product.gender?.toLowerCase() == gender.toLowerCase();
    }).toList();
    notifyListeners();
  }

  // Filter products by price range
  void filterByPriceRange(double minPrice, double maxPrice) {
    _filteredProducts = _products.where((product) {
      return (product.price ?? 0) >= minPrice &&
          (product.price ?? 0) <= maxPrice;
    }).toList();
    notifyListeners();
  }

  // Sort products by price (low to high)
  void sortByPriceLowToHigh() {
    _filteredProducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    notifyListeners();
  }

  // Sort products by price (high to low)
  void sortByPriceHighToLow() {
    _filteredProducts.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    notifyListeners();
  }

  // Sort products by rating
  void sortByRating() {
    _filteredProducts
        .sort((a, b) => (b.rating?.rate ?? 0).compareTo(a.rating?.rate ?? 0));
    notifyListeners();
  }

  // Reset filters
  void resetFilters() {
    _filteredProducts = _products;
    notifyListeners();
  }

  // Get unique categories
  List<String> getCategories() {
    final Set<String> categories = {};
    for (var product in _products) {
      if (product.category != null) {
        categories.add(product.category!);
      }
    }
    return categories.toList();
  }

  // Get unique subcategories
  List<String> getSubCategories() {
    final Set<String> subCategories = {};
    for (var product in _products) {
      if (product.subCategory != null) {
        subCategories.add(product.subCategory!);
      }
    }
    return subCategories.toList();
  }

  // Get unique genders
  List<String> getGenders() {
    final Set<String> genders = {};
    for (var product in _products) {
      if (product.gender != null) {
        genders.add(product.gender!);
      }
    }
    return genders.toList();
  }

  // Get unique sizes
  List<String> getAvailableSizes() {
    final Set<String> sizes = {};
    for (var product in _products) {
      if (product.availableSizes != null) {
        sizes.addAll(product.availableSizes!);
      }
    }
    return sizes.toList()..sort();
  }
}
