import 'package:super_store_e_commerce_flutter/imports.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final cart = Provider.of<CartProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showProductDetails(context, size),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with square ratio
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0, // Square image
                    child: Image.network(
                      product.image!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  if (product.gender != null)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getGenderColor(product.gender!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          product.gender!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Product info overlay
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  product.title!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '₹${product.price!.round()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  '${product.subCategory ?? product.category} • ${product.availableSizes?.length ?? 0} sizes',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => _showQuickAddDialog(context, size),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Color _getGenderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'women':
        return Colors.pink[400]!;
      case 'men':
        return Colors.blue[700]!;
      case 'kids':
        return Colors.green[400]!;
      default:
        return Colors.purple;
    }
  }

  void _showProductDetails(BuildContext context, Size size) {
    String? selectedSize;

    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.all(16),
            iconPadding: EdgeInsets.zero,
            elevation: 0,
            title: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.title ?? 'Product Details',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InteractiveViewer(
                    minScale: 0.1,
                    maxScale: 1.9,
                    child: Center(
                      child: Image.network(
                        product.image!,
                        height: size.height * 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '₹${product.price?.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Spacer(),
                      if (product.rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating!.rate}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (product.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            product.category!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      if (product.subCategory != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            product.subCategory!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      if (product.gender != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getGenderColor(product.gender!),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            product.gender!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (product.description != null) ...[
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (product.availableSizes != null &&
                      product.availableSizes!.isNotEmpty) ...[
                    Row(
                      children: [
                        const Text(
                          'Select Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          ' *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.availableSizes!.map((size) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: selectedSize == size
                                  ? Colors.blue
                                  : Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                color: selectedSize == size
                                    ? Colors.white
                                    : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (selectedSize == null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Please select a size to continue',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (product.availableSizes == null ||
                                  product.availableSizes!.isEmpty ||
                                  selectedSize != null)
                              ? Colors.blue
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          if (product.availableSizes != null &&
                              product.availableSizes!.isNotEmpty &&
                              selectedSize == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a size'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Add to Cart'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.image!,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${product.price!.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Text(
                                        'Category: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(product.subCategory ??
                                          product.category ??
                                          'Uncategorized'),
                                    ],
                                  ),
                                  if (selectedSize != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text(
                                          'Selected Size: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            selectedSize!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        'Quantity: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text('1'),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    final cart = Provider.of<CartProvider>(
                                        context,
                                        listen: false);
                                    CartModel cartModel = CartModel(
                                      id: product.id!,
                                      title: product.title!,
                                      price: product.price!,
                                      image: product.image!,
                                      category: product.category!,
                                      quantity: 1,
                                      totalPrice: product.price!,
                                      size: selectedSize,
                                    );
                                    cart.addItem(cartModel);

                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(selectedSize != null
                                            ? 'Added to cart - Size: $selectedSize'
                                            : 'Added to cart'),
                                        action: SnackBarAction(
                                          label: 'View Cart',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const Cart()));
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  void _showQuickAddDialog(BuildContext context, Size size) {
    String? selectedSize;

    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Add to Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.image!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${product.price!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.subCategory ??
                                product.category ??
                                'Uncategorized',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (product.availableSizes != null &&
                    product.availableSizes!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Text(
                        'Select Size',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.availableSizes!.map((size) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedSize == size
                                ? Colors.blue
                                : Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              color: selectedSize == size
                                  ? Colors.white
                                  : Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (selectedSize == null) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Please select a size to continue',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ],
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (product.availableSizes == null ||
                              product.availableSizes!.isEmpty ||
                              selectedSize != null)
                          ? Colors.blue
                          : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (product.availableSizes != null &&
                          product.availableSizes!.isNotEmpty &&
                          selectedSize == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a size'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final cart =
                          Provider.of<CartProvider>(context, listen: false);
                      CartModel cartModel = CartModel(
                        id: product.id!,
                        title: product.title!,
                        price: product.price!,
                        image: product.image!,
                        category: product.category!,
                        quantity: 1,
                        totalPrice: product.price!,
                        size: selectedSize,
                      );
                      cart.addItem(cartModel);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(selectedSize != null
                              ? 'Added to cart - Size: $selectedSize'
                              : 'Added to cart'),
                          action: SnackBarAction(
                            label: 'View Cart',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const Cart()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }
}
