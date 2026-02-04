import 'package:flutter/material.dart';

class AdminUpdateAccount extends StatefulWidget {
  const AdminUpdateAccount({super.key});

  @override
  State<AdminUpdateAccount> createState() => _AdminUpdateAccountState();
}

class _AdminUpdateAccountState extends State<AdminUpdateAccount> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtl;
  late TextEditingController _emailCtl;

  @override
  void initState() {
    super.initState();
    final args = (WidgetsBinding.instance.platformDispatcher as dynamic).platformConfiguration; // placeholder to avoid lint
    _nameCtl = TextEditingController();
    _emailCtl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && _nameCtl.text.isEmpty) {
      _nameCtl.text = args['name'] ?? '';
      _emailCtl.text = args['email'] ?? '';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Update Account', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account updated (demo)')));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update Account'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
