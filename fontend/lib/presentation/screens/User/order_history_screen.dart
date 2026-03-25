import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/order_history_dto.dart';
import 'package:shop_owner_screen/data/service/order_history_service.dart';
import 'package:shop_owner_screen/presentation/widgets/CustomBottomNav/custom_bottom_user.dart';
import 'package:shop_owner_screen/presentation/widgets/history_order/custom_bottom_nav.dart' hide CustomBottomNav;
import 'package:shop_owner_screen/presentation/widgets/history_order/history_order_widgets.dart';

class OrderHistoryScreen extends StatefulWidget {
  final int userId; // Nhận userId từ màn hình trước truyền sang
  const OrderHistoryScreen({super.key, required this.userId});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final HistoryOrderService _HistoryOrderService = HistoryOrderService();
  final ScrollController _scrollController = ScrollController();
  
  List<OrderHistoryDto> _orders = [];
  int _page = 1;
  final int _pageSize = 10; // Mỗi lần lấy 10 đơn
  
  bool _isLoading = false; // Đang lấy data lần đầu
  bool _isFetchingMore = false; // Đang kéo xuống lấy thêm
  bool _hasMoreData = true; // Cờ kiểm tra xem DB còn data không

  @override
  void initState() {
    super.initState();
    _fetchInitialOrders();

    // Lắng nghe sự kiện cuộn
    _scrollController.addListener(() {
      // Nếu cuộn chạm đáy, đang không load, và vẫn còn data -> Lấy thêm
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50 &&
          !_isFetchingMore &&
          _hasMoreData) {
        _fetchMoreOrders();
      }
    });
  }

  Future<void> _fetchInitialOrders() async {
    setState(() => _isLoading = true);
    
    final data = await _HistoryOrderService.fetchOrderHistory(widget.userId, _page, _pageSize);
    
    setState(() {
      _orders = data;
      _isLoading = false;
      if (data.length < _pageSize) _hasMoreData = false;
    });
  }

  Future<void> _fetchMoreOrders() async {
    setState(() => _isFetchingMore = true);
    _page++; // Tăng trang lên
    
    final newData = await _HistoryOrderService.fetchOrderHistory(widget.userId, _page, _pageSize);
    
    setState(() {
      if (newData.isEmpty) {
        _hasMoreData = false; // Hết data rồi
      } else {
        _orders.addAll(newData); // Nối data mới vào data cũ
        if (newData.length < _pageSize) _hasMoreData = false;
      }
      _isFetchingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        title: const Text(
          "Order History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar (Giao diện tĩnh như cũ)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search past orders",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
            child: Text(
              "RECENT TRANSACTIONS",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          // Danh sách đơn hàng động
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) // Vòng xoay khi load lần đầu
                : _orders.isEmpty 
                    ? const Center(child: Text("Không có đơn hàng nào."))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _orders.length + (_isFetchingMore ? 1 : 0), // Cộng 1 để chừa chỗ cho vòng xoay ở đáy
                        itemBuilder: (context, index) {
                          // Nếu đang render đến phần tử cuối cùng và đang fetch thêm data
                          if (index == _orders.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return OrderCardWidget(order: _orders[index]);
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}