import 'package:super_store_e_commerce_flutter/imports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:super_store_e_commerce_flutter/controller/auth_provider.dart';
import 'package:super_store_e_commerce_flutter/controller/product_provider.dart';
import 'package:super_store_e_commerce_flutter/controller/order_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with proper configuration for web
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCbEaFxBhg5TD1hVA0ye3C6uLKUF_9k3yU",
        authDomain: "super-store-ecommerce.firebaseapp.com",
        projectId: "super-store-ecommerce",
        storageBucket: "super-store-ecommerce.firebasestorage.app",
        messagingSenderId: "G-0ZPBF9MC5W",
        appId: "1:1050753267534:web:81e5c6fa966d9004edd01f"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider()..initializeAuth()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider()),
        ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: RawString.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            // Check if user is authenticated
            if (authProvider.isLoggedIn) {
              return const Home();
            } else {
              return const Splash();
            }
          },
        ),
      ),
    );
  }
}
