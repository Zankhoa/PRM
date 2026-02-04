import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../models/mock_data.dart';

class OrderStatusUserScreen extends StatefulWidget {
  const OrderStatusUserScreen({super.key});

  @override
  State<OrderStatusUserScreen> createState() => _OrderStatusUserScreenState();
}

class _OrderStatusUserScreenState extends State<OrderStatusUserScreen> {
  String _filter = 'Tất cả';
  final List<String> _filters = [
    'Tất cả',
    'Chờ xác nhận',
    'Đã xác nhận',
    'Đang chuẩn bị',
    'Đang giao',
    'Đã giao',
    'Đã hủy',
  ];

  List<Order> get _orders {
    var list = MockData.userOrders;
    if (_filter == 'Tất cả') return list;
    list = list.where((o) => o.statusLabel == _filter).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6C63FF).withOpacity(0.05),
              const Color(0xFFFF6584).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildFilterChips(),
              Expanded(
                child: _orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có đơn hàng nào',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          return _buildOrderCard(
                            context,
                            _orders[index],
                            currencyFormat,
                            dateFormat,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'Đơn hàng của tôi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final f = _filters[index];
          final selected = _filter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f),
              selected: selected,
              onSelected: (_) => setState(() => _filter = f),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF6C63FF).withOpacity(0.2),
              labelStyle: TextStyle(
                fontSize: 13,
                color: selected ? const Color(0xFF6C63FF) : Colors.grey[700],
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
  ) {
    final statusColor = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...order.items.take(3).map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text(
                            item.product.imageUrl,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${item.product.name} x${item.quantity}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                if (order.items.length > 3)
                  Text(
                    '+ ${order.items.length - 3} món khác',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  dateFormat.format(order.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng thanh toán',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2D3142),
                        )),
                    Text(
                      currencyFormat.format(order.total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.delivering:
        return Colors.teal;
      case OrderStatus.delivered:
        return const Color(0xFF4CAF50);
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
