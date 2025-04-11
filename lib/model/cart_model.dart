class CartModel {
  int? id;
  int? quantity;
  double? totalPrice;
  String? title;
  double? price;
  String? category;
  String? image;
  String? size;

  CartModel({
    this.id,
    this.quantity,
    this.totalPrice,
    this.title,
    this.price,
    this.category,
    this.image,
    this.size,
  });

  CartModel copyWith({
    int? id,
    int? quantity,
    double? totalPrice,
    String? title,
    double? price,
    String? category,
    String? image,
    String? size,
  }) {
    return CartModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      size: size ?? this.size,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      title: json['title'],
      price: json['price'],
      category: json['category'],
      image: json['image'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    data['title'] = title;
    data['price'] = price;
    data['category'] = category;
    data['image'] = image;
    data['size'] = size;
    return data;
  }
}
