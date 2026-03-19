import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import 'cart_state.dart';
import 'payment_args.dart';

class PaymentUserScreen extends StatefulWidget {
  const PaymentUserScreen({super.key});

  @override
  State<PaymentUserScreen> createState() => _PaymentUserScreenState();
}

class _PaymentUserScreenState extends State<PaymentUserScreen> {
  int _selectedMethod = 0; // 0: COD, 1: VNPay, 2: Momo
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isProcessing = false;

  static const List<Map<String, dynamic>> _paymentMethods = [
    {'icon': Icons.money, 'label': 'Thanh toán khi nhận hàng (COD)'},
    {'icon': Icons.credit_card, 'label': 'VNPay'},
    {'icon': Icons.phone_android, 'label': 'Ví Momo'},
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final args = ModalRoute.of(context)?.settings.arguments as PaymentArgs?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Thanh toán')),
        body: const Center(child: Text('Thiếu thông tin đơn hàng')),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6C63FF).withOpacity(0.05),
              const Color(0xFFFF6584).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Địa chỉ giao hàng'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _addressController,
                        hint: 'Nhập địa chỉ giao hàng',
                        icon: Icons.location_on_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Ghi chú'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _noteController,
                        hint: 'Ghi chú cho cửa hàng...',
                        icon: Icons.note_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Phương thức thanh toán'),
                      const SizedBox(height: 12),
                      ...List.generate(
                        _paymentMethods.length,
                        (index) => _buildPaymentOption(index),
                      ),
                      const SizedBox(height: 24),
                      _buildOrderSummary(args, currencyFormat),
                    ],
                  ),
                ),
              ),
              _buildPayButton(context, args, currencyFormat),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'Thanh toán',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3142),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index) {
    final method = _paymentMethods[index];
    final selected = _selectedMethod == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => setState(() => _selectedMethod = index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? const Color(0xFF6C63FF)
                    : Colors.grey.shade200,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  method['icon'] as IconData,
                  color: selected ? const Color(0xFF6C63FF) : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    method['label'] as String,
                    style: TextStyle(
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                      color: selected
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFF2D3142),
                    ),
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle,
                      color: Color(0xFF6C63FF), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(PaymentArgs args, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tóm tắt đơn hàng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow('Tạm tính', currencyFormat.format(args.subtotal)),
          if (args.discountAmount > 0)
            _summaryRow(
                'Giảm giá', '-${currencyFormat.format(args.discountAmount)}',
                valueColor: const Color(0xFF4CAF50)),
          const Divider(height: 24),
          _summaryRow('Tổng thanh toán',
              currencyFormat.format(args.total),
              isBold: true, valueColor: const Color(0xFF6C63FF)),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF2D3142),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? const Color(0xFF2D3142),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(
      BuildContext context, PaymentArgs args, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () => _handlePayment(context, args, currencyFormat),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Thanh toán ${currencyFormat.format(args.total)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayment(
      BuildContext context, PaymentArgs args, NumberFormat currencyFormat) async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    CartState.clear();

    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đặt hàng thành công! Đơn hàng đang được xử lý.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }
}
