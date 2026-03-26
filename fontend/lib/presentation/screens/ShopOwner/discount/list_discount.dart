import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/service/discount_service.dart';
import 'package:shop_owner_screen/data/models/discount_dto.dart';
import 'create_discount.dart';
import 'discount_detail.dart';

class ListDiscountScreen extends StatefulWidget {
  final int userId;
  const ListDiscountScreen({super.key, required this.userId});

  @override
  State<ListDiscountScreen> createState() => _ListDiscountScreenState();
}

class _ListDiscountScreenState extends State<ListDiscountScreen> {
  List<DiscountDTO>? _discounts;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDiscounts();
  }

  Future<void> _fetchDiscounts() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await DiscountService.getDiscounts(widget.userId);
      setState(() { _discounts = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Discount Management"),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateDiscountScreen(userId: widget.userId)),
          );
          _fetchDiscounts(); // reload sau khi tạo mới
        },
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
              const Text('Không thể tải danh sách khuyến mãi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchDiscounts,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final data = _discounts ?? [];

    if (data.isEmpty) {
      return const Center(child: Text("Chưa có khuyến mãi nào"));
    }

    return RefreshIndicator(
      onRefresh: _fetchDiscounts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final d = data[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 3))
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Text(d.discountCode,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text("Giảm: ${d.percentDiscount}%"),
                  Text("Hiệu lực: ${d.startDate} → ${d.endDate}"),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DiscountDetailScreen(id: d.discountId, userId: widget.userId)),
                );
                _fetchDiscounts(); // reload sau khi edit
              },
            ),
          );
        },
      ),
    );
  }
}