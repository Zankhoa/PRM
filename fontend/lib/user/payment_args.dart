import '../models/models.dart';

class PaymentArgs {
  final double subtotal;
  final Discount? discount;
  final double discountAmount;
  final double total;
  final List<CartItem> items;

  PaymentArgs({
    required this.subtotal,
    this.discount,
    required this.discountAmount,
    required this.total,
    required this.items,
  });
}
