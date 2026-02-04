import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../models/mock_data.dart';
import 'discount_detail_screen.dart';

class DiscountListScreen extends StatefulWidget {
  const DiscountListScreen({super.key});

  @override
  State<DiscountListScreen> createState() => _DiscountListScreenState();
}

class _DiscountListScreenState extends State<DiscountListScreen> {
  String _selectedFilter = 'Tất cả';
  final List<String> _filterOptions = ['Tất cả', 'Đang hoạt động', 'Hết hạn', 'Hết lượt'];

  List<Discount> get _filteredDiscounts {
    var discounts = MockData.discounts;
    
    switch (_selectedFilter) {
      case 'Đang hoạt động':
        discounts = discounts.where((d) => d.isActive).toList();
        break;
      case 'Hết hạn':
        discounts = discounts.where((d) => DateTime.now().isAfter(d.endDate)).toList();
        break;
      case 'Hết lượt':
        discounts = discounts.where((d) => d.usedCount >= d.quantity).toList();
        break;
    }
    
    return discounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6584).withOpacity(0.1),
              const Color(0xFF6C63FF).withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildFilterChips(),
              Expanded(
                child: _filteredDiscounts.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _filteredDiscounts.length,
                        itemBuilder: (context, index) {
                          return _buildDiscountCard(_filteredDiscounts[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-discount'),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add),
        label: const Text(
          'Tạo mã mới',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Quản lý giảm giá',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filterOptions.map((option) {
            final isSelected = _selectedFilter == option;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedFilter = option);
                },
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFFFF6584).withOpacity(0.2),
                checkmarkColor: const Color(0xFFFF6584),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFFFF6584) : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? const Color(0xFFFF6584) : Colors.grey[300]!,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.discount_outlined,
              size: 64,
              color: Color(0xFFFF6584),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Không có mã giảm giá',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chưa có mã giảm giá nào phù hợp',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCard(Discount discount) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isExpired = DateTime.now().isAfter(discount.endDate);
    final isOutOfStock = discount.usedCount >= discount.quantity;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiscountDetailScreen(discount: discount),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF6584).withOpacity(0.2),
                          const Color(0xFFFF4757).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${discount.percentage}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6584),
                            ),
                          ),
                          const Text(
                            'OFF',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6584),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discount.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            discount.code,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${dateFormat.format(discount.startDate)} - ${dateFormat.format(discount.endDate)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_number,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Còn ${discount.remainingQuantity}/${discount.quantity} lượt',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            if (isExpired || isOutOfStock)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isExpired ? 'ĐÃ HẾT HẠN' : 'HẾT LƯỢT SỬ DỤNG',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}