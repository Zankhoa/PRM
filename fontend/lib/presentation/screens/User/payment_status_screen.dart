import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/payment_status_dto.dart';
import 'package:shop_owner_screen/data/service/payment_status_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class PaymentStatusScreen extends StatefulWidget {
  final int userId;
  final int? initialOrderId;

  const PaymentStatusScreen({
    super.key,
    required this.userId,
    this.initialOrderId,
  });

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  final PaymentStatusService _service = PaymentStatusService();
  late final TextEditingController _orderIdController;

  PaymentStatusDto? _payment;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _orderIdController = TextEditingController(
      text: widget.initialOrderId?.toString() ?? '',
    );
    if (widget.initialOrderId != null) {
      _lookup();
    }
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final orderId = int.tryParse(_orderIdController.text.trim());
    if (orderId == null || orderId <= 0) {
      setState(() {
        _error = 'Vui lòng nhập mã đơn hàng hợp lệ';
        _payment = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final payment = await _service.fetchPaymentStatus(
        userId: widget.userId,
        orderId: orderId,
      );
      if (!mounted) return;
      setState(() {
        _payment = payment;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _payment = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = (_payment?.status ?? '').toLowerCase();
    final statusColor = switch (status) {
      'paid' => const Color(0xFF2E7D32),
      'pending' => const Color(0xFFEF6C00),
      'failed' => const Color(0xFFC62828),
      _ => FoodOrderUi.textPrimary,
    };

    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: const Text('Trạng thái thanh toán')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tra cứu thanh toán theo mã đơn',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: FoodOrderUi.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _orderIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Mã đơn hàng',
                      prefixIcon: Icon(Icons.receipt_long_outlined),
                    ),
                    onSubmitted: (_) => _lookup(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _loading ? null : _lookup,
                      icon: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.search),
                      label: Text(_loading ? 'Đang tải...' : 'Kiểm tra'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Color(0xFFC62828)),
                ),
              ),
            )
          else if (_payment != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _payment!.status ?? 'Unknown',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: statusColor),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '#${_payment!.paymentId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: FoodOrderUi.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                        label: 'Phương thức',
                        value: _payment!.paymentMethod ?? 'N/A'),
                    _InfoRow(
                        label: 'Số tiền',
                        value: FoodOrderUi.formatVnd(_payment!.amount)),
                    _InfoRow(
                      label: 'Thời gian',
                      value: _payment!.createdAt == null
                          ? 'N/A'
                          : _formatDate(_payment!.createdAt!),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: FoodOrderUi.textPrimary.withOpacity(0.6)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: FoodOrderUi.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
