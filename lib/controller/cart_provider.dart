import 'package:super_store_e_commerce_flutter/imports.dart';
import 'package:super_store_e_commerce_flutter/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartModel> _items = [];
  bool _isLoading = false;

  List<CartModel> get items {
    return [..._items];
  }

  bool get isLoading => _isLoading;
  int get itemCount => _items.length;

  // Initialize cart from Firestore
  Future<void> initializeCart() async {
    _isLoading = true;
    notifyListeners();

    _items = await _cartService.getUserCart();

    _isLoading = false;
    notifyListeners();
  }

  // Listen to cart changes
  void listenToCartChanges() {
    _cartService.cartStream().listen((cartItems) {
      _items = cartItems;
      notifyListeners();
    });
  }

  // Add item to cart (local and Firestore)
  Future<void> addItem(CartModel cartModel) async {
    int index = _items.indexWhere((item) => item.id == cartModel.id);
    if (index != -1) {
      // Item already exists, update quantity and price
      CartModel existingItem = _items[index];
      CartModel updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity! + cartModel.quantity!,
        totalPrice: existingItem.totalPrice! + cartModel.totalPrice!,
      );
      _items[index] = updatedItem;
    } else {
      // Item doesn't exist, add it to the list
      _items.add(cartModel);
    }
    notifyListeners();

    // Sync with Firestore
    await _cartService.addToCart(cartModel);
  }

  // Remove item from cart (local and Firestore)
  Future<void> removeItem(int id) async {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    // Sync with Firestore
    await _cartService.removeFromCart(id);
  }

  // Increase quantity (local and Firestore)
  Future<void> increaseQuantity(int id) async {
    final index = _items.indexWhere((e) => e.id == id);
    _items[index].quantity = _items[index].quantity! + 1;
    _items[index].totalPrice = _items[index].price! * _items[index].quantity!;
    notifyListeners();

    // Sync with Firestore
    await _cartService.updateCartItemQuantity(id, _items[index].quantity!);
  }

  // Decrease quantity (local and Firestore)
  Future<void> decreaseQuantity(int id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (_items[index].quantity! > 1) {
      _items[index].quantity = _items[index].quantity! - 1;
      _items[index].totalPrice = _items[index].price! * _items[index].quantity!;
      notifyListeners();

      // Sync with Firestore
      await _cartService.updateCartItemQuantity(id, _items[index].quantity!);
    }
  }

  // Clear cart (local and Firestore)
  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();

    // Sync with Firestore
    await _cartService.clearCart();
  }

  // Remove single item (local and Firestore)
  Future<void> removeSingleItem(int id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (_items[index].quantity! > 1) {
      _items[index].quantity = _items[index].quantity! - 1;
      _items[index].totalPrice = _items[index].price! * _items[index].quantity!;
      notifyListeners();

      // Sync with Firestore
      await _cartService.updateCartItemQuantity(id, _items[index].quantity!);
    } else {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();

      // Sync with Firestore
      await _cartService.removeFromCart(id);
    }
  }

  // Calculate total price
  double totalPrice() {
    double total = 0;
    for (int i = 0; i < _items.length; i++) {
      total += _items[i].totalPrice ?? 0;
    }
    return total;
  }
}
