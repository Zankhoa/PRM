import 'package:flutter/material.dart';

class AdminCreateAccount extends StatefulWidget {
  const AdminCreateAccount({super.key});

  @override
  State<AdminCreateAccount> createState() => _AdminCreateAccountState();
}

class _AdminCreateAccountState extends State<AdminCreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'Full name', filled: true, fillColor: Colors.white)),
              const SizedBox(height: 12),
              TextFormField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email', filled: true, fillColor: Colors.white)),
              const SizedBox(height: 12),
              TextFormField(controller: _passwordCtl, obscureText: true, decoration: const InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created (demo)')));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Account'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
