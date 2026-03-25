import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/account_manage_dto.dart';
import 'package:shop_owner_screen/data/service/admin_account_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AdminAccountService();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  int _roleId = 3;
  bool _submitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await _service.createAccount(
        CreateAccountRequest(
          username: _usernameController.text.trim(),
          fullName: _fullNameController.text.trim(),
          password: _passwordController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          roleId: _roleId,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo tài khoản thành công')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: const Text('Tạo tài khoản')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _LabeledField(
              controller: _usernameController,
              label: 'Username',
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nhập username'
                  : null,
            ),
            _LabeledField(
              controller: _fullNameController,
              label: 'Họ tên',
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Nhập họ tên' : null,
            ),
            _LabeledField(
              controller: _passwordController,
              label: 'Mật khẩu',
              obscureText: true,
              validator: (value) => value == null || value.trim().length < 6
                  ? 'Mật khẩu tối thiểu 6 ký tự'
                  : null,
            ),
            _LabeledField(controller: _emailController, label: 'Email'),
            _LabeledField(controller: _phoneController, label: 'Số điện thoại'),
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
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: Text(_submitting ? 'Đang tạo...' : 'Tạo tài khoản'),
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
