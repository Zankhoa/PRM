import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/notification_dto.dart';
import 'package:shop_owner_screen/data/service/notification_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class NotificationsScreen extends StatefulWidget {
  final int userId;

  const NotificationsScreen({super.key, required this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();
  List<NotificationDto> _items = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _service.fetchNotifications(widget.userId);
      if (!mounted) return;
      setState(() {
        _items = items;
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

  Future<void> _markAsRead(NotificationDto item) async {
    if (item.isRead) return;
    try {
      await _service.markAsRead(widget.userId, item.notificationId);
      if (!mounted) return;
      setState(() {
        _items = _items
            .map((n) => n.notificationId == item.notificationId
                ? NotificationDto(
                    notificationId: n.notificationId,
                    title: n.title,
                    message: n.message,
                    isRead: true,
                    createdAt: n.createdAt,
                  )
                : n)
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: const Text('Thông báo')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: FoodOrderUi.textPrimary),
                        ),
                      ),
                    ],
                  )
                : _items.isEmpty
                    ? ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 72),
                            child: Center(
                              child: Text(
                                'Hiện chưa có thông báo mới',
                                style: TextStyle(
                                    color: FoodOrderUi.textPrimary
                                        .withOpacity(0.7)),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: item.isRead
                                ? Colors.white
                                : const Color(0xFFFFFBF3),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(FoodOrderUi.radiusMd),
                              onTap: () => _markAsRead(item),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: FoodOrderUi.textPrimary,
                                            ),
                                          ),
                                        ),
                                        if (!item.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFF9800),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.message,
                                      style: const TextStyle(
                                        height: 1.45,
                                        color: FoodOrderUi.textPrimary,
                                      ),
                                    ),
                                    if (item.createdAt != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        _format(item.createdAt!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: FoodOrderUi.textPrimary
                                              .withOpacity(0.55),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  String _format(DateTime value) {
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
