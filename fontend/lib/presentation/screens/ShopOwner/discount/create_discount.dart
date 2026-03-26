import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/service/discount_service.dart';

class CreateDiscountScreen extends StatefulWidget {
  final int userId;
  const CreateDiscountScreen({super.key, required this.userId});

  @override
  State<CreateDiscountScreen> createState() => _CreateDiscountScreenState();
}

class _CreateDiscountScreenState extends State<CreateDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final percentController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    codeController.dispose();
    percentController.dispose();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      ctrl.text = picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo khuyến mãi"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(labelText: "Mã giảm giá", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Bắt buộc nhập" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: percentController,
                decoration: const InputDecoration(labelText: "% Giảm", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? "Bắt buộc nhập" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: startController,
                readOnly: true,
                onTap: () => _pickDate(startController),
                decoration: const InputDecoration(
                  labelText: "Ngày bắt đầu",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: endController,
                readOnly: true,
                onTap: () => _pickDate(endController),
                decoration: const InputDecoration(
                  labelText: "Ngày kết thúc",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () async {
                    if (!_formKey.currentState!.validate()) return;
                    setState(() => _isSaving = true);
                    final ok = await DiscountService.create(widget.userId, {
                      "discountCode": codeController.text.trim(),
                      "percentDiscount": int.tryParse(percentController.text) ?? 0,
                      "startDate": startController.text,
                      "endDate": endController.text,
                      "isActive": true,
                    });
                    setState(() => _isSaving = false);
                    if (!mounted) return;
                    if (ok) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tạo thất bại, thử lại'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("Tạo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}