import 'package:flutter/material.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/list_product_management_screen.dart';
// import 'package:shop_owner_screen/presentation/screens/User/order_history_screen.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/discount/list_discount.dart';


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
      
      // Giữ nguyên phần Theme của bạn vì nó setup màu sắc và font chữ rất chuẩn
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

      // THAY ĐỔI CỐT LÕI Ở ĐÂY:
      // Gắn trực tiếp màn hình OrderHistoryScreen và truyền cứng userId = 1 để test API
      // home: const ListProductManagementScreen(userId: 2), 
      home: ListDiscountScreen(),
      // Đã xóa toàn bộ thuộc tính 'routes:' để app không bị vướng bận các màn hình khác
    );
  }
}