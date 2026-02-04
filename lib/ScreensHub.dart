import 'package:flutter/material.dart';

class ScreensHub extends StatelessWidget {
  const ScreensHub({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      {'title': 'Verify Order (demo)', 'route': '/verify'},
      {'title': 'Blog (user)', 'route': '/blog'},
      {'title': 'Notifications (user)', 'route': '/notifications'},
      {'title': 'Payment Status (user)', 'route': '/payment_status'},
      {'title': 'List Accounts (admin)', 'route': '/admin/list_accounts'},
      {'title': 'Create Account (admin)', 'route': '/admin/create_account'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('App Screens', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          final t = tiles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(t['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, t['route'] as String),
            ),
          );
        },
      ),
    );
  }
}
