import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/discount_preview_helper.dart';
import 'package:shop_owner_screen/data/models/user_discount_dto.dart';
import 'package:shop_owner_screen/data/service/user_checkout_service.dart';
import 'package:shop_owner_screen/data/service/user_discount_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class CheckoutUserScreen extends StatefulWidget {
  final int userId;
  final double subtotal;

  const CheckoutUserScreen({
    super.key,
    required this.userId,
    required this.subtotal,
  });

  @override
  State<CheckoutUserScreen> createState() => _CheckoutUserScreenState();
}

class _CheckoutUserScreenState extends State<CheckoutUserScreen> {
  final _addr = TextEditingController(text: '123 Đường demo, Q.1, TP.HCM');
  final _code = TextEditingController();
  final _checkout = UserCheckoutService();
  final _discounts = UserDiscountService();

  bool _busy = false;
  List<UserDiscountDto> _activeList = [];
  bool _loadingDiscounts = true;
  String? _loadDiscountError;
  int? _selectedDiscountId;

  @override
  void initState() {
    super.initState();
    _loadDiscounts();
  }

  Future<void> _loadDiscounts() async {
    setState(() {
      _loadingDiscounts = true;
      _loadDiscountError = null;
    });
    try {
      final list = await _discounts.fetchActive();
      if (!mounted) return;
      setState(() {
        _activeList = list;
        _loadingDiscounts = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingDiscounts = false;
        _loadDiscountError = e.toString();
      });
    }
  }

  void _selectDiscountChip(UserDiscountDto d) {
    final p = d.percentDiscount;
    if (p == null || p <= 0) return;
    setState(() {
      _selectedDiscountId = d.discountId;
      _code.text = d.discountCode;
    });
  }

  void _clearDiscountSelection() {
    setState(() {
      _selectedDiscountId = null;
      _code.clear();
    });
  }

  double get _previewDiscount {
    final raw = _code.text.trim();
    if (raw.isEmpty) return 0;
    final pct = DiscountPreviewHelper.matchPercent(raw, _activeList);
    if (pct == null) return 0;
    return DiscountPreviewHelper.discountAmount(widget.subtotal, pct);
  }

  @override
  void dispose() {
    _addr.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fee = 15000.0;
    final disc = _previewDiscount;
    final afterDisc = (widget.subtotal - disc).clamp(0.0, double.infinity);
    final grandTotal = afterDisc + fee;

    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: const Text('Thanh toán')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _addr,
            decoration: const InputDecoration(
              labelText: 'Địa chỉ giao hàng',
              labelStyle: TextStyle(color: FoodOrderUi.textPrimary),
            ),
            maxLines: 2,
            style: const TextStyle(color: FoodOrderUi.textPrimary),
          ),
          const SizedBox(height: 20),
          const Text(
            'Mã giảm giá',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: FoodOrderUi.textPrimary),
          ),
          const SizedBox(height: 8),
          if (_loadingDiscounts)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else if (_loadDiscountError != null)
            Text(_loadDiscountError!, style: TextStyle(fontSize: 13, color: Colors.red.shade700))
          else if (_activeList.isEmpty)
            Text(
              'Hiện không có mã khả dụng. Bạn vẫn có thể nhập mã thủ công bên dưới.',
              style: TextStyle(fontSize: 13, color: FoodOrderUi.textPrimary.withOpacity(0.65)),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _activeList.map((d) {
                final p = d.percentDiscount;
                if (p == null || p <= 0) return const SizedBox.shrink();
                final sel = _selectedDiscountId == d.discountId;
                return FilterChip(
                  showCheckmark: true,
                  selected: sel,
                  label: Text('${d.discountCode} (-$p%)'),
                  onSelected: (selected) {
                    if (selected) {
                      _selectDiscountChip(d);
                    } else if (_selectedDiscountId == d.discountId) {
                      _clearDiscountSelection();
                    }
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _code,
            decoration: const InputDecoration(
              labelText: 'Hoặc nhập mã thủ công',
              labelStyle: TextStyle(color: FoodOrderUi.textPrimary),
            ),
            style: const TextStyle(color: FoodOrderUi.textPrimary),
            onChanged: (_) {
              setState(() {
                _selectedDiscountId = null;
              });
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tạm tính', style: TextStyle(color: FoodOrderUi.textPrimary.withOpacity(0.85))),
                      Text(
                        FoodOrderUi.formatVnd(widget.subtotal),
                        style: const TextStyle(fontWeight: FontWeight.w600, color: FoodOrderUi.textPrimary),
                      ),
                    ],
                  ),
                  if (disc > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Giảm giá', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500)),
                        Text('- ${FoodOrderUi.formatVnd(disc)}', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green.shade700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sau giảm', style: TextStyle(fontWeight: FontWeight.w500, color: FoodOrderUi.textPrimary)),
                        Text(
                          FoodOrderUi.formatVnd(afterDisc),
                          style: const TextStyle(fontWeight: FontWeight.w600, color: FoodOrderUi.textPrimary),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phí giao', style: TextStyle(color: FoodOrderUi.textPrimary.withOpacity(0.85))),
                      Text(FoodOrderUi.formatVnd(fee), style: const TextStyle(fontWeight: FontWeight.w500, color: FoodOrderUi.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.w800, color: FoodOrderUi.textPrimary)),
                      Text(
                        FoodOrderUi.formatVnd(grandTotal),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: FoodOrderUi.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _busy
                  ? null
                  : () async {
                      setState(() {
                        _busy = true;
                      });
                      try {
                        final r = await _checkout.checkout(
                          userId: widget.userId,
                          deliveryAddress: _addr.text.trim(),
                          discountCode: _code.text.trim().isEmpty ? null : _code.text.trim(),
                          deliveryFee: fee,
                        );
                        if (!mounted) return;
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: const Text('Đặt hàng thành công'),
                            content: Text('Mã đơn: #${r.orderId}\n${FoodOrderUi.formatVnd(r.totalPrice)}'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        if (!mounted) return;
                        Navigator.pop(context, true);
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      } finally {
                        if (mounted) {
                          setState(() {
                            _busy = false;
                          });
                        }
                      }
                    },
              child: _busy
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Xác nhận thanh toán'),
            ),
          ),
        ],
      ),
    );
  }
}
