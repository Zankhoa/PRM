import 'package:flutter/material.dart';

// 1. DATA MODEL: Định nghĩa cấu trúc dữ liệu cho một đơn hàng
class OrderItem {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final String imageUrl;
  final DateTime orderTime; // Thời gian đặt hàng để lọc
  String status; // 'pending', 'confirmed', 'cancelled'

  OrderItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.orderTime,
    this.status = 'pending',
  });
}

class VerifyOrder extends StatefulWidget {
  const VerifyOrder({super.key});

  @override
  State<VerifyOrder> createState() => _VerifyOrderState();
}

class _VerifyOrderState extends State<VerifyOrder> {
  // 2. DUMMY DATA: Tạo dữ liệu mẫu
  List<OrderItem> allOrders = [
    OrderItem(
      id: '1',
      title: "Truffle Beef Burger",
      subtitle: "Main Course • 250g",
      price: 18.50,
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjarPqQQhlhk1FkuQNgR9-EGuZQQth3NHKJQ&s",
      orderTime: DateTime.now(), // Đơn hôm nay
    ),
    OrderItem(
      id: '2',
      title: "Classic Caesar Salad",
      subtitle: "Starters • Healthy Choice",
      price: 12.00,
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/2/23/Caesar_salad_%282%29.jpg",
      orderTime: DateTime.now().subtract(const Duration(hours: 5)), // Đơn hôm nay (sớm hơn)
    ),
    OrderItem(
      id: '3',
      title: "Spaghetti Bolognese",
      subtitle: "Pasta • Italian",
      price: 15.00,
      imageUrl: "https://www.recipetineats.com/wp-content/uploads/2018/07/Spaghetti-Bolognese.jpg",
      orderTime: DateTime.now().subtract(const Duration(days: 1)), // Đơn hôm qua
    ),
    OrderItem(
      id: '4',
      title: "Grilled Salmon",
      subtitle: "Seafood • Fresh",
      price: 22.50,
      imageUrl: "https://www.dinneratthezoo.com/wp-content/uploads/2019/05/grilled-salmon-fillets-5.jpg",
      orderTime: DateTime.now().subtract(const Duration(days: 5)), // Đơn 5 ngày trước
    ),
  ];

  // Biến lưu trạng thái lọc hiện tại
  String _filterType = "Tất cả"; // "Tất cả", "Hôm nay", "7 ngày qua"

  // 3. LOGIC LỌC: Lấy danh sách hiển thị dựa trên bộ lọc
  List<OrderItem> get filteredOrders {
    final now = DateTime.now();
    return allOrders.where((order) {
      // Chỉ hiển thị đơn chưa xử lý (pending) để Verify
      // Nếu bạn muốn hiện cả đơn đã xác nhận thì bỏ điều kiện status == 'pending'
      if (order.status != 'pending') return false;

      if (_filterType == "Hôm nay") {
        return order.orderTime.year == now.year &&
            order.orderTime.month == now.month &&
            order.orderTime.day == now.day;
      } else if (_filterType == "7 ngày qua") {
        return order.orderTime.isAfter(now.subtract(const Duration(days: 7)));
      }
      return true; // "Tất cả"
    }).toList();
  }

  // 4. LOGIC XÁC NHẬN
  void _confirmOrder(OrderItem item) {
    setState(() {
      item.status = 'confirmed';
      // Ở thực tế, bạn sẽ gọi API ở đây
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã xác nhận đơn: ${item.title}"), backgroundColor: Colors.green),
    );
  }

  // 5. LOGIC HỦY
  void _cancelOrder(OrderItem item) {
    setState(() {
      item.status = 'cancelled';
      // Ở thực tế, bạn sẽ gọi API ở đây
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã hủy đơn: ${item.title}"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "Order Product",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE0FFF0),
              child: Icon(Icons.person, color: Colors.green),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search menu items...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // --- PHẦN LỌC THỜI GIAN (MỚI) ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip("Tất cả"),
                const SizedBox(width: 8),
                _buildFilterChip("Hôm nay"),
                const SizedBox(width: 8),
                _buildFilterChip("7 ngày qua"),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // List Orders
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("Không có đơn hàng nào ($getFilterText)", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final item = filteredOrders[index];
                      return _buildMenuCard(item, context);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  String get getFilterText => _filterType;

  // Widget hiển thị nút lọc
  Widget _buildFilterChip(String label) {
    bool isSelected = _filterType == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _filterType = label;
        });
      },
      selectedColor: const Color(0xFF6C63FF),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard_outlined, 'Dashboard', false, () {}),
              _buildNavItem(Icons.shopping_bag_outlined, 'Đơn hàng', true, () {}),
              _buildNavItem(Icons.person_outline, 'Hồ sơ', false, () {}),
              _buildNavItem(Icons.settings_outlined, 'Quản lý', false, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C63FF).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(OrderItem item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Hình ảnh
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(item.imageUrl),
                fit: BoxFit.cover,
                // Handle lỗi load ảnh
                onError: (exception, stackTrace) {},
              ),
              color: Colors.grey[200], // Màu nền khi chưa load ảnh
            ),
          ),
          const SizedBox(width: 12),
          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  // Hiển thị ngày giờ
                  "${item.orderTime.hour}:${item.orderTime.minute} - ${item.orderTime.day}/${item.orderTime.month}",
                  style: TextStyle(fontSize: 10, color: Colors.blueGrey[300]),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Nút hành động
          Column(
            children: [
              IconButton(
                onPressed: () => _confirmOrder(item),
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                tooltip: "Xác nhận",
              ),
              IconButton(
                onPressed: () => _cancelOrder(item),
                icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                tooltip: "Hủy bỏ",
              ),
            ],
          ),
        ],
      ),
    );
  }
}