import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_owner_screen/data/models/shop_profile_dto.dart';
import 'package:shop_owner_screen/presentation/screens/Admin/create_account_screen.dart';
import 'package:shop_owner_screen/presentation/screens/Admin/list_accounts_screen.dart';
import 'package:shop_owner_screen/presentation/screens/Admin/update_account_screen.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/CreateProduct.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/UpdateProduct.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/VerifyOrder.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/dashboard.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/discount/create_discount.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/discount/list_discount.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/edit_profile.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/list_product_management_screen.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/profile.dart';
import 'package:shop_owner_screen/presentation/screens/User/LoginScreen.dart';
import 'package:shop_owner_screen/presentation/screens/User/blog_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/notifications_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/order_history_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/payment_status_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/user_main_shell_screen.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final int? roleId = prefs.getInt('roleId');
  final String? roleName = prefs.getString('roleName');
  final int? userId = prefs.getInt('userId');

  Widget startingScreen = const LoginScreen();

  if (userId != null &&
      (roleId != null || (roleName != null && roleName.isNotEmpty))) {
    if (_isAdmin(roleId, roleName)) {
      startingScreen = const ListAccountsScreen();
    } else if (_isShopOwner(roleId, roleName)) {
      startingScreen = DashboardScreen(userId: userId);
    } else {
      startingScreen = UserMainShellScreen(userId: userId);
    }
  }

  runApp(ShopOwnerApp(initialScreen: startingScreen));
}

bool _isAdmin(int? roleId, String? roleName) {
  final key = (roleName ?? '').toLowerCase();
  if (key.contains('admin')) return true;
  return roleId == 1 && key.isEmpty;
}

bool _isShopOwner(int? roleId, String? roleName) {
  final key = (roleName ?? '').toLowerCase();
  if (key.contains('shop')) return true;
  return roleId == 2 && key.isEmpty;
}

class ShopOwnerApp extends StatelessWidget {
  final Widget initialScreen;

  const ShopOwnerApp({super.key, this.initialScreen = const LoginScreen()});

  @override
  Widget build(BuildContext context) {
    final mockProfile = ShopProfileDto(
      userId: 1,
      username: 'demo',
      fullName: 'Demo Shop Owner',
      email: 'demo@example.com',
      phone: '0123456789',
      address: 'Demo Address',
    );

    return MaterialApp(
      title: 'Food Order',
      debugShowCheckedModeBanner: false,
      theme: FoodOrderUi.themeData(),
      home: initialScreen,
      onGenerateRoute: (settings) {
        const defaultUserId = 1;
        const defaultAccountId = 1;
        switch (settings.name) {
          case '/':
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/dashboard':
            return MaterialPageRoute(
                builder: (_) => const DashboardScreen(userId: defaultUserId));
          case '/profile':
            return MaterialPageRoute(
                builder: (_) => const ProfileScreen(userId: defaultUserId));
          case '/edit-profile':
            return MaterialPageRoute(
              builder: (_) => EditProfileScreen(
                  userId: defaultUserId, profile: mockProfile),
            );
          case '/discounts':
            return MaterialPageRoute(
                builder: (_) => const ListDiscountScreen());
          case '/add-discount':
            return MaterialPageRoute(
                builder: (_) => const CreateDiscountScreen());
          case '/create-product':
            return MaterialPageRoute(builder: (_) => const CreateProduct());
          case '/manage-product':
            return MaterialPageRoute(
                builder: (_) =>
                    const ListProductManagementScreen(userId: defaultUserId));
          case '/update-product':
            return MaterialPageRoute(builder: (_) => const UpdateProduct());
          case '/history-order':
            return MaterialPageRoute(
                builder: (_) =>
                    const OrderHistoryScreen(userId: defaultUserId));
          case '/verify-order':
            return MaterialPageRoute(
                builder: (_) => const VerifyOrder(userId: defaultUserId));
          case '/blog':
            return MaterialPageRoute(
                builder: (_) => const BlogScreen(userId: defaultUserId));
          case '/notifications':
            return MaterialPageRoute(
                builder: (_) =>
                    const NotificationsScreen(userId: defaultUserId));
          case '/payment_status':
            return MaterialPageRoute(
                builder: (_) =>
                    const PaymentStatusScreen(userId: defaultUserId));
          case '/admin/list_accounts':
            return MaterialPageRoute(
                builder: (_) => const ListAccountsScreen());
          case '/admin/create_account':
            return MaterialPageRoute(
                builder: (_) => const CreateAccountScreen());
          case '/admin/update_account':
            return MaterialPageRoute(
                builder: (_) =>
                    const UpdateAccountScreen(userId: defaultAccountId));
          default:
            return null;
        }
      },
    );
  }
}
