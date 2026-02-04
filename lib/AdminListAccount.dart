import 'package:flutter/material.dart';

class AdminListAccount extends StatelessWidget {
  const AdminListAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Accounts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)]),
              child: const Row(
                children: [
                  Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  SizedBox(width: 96, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  final name = 'User ${index + 1}';
                  final email = 'user${index + 1}@mail.com';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                    child: Row(
                      children: [
                        Expanded(child: Text(name)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(email)),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(context, '/admin/update_account', arguments: {'name': name, 'email': email});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                // show confirmation
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete account'),
                                    content: Text('Are you sure you want to delete $name?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Delete')),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/admin/create_account'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
