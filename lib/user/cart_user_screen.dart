import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import 'cart_state.dart';
import 'discount_list_user_screen.dart';
import 'payment_args.dart';

class CartUserScreen extends StatefulWidget {
  const CartUserScreen({super.key});

  @override
  State<CartUserScreen> createState() => _CartUserScreenState();
}

class _CartUserScreenState extends State<CartUserScreen> {
  Discount? _selectedDiscount;

  @override
  void initState() {
    super.initState();
    CartState.onChanged = () => setState(() {});
  }

  @override
  void dispose() {
    CartState.onChanged = null;
    super.dispose();
  }

  double get _discountAmount {
    if (_selectedDiscount == null) return 0;
    if (!_selectedDiscount!.isActive) return 0;
    if (CartState.subtotal < _selectedDiscount!.minOrderAmount) return 0;
    return CartState.subtotal * (_selectedDiscount!.percentage / 100);
  }

  double get _total => CartState.subtotal - _discountAmount;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

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
              Expanded(
                child: CartState.items.isEmpty
                    ? _buildEmptyCart()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Giỏ hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...CartState.items.map((item) => _buildCartItem(
                                context, item, currencyFormat)),
                            const SizedBox(height: 20),
                            _buildDiscountSection(context),
                            const SizedBox(height: 20),
                            _buildSummary(currencyFormat),
                          ],
                        ),
                      ),
              ),
              if (CartState.items.isNotEmpty) _buildCheckoutBar(currencyFormat),
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
              'Giỏ hàng',
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

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Giỏ hàng trống',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Xem menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      BuildContext context, CartItem item, NumberFormat currencyFormat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.2),
                  const Color(0xFFFF6584).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(item.product.imageUrl, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                Text(
                  currencyFormat.format(item.product.price),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (item.quantity <= 1) {
                    CartState.remove(item.product);
                  } else {
                    CartState.setQuantity(item.product, item.quantity - 1);
                  }
                },
                color: const Color(0xFF6C63FF),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () =>
                    CartState.setQuantity(item.product, item.quantity + 1),
                color: const Color(0xFF6C63FF),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            onPressed: () => CartState.remove(item.product),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mã giảm giá',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final discount = await Navigator.push<Discount>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiscountListUserScreen(),
                    ),
                  );
                  if (discount != null && mounted) {
                    setState(() => _selectedDiscount = discount);
                  }
                },
                child: const Text('Chọn mã'),
              ),
            ],
          ),
          if (_selectedDiscount != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.discount, color: Color(0xFF6C63FF)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_selectedDiscount!.code} - ${_selectedDiscount!.percentage}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _selectedDiscount = null),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummary(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          _summaryRow('Tạm tính', currencyFormat.format(CartState.subtotal)),
          if (_discountAmount > 0)
            _summaryRow(
                'Giảm giá', '-${currencyFormat.format(_discountAmount)}',
                valueColor: const Color(0xFF4CAF50)),
          const Divider(height: 24),
          _summaryRow('Tổng cộng', currencyFormat.format(_total),
              isBold: true, valueColor: const Color(0xFF6C63FF)),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF2D3142),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? const Color(0xFF2D3142),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tổng thanh toán',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    currencyFormat.format(_total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/user-payment',
                    arguments: PaymentArgs(
                      subtotal: CartState.subtotal,
                      discount: _selectedDiscount,
                      discountAmount: _discountAmount,
                      total: _total,
                      items: List.from(CartState.items),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Thanh toán'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

