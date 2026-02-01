import 'package:flutter/material.dart';
import 'package:project/HistoryOrderPage.dart';
import 'package:project/ListProductManagement.dart';
import 'package:project/VerifyOrder.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VerifyOrder()
      ),
    );
  }
}
  //  @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     home: Scaffold(
  //       body: Listviewdemo(),
  //     ),