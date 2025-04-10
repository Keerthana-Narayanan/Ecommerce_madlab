export 'dart:convert';
export 'view/init_screen/splash.dart';
export 'package:flutter/material.dart';
export 'package:provider/provider.dart';
export 'package:flutter/foundation.dart' hide kIsWeb;
export 'package:super_store_e_commerce_flutter/view/cart/cart.dart';
export 'package:super_store_e_commerce_flutter/view/init_screen/login.dart';
export 'package:super_store_e_commerce_flutter/view/init_screen/register.dart';
export 'package:super_store_e_commerce_flutter/widgets/app_name_widget.dart';
export 'package:super_store_e_commerce_flutter/view/home/home.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:super_store_e_commerce_flutter/view/drawer/drawer_menu.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:super_store_e_commerce_flutter/const/raw_string.dart';
export 'package:super_store_e_commerce_flutter/model/cart_model.dart';
export 'package:super_store_e_commerce_flutter/widgets/text/text_builder.dart';
export 'package:super_store_e_commerce_flutter/widgets/text_filed/custom_text_field.dart';
export 'package:super_store_e_commerce_flutter/widgets/card/product_card.dart';
export 'package:super_store_e_commerce_flutter/widgets/card/cart_card.dart';
export 'package:super_store_e_commerce_flutter/const/app_colors.dart';
export 'package:super_store_e_commerce_flutter/utils/url_launch.dart';
export 'package:icons_plus/icons_plus.dart';
export 'package:super_store_e_commerce_flutter/model/product_model.dart';
export 'package:super_store_e_commerce_flutter/controller/cart_provider.dart';
export 'package:super_store_e_commerce_flutter/controller/order_provider.dart';
export 'package:super_store_e_commerce_flutter/controller/product_provider.dart';
export 'package:super_store_e_commerce_flutter/model/user_model.dart';
export 'package:super_store_e_commerce_flutter/view/orders/orders_page.dart';
export 'package:super_store_e_commerce_flutter/view/orders/order_details_page.dart';
export 'package:super_store_e_commerce_flutter/view/contact/contact_page.dart';

// Firebase Exports - Import these directly in files that need them to avoid name collisions
// export 'package:firebase_core/firebase_core.dart';
// export 'package:firebase_auth/firebase_auth.dart';
// export 'package:cloud_firestore/cloud_firestore.dart';
// export 'package:firebase_storage/firebase_storage.dart';

// AuthProvider - Import directly to avoid name collision with Firebase
export 'package:super_store_e_commerce_flutter/controller/auth_provider.dart'
    show AuthProvider;
