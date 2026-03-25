import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/verify_order_dto.dart';
import 'package:shop_owner_screen/data/service/verify_order_service.dart';

class VerifyOrder extends StatefulWidget {
  final int userId; 
  
  const VerifyOrder({super.key, this.userId = 2}); 

  @override
  State<VerifyOrder> createState() => _VerifyOrderState();
}

class _VerifyOrderState extends State<VerifyOrder> {
  final VerifyOrderService _orderService = VerifyOrderService();
  
  List<OrderItem> allOrders = [];
  bool _isLoading = false;
  
  // SỬA: Đặt mặc định là "Đang chờ" cho hợp lý với màn hình Verify
  String _filterType = "Đang chờ"; 

  @override
  void initState() {
    super.initState();
    _loadOrdersFromApi();
  }

  // --- SỬA LẠI HÀM GỌI API ---
  Future<void> _loadOrdersFromApi() async {
    setState(() => _isLoading = true);
    
    // GỌI HÀM LẤY "TẤT CẢ" THAY VÌ PENDING
    final data = await _orderService.fetchAllOrders();
    
    setState(() {
      allOrders = data;
      _isLoading = false;
    });
  }

  // --- LOGIC LỌC CHUẨN XÁC ---
  List<OrderItem> get filteredOrders {
    return allOrders.where((order) {
      if (_filterType == "Đang chờ") {
        // Dùng toLowerCase() để đề phòng C# trả về 'Pending' hay 'pending'
        return order.status.toLowerCase() == 'pending'; 
      }
      
      // "Tất cả" sẽ giữ lại toàn bộ
      return true; 
    }).toList();
  }

  // --- LOGIC XÁC NHẬN ---
  Future<void> _confirmOrder(OrderItem item) async {
    bool success = await _orderService.updateOrderStatus(item.id, 'Confirmed');
    
    if (success) {
      setState(() {
        item.status = 'Confirmed'; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xác nhận đơn: ${item.title}"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi: Không thể xác nhận đơn"), backgroundColor: Colors.red),
      );
    }
  }

  // --- LOGIC HỦY ĐƠN ---
  Future<void> _cancelOrder(OrderItem item) async {
    bool success = await _orderService.updateOrderStatus(item.id, 'Cancelled');
    
    if (success) {
      setState(() {
        item.status = 'Cancelled';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã hủy đơn: ${item.title}"), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi: Không thể hủy đơn"), backgroundColor: Colors.red),
      );
    }
  }

  // --- HÀM VẼ ẢNH AN TOÀN ---
  Widget _buildSafeImage(String imageUrl) {
    try {
      if (imageUrl.startsWith('data:image')) {
        String cleanBase64 = imageUrl.contains(',') ? imageUrl.split(',').last.trim() : imageUrl.trim();
        return Image.memory(base64Decode(cleanBase64), fit: BoxFit.cover);
      }
      return Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.fastfood, color: Colors.grey));
    } catch (e) {
      return const Icon(Icons.fastfood, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text("Order Product", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(backgroundColor: Color(0xFFE0FFF0), child: Icon(Icons.person, color: Colors.green)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
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

          // --- THANH LỌC ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip("Đang chờ"), // Đổi thứ tự cho hợp với mặc định
                const SizedBox(width: 8),
                _buildFilterChip("Tất cả"),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // --- DANH SÁCH ĐƠN HÀNG ---
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("Không có đơn hàng ($_filterType)", style: const TextStyle(color: Colors.grey)),
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

  // --- WIDGET NÚT LỌC ---
  Widget _buildFilterChip(String label) {
    bool isSelected = _filterType == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _filterType = label; // Cập nhật biến _filterType, Flutter sẽ tự động gọi lại getter filteredOrders
        });
      },
      selectedColor: const Color(0xFF6C63FF),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      backgroundColor: Colors.white,
    );
  }

  // --- CARD ĐƠN HÀNG ---
  Widget _buildMenuCard(OrderItem item, BuildContext context) {
    // Biến kiểm tra xem đơn hàng này có phải đang Pending không
    bool isPending = item.status.toLowerCase() == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          // Hình ảnh
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200], 
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildSafeImage(item.imageUrl),
          ),
          const SizedBox(width: 12),
          
          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(item.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text("${item.orderTime.hour}:${item.orderTime.minute.toString().padLeft(2, '0')} - ${item.orderTime.day}/${item.orderTime.month}", style: TextStyle(fontSize: 10, color: Colors.blueGrey[300])),
                const SizedBox(height: 4),
                Text("\$${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          
          // NÚT HÀNH ĐỘNG HOẶC TRẠNG THÁI
          // SỬA: Nếu đang Pending thì hiện nút, nếu đã xử lý thì hiện chữ Trạng Thái
          if (isPending)
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
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: item.status.toLowerCase() == 'confirmed' ? Colors.green : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- BOTTOM NAV ---
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
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
            Icon(icon, color: isActive ? const Color(0xFF6C63FF) : Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: isActive ? const Color(0xFF6C63FF) : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}