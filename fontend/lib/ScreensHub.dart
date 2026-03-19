import 'package:flutter/material.dart';

class ScreensHub extends StatelessWidget {
  const ScreensHub({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      {'title': 'Verify Order (demo)', 'route': '/verify', 'icon': Icons.checklist},
      {'title': 'Blog (user)', 'route': '/blog', 'icon': Icons.article},
      {'title': 'Notifications (user)', 'route': '/notifications', 'icon': Icons.notifications},
      {'title': 'Payment Status (user)', 'route': '/payment_status', 'icon': Icons.payment},
      {'title': 'List Accounts (admin)', 'route': '/admin/list_accounts', 'icon': Icons.people},
      {'title': 'Create Account (admin)', 'route': '/admin/create_account', 'icon': Icons.person_add},
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
      drawer: _buildDrawer(context, tiles),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          final t = tiles[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                t['icon'] as IconData,
                color: const Color(0xFF6C63FF),
              ),
              title: Text(
                t['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () => Navigator.pushNamed(context, t['route'] as String),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, List<Map<String, dynamic>> tiles) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6C63FF),
                    const Color(0xFF6C63FF).withOpacity(0.8),
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 30),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Navigate to screens',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  final tile = tiles[index];
                  return _buildDrawerItem(
                    context: context,
                    title: tile['title'] as String,
                    icon: tile['icon'] as IconData,
                    route: tile['route'] as String,
                    isLast: index == tiles.length - 1,
                  );
                },
              ),
            ),
            Divider(color: Colors.grey.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6584),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String route,
    required bool isLast,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFF6C63FF), size: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3142),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          onTap: () {
            Navigator.pop(context); // Close drawer
            Navigator.pushNamed(context, route);
          },
        ),
        if (!isLast) Divider(color: Colors.grey.withOpacity(0.1), height: 1),
      ],
    );
  }
}
