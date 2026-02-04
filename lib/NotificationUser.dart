import 'package:flutter/material.dart';

class NotificationUser extends StatelessWidget {
  const NotificationUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(8, (index) => _buildNotificationTile(index)),
      ),
    );
  }

  Widget _buildNotificationTile(int index) {
    final bool unread = index % 3 == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: unread ? Colors.green.shade100 : Colors.grey.shade200,
            child: Icon(unread ? Icons.notifications_active : Icons.notifications_none, color: unread ? Colors.green : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${1000 + index} • Update', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Your order status has been updated.', style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${index + 1}h', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              if (unread)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                  child: const Text('New', style: TextStyle(color: Colors.green, fontSize: 12)),
                )
            ],
          )
        ],
      ),
    );
  }
}
