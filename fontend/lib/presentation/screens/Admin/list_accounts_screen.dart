import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_owner_screen/data/models/account_manage_dto.dart';
import 'package:shop_owner_screen/data/service/admin_account_service.dart';
import 'package:shop_owner_screen/presentation/screens/Admin/create_account_screen.dart';
import 'package:shop_owner_screen/presentation/screens/Admin/update_account_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/LoginScreen.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class ListAccountsScreen extends StatefulWidget {
  const ListAccountsScreen({super.key});

  @override
  State<ListAccountsScreen> createState() => _ListAccountsScreenState();
}

class _ListAccountsScreenState extends State<ListAccountsScreen> {
  final AdminAccountService _service = AdminAccountService();
  final TextEditingController _searchController = TextEditingController();

  List<AccountManageDto> _accounts = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final accounts = await _service.fetchAccounts();
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
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

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _accounts.where((account) {
      if (query.isEmpty) return true;
      return account.username.toLowerCase().contains(query) ||
          account.fullName.toLowerCase().contains(query) ||
          (account.email ?? '').toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(
        title: const Text('Quản lý tài khoản'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
          );
          _load();
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Tạo tài khoản'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Tìm theo tên, username, email',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 72),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 72),
                child: Center(
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: FoodOrderUi.textPrimary),
                  ),
                ),
              )
            else if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 72),
                child: Center(
                  child: Text(
                    'Không tìm thấy tài khoản nào',
                    style: TextStyle(
                        color: FoodOrderUi.textPrimary.withOpacity(0.7)),
                  ),
                ),
              )
            else
              ...filtered.map(
                (account) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: account.isActive
                          ? FoodOrderUi.chipSelectedBg
                          : Colors.grey.shade200,
                      child: Text(
                        account.fullName.isEmpty
                            ? '?'
                            : account.fullName[0].toUpperCase(),
                        style: const TextStyle(color: FoodOrderUi.textPrimary),
                      ),
                    ),
                    title: Text(
                      account.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: FoodOrderUi.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '${account.username} • ${_roleLabel(account.roleId)}',
                      style: const TextStyle(color: FoodOrderUi.textPrimary),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          account.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: account.isActive
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFC62828),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    UpdateAccountScreen(userId: account.userId),
                              ),
                            );
                            _load();
                          },
                          child: const Text('Chỉnh sửa'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _roleLabel(int roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Shop Owner';
      case 3:
        return 'User';
      default:
        return 'Role $roleId';
    }
  }
}
