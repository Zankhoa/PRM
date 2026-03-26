import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/user_product_dto.dart';
import 'package:shop_owner_screen/data/service/user_cart_api_service.dart';
import 'package:shop_owner_screen/data/service/user_catalog_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';
import 'package:shop_owner_screen/presentation/widgets/CustomBottomNav/custom_bottom_user.dart';
import 'package:shop_owner_screen/presentation/widgets/user_menu/product_grid_card.dart';
import 'package:shop_owner_screen/presentation/screens/User/product_detail_user_screen.dart';

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
          content: Text('Đã thêm: ${p.name}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _categoryChip({required String label, required bool selected, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        showCheckmark: false,
        avatar: selected
            ? Icon(Icons.check, size: 18, color: Theme.of(context).colorScheme.primary)
            : null,
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Tìm món...',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _load(),
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _categoryChip(
                  label: 'Tất cả',
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
                  'Sản phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: FoodOrderUi.chipSelectedBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_list.length} món',
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
                            style: const TextStyle(color: FoodOrderUi.textPrimary),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        onRefresh: _load,
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                final ok = await Navigator.of(context).push<bool>(
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
      bottomNavigationBar: CustomBottomNav(userId: widget.userId),
    );
  }
}
