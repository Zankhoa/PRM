import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/user_product_dto.dart';
import 'package:shop_owner_screen/data/service/user_cart_api_service.dart';
import 'package:shop_owner_screen/data/service/user_catalog_service.dart';
import 'package:shop_owner_screen/presentation/screens/User/blog_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/notifications_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/payment_status_screen.dart';
import 'package:shop_owner_screen/presentation/screens/User/product_detail_user_screen.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';
import 'package:shop_owner_screen/presentation/widgets/user_menu/product_grid_card.dart';

class ProductListUserScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onCartChanged;

  const ProductListUserScreen({
    super.key,
    required this.userId,
    required this.onCartChanged,
  });

  @override
  State<ProductListUserScreen> createState() => _ProductListUserScreenState();
}

class _ProductListUserScreenState extends State<ProductListUserScreen> {
  final _catalog = UserCatalogService();
  final _cart = UserCartApiService();
  final _search = TextEditingController();

  List<UserProductDto> _list = [];
  List<String> _categories = [];
  String? _categoryFilter;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cats = await _catalog.fetchCategories();
      final products = await _catalog.fetchProducts(
        category: _categoryFilter,
        search: _search.text.isEmpty ? null : _search.text,
      );
      setState(() {
        _categories = cats;
        _list = products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _quickAdd(UserProductDto p) async {
    try {
      await _cart.addOrUpdate(widget.userId, p.productId, 1);
      widget.onCartChanged();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added: ${p.name}'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _categoryChip(
      {required String label,
      required bool selected,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        showCheckmark: false,
        avatar: selected
            ? Icon(Icons.check,
                size: 18, color: Theme.of(context).colorScheme.primary)
            : null,
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }

  void _openPage(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () =>
                _openPage(NotificationsScreen(userId: widget.userId)),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _load(),
            ),
          ),
          SizedBox(
            height: 108,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _QuickLinkCard(
                  icon: Icons.article_outlined,
                  title: 'Blog',
                  subtitle: 'User posts and sharing',
                  onTap: () => _openPage(BlogScreen(userId: widget.userId)),
                ),
                _QuickLinkCard(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Order and account updates',
                  onTap: () =>
                      _openPage(NotificationsScreen(userId: widget.userId)),
                ),
                _QuickLinkCard(
                  icon: Icons.payments_outlined,
                  title: 'Payment Status',
                  subtitle: 'Check your order payment',
                  onTap: () =>
                      _openPage(PaymentStatusScreen(userId: widget.userId)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _categoryChip(
                  label: 'All',
                  selected: _categoryFilter == null,
                  onTap: () {
                    setState(() => _categoryFilter = null);
                    _load();
                  },
                ),
                ..._categories.map(
                  (c) => _categoryChip(
                    label: c,
                    selected: _categoryFilter == c,
                    onTap: () {
                      setState(() => _categoryFilter = c);
                      _load();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text(
                  'Products',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: FoodOrderUi.chipSelectedBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_list.length} items',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: FoodOrderUi.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(color: FoodOrderUi.textPrimary),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        onRefresh: _load,
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: _list.length,
                          itemBuilder: (context, i) {
                            final p = _list[i];
                            return ProductGridCard(
                              product: p,
                              onAddToCart: () => _quickAdd(p),
                              onOpenDetail: () async {
                                final ok =
                                    await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailUserScreen(
                                      userId: widget.userId,
                                      product: p,
                                    ),
                                  ),
                                );
                                if (ok == true && mounted) {
                                  widget.onCartChanged();
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 170,
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(FoodOrderUi.radiusMd),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: FoodOrderUi.chipSelectedBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: FoodOrderUi.textPrimary),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: FoodOrderUi.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: FoodOrderUi.textPrimary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
