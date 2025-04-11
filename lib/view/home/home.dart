import 'package:http/http.dart' as http;

import 'package:super_store_e_commerce_flutter/imports.dart';
import 'package:super_store_e_commerce_flutter/services/product_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<ProductModel>>? futureProduct;
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Future<List<ProductModel>> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Initialize with updated product images
      final productService = ProductService();

      // Force reinitialize with sample products to update images
      await productService.clearProducts();
      await productService
          .initializeProducts(productService.getSampleProducts());

      // Get the products from Firestore
      final products = await productService.getProducts();

      setState(() {
        allProducts = products;
        filteredProducts = products;
        isLoading = false;
      });
      return products;

      // Comment out the fallback since we're using our own products
      /*
      // Fallback to fake store API if Firestore is empty
      const baseUrl = 'https://fakestoreapi.com/products';
      var request = http.Request('GET', Uri.parse(baseUrl));

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        List<ProductModel> apiProducts = jsonData
            .map<ProductModel>((e) => ProductModel.fromJson(e))
            .toList();

        // Initialize Firestore with these products
        await productService.initializeProducts(apiProducts);

        setState(() {
          allProducts = apiProducts;
          filteredProducts = apiProducts;
          isLoading = false;
        });

        return apiProducts;
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
        setState(() {
          isLoading = false;
        });
        return [];
      }
      */
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
      setState(() {
        isLoading = false;
      });
      return [];
    }
  }

  void searchProducts(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) =>
                (product.title?.toLowerCase().contains(query.toLowerCase()) ??
                    false) ||
                (product.category
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ??
                    false) ||
                (product.subCategory
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ??
                    false) ||
                (product.description
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ??
                    false))
            .toList();
      }
    });
  }

  // Filter products by gender
  void filterByGender(String gender) {
    setState(() {
      filteredProducts = allProducts
          .where((product) =>
              (product.gender?.toLowerCase() == gender.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const AppNameWidget(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Cart()));
            },
            icon: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: cart.itemCount != 0 ? 8 : 0,
                      right: cart.itemCount != 0 ? 8 : 0),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                if (cart.itemCount != 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: TextBuilder(
                        text: cart.itemCount.toString(),
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: searchProducts,
              ),
            ),

            // Category/Gender Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.blue[100],
                      selected: searchQuery.isEmpty,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            searchQuery = '';
                            _searchController.clear();
                            filteredProducts = allProducts;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Women'),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.pink[100],
                      selected: searchQuery == 'women',
                      onSelected: (selected) {
                        if (selected) {
                          filterByGender('women');
                          _searchController.text = 'women';
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Men'),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.blue[100],
                      selected: searchQuery == 'men',
                      onSelected: (selected) {
                        if (selected) {
                          filterByGender('men');
                          _searchController.text = 'men';
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Kids'),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.green[100],
                      selected: searchQuery == 'kids',
                      onSelected: (selected) {
                        if (selected) {
                          filterByGender('kids');
                          _searchController.text = 'kids';
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Clothing'),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.purple[100],
                      selected: searchQuery == 'clothing',
                      onSelected: (selected) {
                        if (selected) {
                          searchProducts('clothing');
                          _searchController.text = 'clothing';
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Accessories'),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.amber[100],
                      selected: searchQuery == 'accessories',
                      onSelected: (selected) {
                        if (selected) {
                          searchProducts('accessories');
                          _searchController.text = 'accessories';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: futureProduct,
                builder: (context, data) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.hasError) {
                    return Text("${data.error}");
                  } else if (filteredProducts.isEmpty) {
                    return const Center(child: Text("No products found"));
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: filteredProducts.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int i) {
                        return ProductCard(product: filteredProducts[i]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
