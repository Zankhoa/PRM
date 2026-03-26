import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/account_manage_dto.dart';
import 'package:shop_owner_screen/data/service/admin_account_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class UpdateAccountScreen extends StatefulWidget {
  final int userId;

  const UpdateAccountScreen({super.key, required this.userId});

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AdminAccountService();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _isActive = true;
  int _roleId = 3;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final account = await _service.fetchAccount(widget.userId);
      if (!mounted) return;
      _fullNameController.text = account.fullName;
      _emailController.text = account.email ?? '';
      _phoneController.text = account.phone ?? '';
      _roleId = account.roleId;
      _isActive = account.isActive;
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _service.updateAccount(
        widget.userId,
        UpdateAccountRequest(
          fullName: _fullNameController.text.trim(),
          password: _passwordController.text.trim().isEmpty
              ? null
              : _passwordController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          isActive: _isActive,
          roleId: _roleId,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật tài khoản thành công')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: Text('Cập nhật tài khoản #${widget.userId}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _LabeledField(
                    controller: _fullNameController,
                    label: 'Họ tên',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nhập họ tên'
                        : null,
                  ),
                  _LabeledField(
                    controller: _passwordController,
                    label: 'Mật khẩu mới',
                    obscureText: true,
                  ),
                  _LabeledField(controller: _emailController, label: 'Email'),
                  _LabeledField(
                      controller: _phoneController, label: 'Số điện thoại'),
                  DropdownButtonFormField<int>(
                    initialValue: _roleId,
                    decoration: const InputDecoration(labelText: 'Vai trò'),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Admin')),
                      DropdownMenuItem(value: 2, child: Text('Shop Owner')),
                      DropdownMenuItem(value: 3, child: Text('User')),
                    ],
                    onChanged: (value) => setState(() => _roleId = value ?? 3),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Tài khoản hoạt động'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'Đang lưu...' : 'Lưu thay đổi'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
