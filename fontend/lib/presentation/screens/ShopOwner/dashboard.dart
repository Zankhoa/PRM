import 'package:flutter/material.dart';
import 'package:shop_owner_screen/presentation/widgets/CustomBottomNav/custom_bottom_shopwoner.dart';
import 'package:shop_owner_screen/data/models/shop_dashboard_dto.dart';
import 'package:shop_owner_screen/data/service/shop_owner_service.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/discount/list_discount.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/profile.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;
  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ShopOwnerService _service = ShopOwnerService();
  ShopDashboardDto? _dashboard;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.fetchDashboard(widget.userId);
      setState(() {
        _dashboard = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavShopOwner(
        userId: widget.userId,
        currentTab: kTabDashboard,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Không thể kết nối đến server',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchDashboard,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A11CB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final d = _dashboard;

    return RefreshIndicator(
      onRefresh: _fetchDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // ── HEADER ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Xin chào, Shop Owner 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(userId: widget.userId),
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── STATS CARDS ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng quan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildStatCard(
                        'Doanh thu',
                        d != null
                            ? '${_formatNumber(d.totalRevenue)}đ'
                            : '---',
                        Icons.attach_money_rounded,
                        const Color(0xFF6A11CB),
                      ),
                      _buildStatCard(
                        'Đơn hàng',
                        d?.totalOrders.toString() ?? '---',
                        Icons.receipt_long_rounded,
                        const Color(0xFF2575FC),
                      ),
                      _buildStatCard(
                        'Sản phẩm',
                        d?.totalProducts.toString() ?? '---',
                        Icons.fastfood_rounded,
                        const Color(0xFF11998E),
                      ),
                      _buildStatCard(
                        'Khuyến mãi',
                        d?.activeDiscounts.toString() ?? '---',
                        Icons.local_offer_rounded,
                        const Color(0xFFFF6B6B),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── TOP PRODUCTS ──
                  if (d != null && d.topProducts.isNotEmpty) ...[
                    const Text(
                      'Sản phẩm bán chạy',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: d.topProducts.length > 5 ? 5 : d.topProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final p = d.topProducts[index];
                        return _buildTopProductItem(index + 1, p);
                      },
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── QUICK ACCESS ──
                  const Text(
                    'Truy cập nhanh',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard('Khuyến mãi', Icons.local_offer_rounded, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ListDiscountScreen(userId: widget.userId)),
                    );
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(int rank, ProductSalesDto product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#$rank',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(
                  '${product.soldCount} đã bán • ${_formatNumber(product.revenue)}đ',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A11CB).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}