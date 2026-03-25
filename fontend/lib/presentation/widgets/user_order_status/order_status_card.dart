import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/user_order_status_dto.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';
import 'package:shop_owner_screen/presentation/widgets/user_menu/product_image.dart';
import 'package:shop_owner_screen/presentation/widgets/user_order_status/order_status_label.dart';

class OrderStatusCard extends StatelessWidget {
  final UserOrderStatusDto order;

  const OrderStatusCard({super.key, required this.order});

  ({Color bg, Color fg}) _badgeColors(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'pending':
        return (bg: FoodOrderUi.accentOrange, fg: Colors.white);
      case 'confirmed':
        return (bg: const Color(0xFFE8F5E9), fg: const Color(0xFF2E7D32));
      case 'cancelled':
        return (bg: const Color(0xFFFFEBEE), fg: const Color(0xFFC62828));
      default:
        return (bg: Colors.grey.shade200, fg: Colors.grey.shade800);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = _formatShort;
    final o = order;
    final badge = _badgeColors(o.status);
    final scheme = Theme.of(context).colorScheme;
    final lines = o.items;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FoodOrderUi.radiusMd),
        side: BorderSide(color: FoodOrderUi.textPrimary.withOpacity(0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Đơn #${o.orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: FoodOrderUi.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badge.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    OrderStatusLabel.vi(o.status),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badge.fg),
                  ),
                ),
              ],
            ),
            if (o.createdAt != null) ...[
              const SizedBox(height: 6),
              Text(
                df(o.createdAt!.toLocal()),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
            if (o.deliveryAddress != null && o.deliveryAddress!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(o.deliveryAddress!, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
                  ),
                ],
              ),
            ],
            if (lines.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Món đã đặt',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scheme.primary),
              ),
              const SizedBox(height: 8),
              ...lines.map((line) => _OrderLineTile(line: line)),
            ] else if (o.itemCount > 0) ...[
              const SizedBox(height: 6),
              Text('${o.itemCount} món', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Tổng thanh toán',
                  style: TextStyle(fontWeight: FontWeight.w500, color: FoodOrderUi.textPrimary),
                ),
                const Spacer(),
                Text(
                  o.totalPrice != null ? FoodOrderUi.formatVnd(o.totalPrice!) : '—',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatShort(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }
}

class _OrderLineTile extends StatelessWidget {
  final OrderLineItemDto line;

  const _OrderLineTile({required this.line});

  @override
  Widget build(BuildContext context) {
    const thumb = 52.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: thumb,
              height: thumb,
              child: ProductImage(
                imageUrl: line.avatarProducts,
                fallbackLetter: line.productName,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(10),
                placeholderFontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '× ${line.quantity}  ·  ${FoodOrderUi.formatVnd(line.unitPrice)} / món',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
