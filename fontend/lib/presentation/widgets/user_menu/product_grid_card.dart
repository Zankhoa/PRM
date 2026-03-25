import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/user_product_dto.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';
import 'package:shop_owner_screen/presentation/widgets/user_menu/product_image.dart';

class ProductGridCard extends StatelessWidget {
  final UserProductDto product;
  final VoidCallback onAddToCart;
  final VoidCallback? onOpenDetail;

  const ProductGridCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final detailTap = onOpenDetail;
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FoodOrderUi.radiusLg),
        side: BorderSide(color: FoodOrderUi.textPrimary.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  onTap: detailTap,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(FoodOrderUi.radiusLg)),
                  child: ProductImage(
                    imageUrl: product.avatarProducts,
                    fallbackLetter: product.name,
                    fit: BoxFit.contain,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(FoodOrderUi.radiusLg)),
                    placeholderFontSize: 36,
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Material(
                    color: scheme.primary,
                    shape: const CircleBorder(),
                    elevation: 2,
                    shadowColor: FoodOrderUi.textPrimary.withOpacity(0.25),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onAddToCart,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.add_shopping_cart_outlined, color: scheme.onPrimary, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: detailTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: FoodOrderUi.textPrimary,
                    ),
                  ),
                  if (product.category != null && product.category!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        product.category!,
                        style: TextStyle(fontSize: 11, color: FoodOrderUi.textPrimary.withOpacity(0.55)),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    FoodOrderUi.formatVnd(product.price),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
