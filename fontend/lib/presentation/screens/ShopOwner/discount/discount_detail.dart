import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/service/discount_service.dart';
import 'package:shop_owner_screen/data/models/discount_dto.dart';

class DiscountDetailScreen extends StatefulWidget {
  final int id;
  final int userId;
  const DiscountDetailScreen({super.key, required this.id, required this.userId});

  @override
  State<DiscountDetailScreen> createState() => _DiscountDetailScreenState();
}

class _DiscountDetailScreenState extends State<DiscountDetailScreen> {
  DiscountDTO? _discount;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final d = await DiscountService.getDetail(widget.id, widget.userId);
      setState(() { _discount = d; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết khuyến mãi"), centerTitle: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetch, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    final d = _discount!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.discountCode, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Giảm: ${d.percentDiscount}%"),
                Text("Bắt đầu: ${d.startDate}"),
                Text("Kết thúc: ${d.endDate}"),
                Text("Trạng thái: ${d.isActive ? 'Đang hoạt động' : 'Không hoạt động'}"),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.delete),
              label: const Text("Xoá khuyến mãi"),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Xác nhận xoá'),
                    content: Text('Xoá mã "${d.discountCode}"?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  await DiscountService.delete(d.discountId, widget.userId);
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}