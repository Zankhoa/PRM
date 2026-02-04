import 'package:flutter/material.dart';
import 'package:project/VerifyOrder.dart';
import 'package:project/ScreensHub.dart';
import 'package:project/BlogUser.dart';
import 'package:project/NotificationUser.dart';
import 'package:project/PaymentStatusUser.dart';
import 'package:project/AdminListAccount.dart';
import 'package:project/AdminCreateAccount.dart';
import 'package:project/AdminUpdateAccount.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beverage Ordering',
      initialRoute: '/',
      routes: {
        '/': (context) => const ScreensHub(),
        '/verify': (context) => const VerifyOrder(),
        '/blog': (context) => const BlogUser(),
        '/notifications': (context) => const NotificationUser(),
        '/payment_status': (context) => const PaymentStatusUser(),
        '/admin/list_accounts': (context) => const AdminListAccount(),
        '/admin/create_account': (context) => const AdminCreateAccount(),
        '/admin/update_account': (context) => const AdminUpdateAccount(),
      },
    );
  }
}
  //  @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     home: Scaffold(
  //       body: Listviewdemo(),
  //     ),