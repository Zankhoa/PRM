import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/product_manage_dto.dart';
import 'package:shop_owner_screen/data/service/product_manage_service.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/CreateProduct.dart';
import 'package:shop_owner_screen/presentation/widgets/CustomBottomNav/custom_bottom_shopwoner.dart';
import 'package:shop_owner_screen/presentation/widgets/product_manage/product_card_widget.dart';
// Thay thế các đường dẫn import này cho đúng với project của bạn



class ListAccountManagment extends StatefulWidget {
  final int userId;
  const ListAccountManagment({super.key, required this.userId});

  @override
  State<ListAccountManagment> createState() => _ListAccountManagmenttScreenState();
}

class _ListAccountManagmenttScreenState extends State<ListAccountManagment> {
  final ProductManageService _productService = ProductManageService();
  final ScrollController _scrollController = ScrollController();
  
  List<ProductManageDto> _products = [];
  int _page = 1;
  final int _pageSize = 10;
  
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50 &&
          !_isFetchingMore &&
          _hasMoreData) {
        _fetchMoreProducts();
      }
    });
  }

  Future<void> _fetchInitialProducts() async {
    setState(() => _isLoading = true);
    try {
      final data = await _productService.fetchProducts(widget.userId, _page, _pageSize);
      setState(() {
        _products = data;
        _isLoading = false;
        if (data.length < _pageSize) _hasMoreData = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMoreProducts() async {
    setState(() => _isFetchingMore = true);
    _page++;
    try {
      final newData = await _productService.fetchProducts(widget.userId, _page, _pageSize);
      setState(() {
        if (newData.isEmpty) {
          _hasMoreData = false;
        } else {
          _products.addAll(newData);
          if (newData.length < _pageSize) _hasMoreData = false;
        }
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() => _isFetchingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text("Management Product", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(backgroundColor: Color(0xFFE0FFF0), child: Icon(Icons.person, color: Colors.green)),
          ),
        ],
      ),
      body: Column(
        children: [
          /// SEARCH + ADD
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(hintText: "Search menu items...", prefixIcon: Icon(Icons.search), border: InputBorder.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ElevatedButton(
                  // 1. Chuyển thành hàm async để chờ kết quả trả về
                  onPressed: () async {
                    // 2. Lắng nghe tín hiệu trả về từ màn CreateProduct (biến result)
                    final result = await Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const CreateProduct())
                    );
                    
                    // 3. Nếu màn kia trả về true (tức là đã gọi API thêm thành công)
                    if (result == true) {
                      // Reset lại các biến phân trang về trạng thái ban đầu
                      setState(() {
                        _page = 1;
                        _products.clear();
                        _hasMoreData = true;
                      });
                      // Gọi lại hàm kéo dữ liệu mới nhất từ DB về
                      _fetchInitialProducts();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
          /// PRODUCT LIST (Đã gắn dữ liệu động)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(child: Text("Chưa có sản phẩm nào."))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _products.length + (_isFetchingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _products.length) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ProductCardWidget(product: _products[index]);
                        },
                      ),
          ),
        ],
      ),
      // Gọi lại thanh điều hướng dùng chung
      bottomNavigationBar: const CustomBottomNav(), 
    );
  }

  Widget _buildCategoryChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: const Color(0xFF6C63FF),
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }
}