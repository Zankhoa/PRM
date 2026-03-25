import 'package:flutter/material.dart';
import 'package:shop_owner_screen/app/demo_user_config.dart';
import 'package:shop_owner_screen/presentation/screens/User/user_main_shell_screen.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

void main() {
  runApp(const FoodOrderApp());
}

class FoodOrderApp extends StatelessWidget {
  const FoodOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order',
      debugShowCheckedModeBanner: false,
      theme: FoodOrderUi.themeData(),
      home: const UserMainShellScreen(userId: DemoUserConfig.userId),
    );
  }
}
