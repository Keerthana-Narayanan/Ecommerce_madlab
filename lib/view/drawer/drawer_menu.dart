import 'package:super_store_e_commerce_flutter/imports.dart';
import 'package:super_store_e_commerce_flutter/controller/auth_provider.dart';
import 'package:super_store_e_commerce_flutter/view/contact/contact_page.dart';
import 'package:super_store_e_commerce_flutter/view/orders/orders_page.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 170.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                            authProvider.isLoggedIn
                                ? Icons.person
                                : Icons.person_outline,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextBuilder(
                                text: authProvider.user?.fullName ??
                                    RawString.appName,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                maxLines: 1,
                              ),
                              TextBuilder(
                                text: authProvider.user?.email ??
                                    RawString.dummyEmail,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: ListView(
                      children: [
                        // Home
                        ListTile(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const Home()),
                              (route) => false,
                            );
                          },
                          leading: const Icon(
                            Icons.home,
                            color: Colors.black,
                            size: 20,
                          ),
                          title: const TextBuilder(
                            text: "Home",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        // Cart
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Cart()),
                            );
                          },
                          leading: const Icon(
                            Icons.shopping_bag,
                            color: Colors.black,
                            size: 20,
                          ),
                          title: const TextBuilder(
                            text: "Cart",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        // Orders - Only visible when logged in
                        if (authProvider.isLoggedIn)
                          ListTile(
                            onTap: () {
                              // Navigate to orders page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const OrdersPage()),
                              );
                            },
                            leading: const Icon(
                              Icons.shopping_cart_checkout,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: const TextBuilder(
                              text: "My Orders",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                        // Contact Us
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ContactPage()),
                            );
                          },
                          leading: const Icon(
                            Icons.contact_support,
                            color: Colors.black,
                            size: 20,
                          ),
                          title: const TextBuilder(
                            text: "Contact Us",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        const Divider(),

                        // Profile - Only visible when logged in
                        if (authProvider.isLoggedIn)
                          ListTile(
                            onTap: () {
                              // Navigate to profile page
                              Navigator.pop(context);
                            },
                            leading: const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: const TextBuilder(
                              text: "My Profile",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                        // Login/Logout
                        ListTile(
                          onTap: () async {
                            if (authProvider.isLoggedIn) {
                              // Logout
                              await authProvider.signOut();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Login()),
                                  (route) => false,
                                );
                              }
                            } else {
                              // Login
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Login()),
                              );
                            }
                          },
                          leading: Icon(
                            authProvider.isLoggedIn
                                ? Icons.logout
                                : Icons.login,
                            color: Colors.black,
                            size: 20,
                          ),
                          title: TextBuilder(
                            text: authProvider.isLoggedIn ? "Logout" : "Login",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        const Divider(),

                        // About App
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            showAboutDialog(
                              applicationName: RawString.appName,
                              context: context,
                              applicationVersion: '1.0.0+1',
                            );
                          },
                          child: const ListTile(
                            leading: Icon(
                              Icons.info,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: TextBuilder(
                              text: "About App",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 80,
              child: Column(
                children: [
                  const AppNameWidget(),
                  TextBuilder(
                    text: RawString.appDescription,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
