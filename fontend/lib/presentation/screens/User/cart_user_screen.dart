import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/user_cart_dto.dart';
import 'package:shop_owner_screen/data/service/user_cart_api_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';
import 'package:shop_owner_screen/presentation/widgets/user_cart/empty_cart_view.dart';
import 'package:shop_owner_screen/presentation/widgets/user_menu/product_image.dart';
import 'package:shop_owner_screen/presentation/screens/User/checkout_user_screen.dart';

class CartUserScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onGoToMenu;
  final VoidCallback onCheckoutSuccess;

  const CartUserScreen({
    super.key,
    required this.userId,
    required this.onGoToMenu,
    required this.onCheckoutSuccess,
  });

  @override
  State<CartUserScreen> createState() => _CartUserScreenState();
}

class _CartUserScreenState extends State<CartUserScreen> {
  final _cart = UserCartApiService();
  late Future<CartSummaryDto> _future;
  final Set<int> _qtyBusy = {};

  @override
  void initState() {
    super.initState();
    _future = _cart.getCart(widget.userId);
  }

  void _reload() {
    setState(() {
      _future = _cart.getCart(widget.userId);
    });
  }

  Future<void> _setQuantity(CartLineDto it, int nextQty) async {
    if (nextQty < 1) return;
    setState(() {
      _qtyBusy.add(it.productId);
    });
    try {
      await _cart.addOrUpdate(widget.userId, it.productId, nextQty);
      _reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _qtyBusy.remove(it.productId);
        });
      }
    }
  }

  Future<void> _removeLine(CartLineDto it) async {
    setState(() {
      _qtyBusy.add(it.productId);
    });
    try {
      await _cart.addOrUpdate(widget.userId, it.productId, 0);
      _reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _qtyBusy.remove(it.productId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: FutureBuilder<CartSummaryDto>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(snap.error.toString(), style: const TextStyle(color: FoodOrderUi.textPrimary)),
              ),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cart = snap.data!;
          if (cart.items.isEmpty) {
            return EmptyCartView(onGoToMenu: widget.onGoToMenu);
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  children: cart.items.map((it) {
                    final busy = _qtyBusy.contains(it.productId);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: ProductImage(
                                  imageUrl: it.avatarProducts,
                                  fallbackLetter: it.productName,
                                  fit: BoxFit.contain,
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
                                    it.productName,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: FoodOrderUi.textPrimary),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    FoodOrderUi.formatVnd(it.unitPrice),
                                    style: TextStyle(fontSize: 13, color: FoodOrderUi.textPrimary.withOpacity(0.65)),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _qtyBtn(
                                        icon: Icons.remove,
                                        onPressed: busy
                                            ? null
                                            : () {
                                                if (it.quantity <= 1) {
                                                  _removeLine(it);
                                                } else {
                                                  _setQuantity(it, it.quantity - 1);
                                                }
                                              },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: busy
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              )
                                            : Text(
                                                '${it.quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color: FoodOrderUi.textPrimary,
                                                ),
                                              ),
                                      ),
                                      _qtyBtn(
                                        icon: Icons.add,
                                        onPressed: busy ? null : () => _setQuantity(it, it.quantity + 1),
                                      ),
                                      const Spacer(),
                                      Text(
                                        FoodOrderUi.formatVnd(it.lineTotal),
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: FoodOrderUi.textPrimary),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, color: FoodOrderUi.textPrimary.withOpacity(0.45)),
                                        onPressed: busy ? null : () => _removeLine(it),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: FoodOrderUi.textPrimary.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tạm tính',
                            style: TextStyle(fontWeight: FontWeight.w600, color: FoodOrderUi.textPrimary),
                          ),
                          Text(
                            FoodOrderUi.formatVnd(cart.subtotal),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: FoodOrderUi.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () async {
                            final ok = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => CheckoutUserScreen(
                                  userId: widget.userId,
                                  subtotal: cart.subtotal,
                                ),
                              ),
                            );
                            if (ok == true) {
                              widget.onCheckoutSuccess();
                              _reload();
                            }
                          },
                          child: const Text('Thanh toán'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback? onPressed}) {
    return Material(
      color: FoodOrderUi.chipSelectedBg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: FoodOrderUi.textPrimary.withOpacity(onPressed == null ? 0.3 : 1)),
        ),
      ),
    );
  }
}
