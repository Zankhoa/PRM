import 'package:flutter/material.dart';
import 'package:shop_owner_screen/CreateProduct.dart';
import 'package:shop_owner_screen/HistoryOrderPage.dart';
import 'package:shop_owner_screen/ListProductManagement.dart';
import 'package:shop_owner_screen/LoginScreen.dart';
import 'package:shop_owner_screen/VerifyOrder.dart';
import 'package:shop_owner_screen/UpdateProduct.dart';
import 'package:shop_owner_screen/NotificationUser.dart';
import 'package:shop_owner_screen/PaymentStatusUser.dart';
import 'package:shop_owner_screen/AdminCreateAccount.dart';
import 'package:shop_owner_screen/AdminListAccount.dart';
import 'package:shop_owner_screen/AdminUpdateAccount.dart';
import 'package:shop_owner_screen/ScreensHub.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/discount_list_screen.dart';
import 'screens/add_discount_screen.dart';

import 'user/product_list_user_screen.dart';
import 'user/cart_user_screen.dart';
import 'user/discount_list_user_screen.dart';
import 'user/order_status_user_screen.dart';
import 'user/payment_user_screen.dart';

void main() {
  runApp(const ShopOwnerApp());
}

class ShopOwnerApp extends StatelessWidget {
  const ShopOwnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),


      home: const DashboardScreen(),


      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/discounts': (context) => const DiscountListScreen(),
        '/add-discount': (context) => const AddDiscountScreen(),
        '/create-product': (context) => const CreateProduct(),
        '/manage-product': (context) => const ListProductManagement(),
        '/update-product': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return UpdateProduct(initialData: args);
        },
        '/history-order': (context) => const OrderHistory(),
        '/verify': (context) => const VerifyOrder(),
        '/screens-hub': (context) => const ScreensHub(),
        '/notifications': (context) => const NotificationUser(),
        '/payment_status': (context) => const PaymentStatusUser(),
        '/admin/create_account': (context) => const AdminCreateAccount(),
        '/admin/list_accounts': (context) => const AdminListAccount(),
        '/admin/update_account': (context) => const AdminUpdateAccount(),
      },
    );
  }
}
