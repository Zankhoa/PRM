import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/presentation/screens/User/LoginScreen.dart';
import 'package:shop_owner_screen/presentation/screens/User/SettingScreen.dart';
import 'package:shop_owner_screen/presentation/screens/User/UpdateProfileScreen.dart';
import 'package:shop_owner_screen/presentation/screens/User/blog_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/notifications_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/payment_status_screen.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class UserAccountScreen extends StatefulWidget {
  final bool showBackButton;

  const UserAccountScreen({super.key, this.showBackButton = false});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  String _errorMessage = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        setState(() {
          _errorMessage = 'User not logged in. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      _userId = userId;
      final url = Uri.parse('${ApiConfig.baseUrl}/api/UserProfile/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _userData = data['user'] as Map<String, dynamic>;
            _isLoading = false;
          });
          return;
        }
      }

      setState(() {
        _errorMessage = 'Failed to load profile.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not connect to the server: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _fetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _openScreen(const SettingScreen()),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchUserProfile,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: FoodOrderUi.chipSelectedBg,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 42,
                                  color: FoodOrderUi.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _userData?['fullName'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: FoodOrderUi.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _userData?['email'] ?? 'No email',
                                style: TextStyle(
                                  color:
                                      FoodOrderUi.textPrimary.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _userData?['phone'] ?? 'No phone',
                                style: TextStyle(
                                  color:
                                      FoodOrderUi.textPrimary.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () =>
                                    _openScreen(const UpdateProfileScreen()),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Update profile'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'User Features',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: FoodOrderUi.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ActionTile(
                        icon: Icons.article_outlined,
                        title: 'Blog',
                        subtitle: 'Create and read user posts',
                        onTap: () =>
                            _openScreen(BlogScreen(userId: _userId ?? 0)),
                      ),
                      _ActionTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle:
                            'See updates related to your account and orders',
                        onTap: () => _openScreen(
                            NotificationsScreen(userId: _userId ?? 0)),
                      ),
                      _ActionTile(
                        icon: Icons.payments_outlined,
                        title: 'Payment Status',
                        subtitle: 'Check payment details by order id',
                        onTap: () => _openScreen(
                            PaymentStatusScreen(userId: _userId ?? 0)),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: _logout,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: FoodOrderUi.chipSelectedBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: FoodOrderUi.textPrimary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: FoodOrderUi.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: FoodOrderUi.textPrimary.withOpacity(0.6)),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
