import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/dashboard.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/list_product_management_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/LoginScreen.dart';
import 'package:shop_owner_screen/presentation/screens/User/order_history_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/product_list_user_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/user_main_shell_screen.dart';

// import 'package:shop_owner_screen/presentation/screens/User/order_history_screen.dart';

void main() async {
  // NEW: Ensure Flutter is initialized before using SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // NEW: Check for saved login data
  final prefs = await SharedPreferences.getInstance();
  final int? roleId = prefs.getInt('roleId');

  final int? userId = prefs.getInt('userId');

  // NEW: Determine the initial screen based on the saved RoleId
  Widget startingScreen = const LoginScreen(); // Default to login

  if (roleId != null && userId != null) {
    if (roleId == 1) {
      // 1. Removed 'const' 
      // 2. Added '!' to tell Dart it is definitely not null
      startingScreen = const UserMainShellScreen(userId: 1); 
    } else if (roleId == 2) {
      startingScreen = DashboardScreen(userId: userId!);
    } else if (roleId == 3) {
      startingScreen = ProductListUserScreen(
        userId: userId!, 
        onCartChanged: () {},
      );
    }
  }

  // NEW: Pass the determined screen to the app
  runApp(ShopOwnerApp(initialScreen: startingScreen));
}

class ShopOwnerApp extends StatelessWidget {
  final Widget initialScreen;

  // NEW: Update the constructor to require the initialScreen
  const ShopOwnerApp({super.key, required this.initialScreen});

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
      home: initialScreen,
    );
  }
}