import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/user_product_dto.dart';
import 'package:shop_owner_screen/data/service/user_cart_api_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';
import 'package:shop_owner_screen/presentation/widgets/user_menu/product_image.dart';

class ProductDetailUserScreen extends StatefulWidget {
  final int userId;
  final UserProductDto product;

  const ProductDetailUserScreen({super.key, required this.userId, required this.product});

  @override
  State<ProductDetailUserScreen> createState() => _ProductDetailUserScreenState();
}

class _ProductDetailUserScreenState extends State<ProductDetailUserScreen> {
  final _cart = UserCartApiService();
  int _qty = 1;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final scheme = Theme.of(context).colorScheme;
    final isAvailable = p.isAvailable ?? true;
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: Text(p.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: ProductImage(
                imageUrl: p.avatarProducts,
                fallbackLetter: p.name,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            p.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: FoodOrderUi.textPrimary),
          ),
          if (p.category != null)
            Text(p.category!, style: TextStyle(color: FoodOrderUi.textPrimary.withOpacity(0.6))),
          const SizedBox(height: 8),
          Text(FoodOrderUi.formatVnd(p.price), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scheme.primary)),
          if (p.description != null && p.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(p.description!),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              IconButton(
                onPressed: (!isAvailable || _qty <= 1 || _busy)
                    ? null
                    : () {
                        setState(() {
                          _qty--;
                        });
                      },
                icon: const Icon(Icons.remove),
              ),
              Text('$_qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              IconButton(
                onPressed: (!isAvailable || _busy)
                    ? null
                    : () {
                        setState(() {
                          _qty++;
                        });
                      },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          FilledButton(
            onPressed: (!isAvailable || _busy)
                ? null
                : () async {
                    setState(() {
                      _busy = true;
                    });
                    final nav = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await _cart.addOrUpdate(widget.userId, p.productId, _qty);
                      if (!mounted) return;
                      nav.pop(true);
                    } catch (e) {
                      if (!mounted) return;
                      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
                    } finally {
                      if (mounted) {
                        setState(() {
                          _busy = false;
                        });
                      }
                    }
                  },
            child: _busy
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Text('Thêm vào giỏ'),
          ),
          if (!isAvailable)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Sản phẩm hiện đang tạm ngừng. Vui lòng chọn món khác.',
                style: TextStyle(color: scheme.errorContainer),
              ),
            ),
        ],
      ),
    );
  }
}
