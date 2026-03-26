import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/user_order_status_dto.dart';
import 'package:shop_owner_screen/data/service/user_orders_api_service.dart';
import 'package:shop_owner_screen/presentation/screens/User/payment_status_screen.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';
import 'package:shop_owner_screen/presentation/widgets/user_order_status/order_status_card.dart';

class OrdersUserScreen extends StatefulWidget {
  final int userId;

  const OrdersUserScreen({super.key, required this.userId});

  @override
  State<OrdersUserScreen> createState() => _OrdersUserScreenState();
}

class _OrdersUserScreenState extends State<OrdersUserScreen> {
  final _api = UserOrdersApiService();
  String? _filter;
  late Future<List<UserOrderStatusDto>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchOrders(widget.userId);
  }

  Future<void> _reload() async {
    setState(() => _future = _api.fetchOrders(widget.userId));
    await _future;
  }

  Widget _chip(String label, String? status) {
    final sel = _filter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        showCheckmark: false,
        avatar: sel
            ? Icon(Icons.check,
                size: 18, color: Theme.of(context).colorScheme.primary)
            : null,
        label: Text(label),
        selected: sel,
        onSelected: (_) => setState(() => _filter = status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(
        title: const Text('Don hang cua toi'),
        actions: [
          IconButton(
            tooltip: 'Tra cuu thanh toan',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PaymentStatusScreen(userId: widget.userId),
                ),
              );
            },
            icon: const Icon(Icons.payments_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: [
                _chip('Tat ca', null),
                _chip('Cho xac nhan', 'pending'),
                _chip('Da xac nhan', 'confirmed'),
                _chip('Da huy', 'cancelled'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserOrderStatusDto>>(
              future: _future,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(snap.error.toString(),
                          style:
                              const TextStyle(color: FoodOrderUi.textPrimary)),
                    ),
                  );
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var list = snap.data!;
                if (_filter != null) {
                  list = list
                      .where((o) => (o.status ?? '').toLowerCase() == _filter)
                      .toList();
                }
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'Chua co don hang',
                      style: TextStyle(
                          color: FoodOrderUi.textPrimary.withOpacity(0.65)),
                    ),
                  );
                }
                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  onRefresh: _reload,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: list.length,
                    itemBuilder: (context, i) =>
                        OrderStatusCard(order: list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
