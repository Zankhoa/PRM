import 'package:flutter/material.dart';

class UpdateProduct extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Nhận dữ liệu truyền sang

  const UpdateProduct({super.key, this.initialData});

  @override
  State<UpdateProduct> createState() => _UpdateProduct();
}

class _UpdateProduct extends State<UpdateProduct> {
  // Khai báo các Controller
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Nếu có dữ liệu truyền vào (chế độ Update), thì gán vào Controller
    // Nếu không có (chế độ New), thì để trống
    nameController = TextEditingController(text: widget.initialData?['title'] ?? "");
    priceController = TextEditingController(text: widget.initialData?['price'] ?? "");
    descriptionController = TextEditingController(text: widget.initialData?['subtitle'] ?? "");
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate = widget.initialData != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isUpdate ? "Update Product" : "New Product", 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // --- TRUYỀN CONTROLLER VÀO CÁC Ô NHẬP ---
            _buildInputField("Product Name", "e.g. Burger", controller: nameController),
            _buildInputField("Price", "\$ 0.00", isNumber: true, controller: priceController),
            _buildInputField("Description", "Describe it...", isMultiline: true, controller: descriptionController),

            const SizedBox(height: 30),
            _buildActionButtons(isUpdate),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {
    TextEditingController? controller, 
    bool isNumber = false, 
    bool isMultiline = false
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller, // QUAN TRỌNG: Gán controller ở đây
            maxLines: isMultiline ? 4 : 1,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildActionButtons(bool isUpdate) {
    return Row(
      children: [
        // Nút Cancel
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
          ),
        ),
        const SizedBox(width: 15),
        // Nút Save / Update
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              // Lấy dữ liệu từ controller để xử lý
              final name = nameController.text;
              final price = priceController.text;
              
              print("Đang lưu: $name với giá $price");
              
              // Logic gọi API ASP.NET 9 của bạn sẽ đặt ở đây
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF7F), // Màu xanh neon như thiết kế
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              isUpdate ? "Update Product" : "Save Product", 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ],
    );
  }
}