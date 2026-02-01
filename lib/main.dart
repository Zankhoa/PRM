import 'package:flutter/material.dart';
import 'package:project/HistoryOrderPage.dart';
import 'package:project/ListProductManagement.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MenuManagerScreen()
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