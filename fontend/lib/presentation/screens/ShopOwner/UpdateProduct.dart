import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_owner_screen/data/service/product_manage_service.dart';

class UpdateProduct extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const UpdateProduct({super.key, this.initialData});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  // 1. Khai báo các Controller
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _nameCategory;
  
  late int _productId; // Bắt buộc phải có ID để biết đang sửa món nào

  // 2. Dropdown Status
  String _selectActive = "Active"; 
  final List<String> _statusOptions = ["Active", "Inactive"]; 
  
  // 3. Biến xử lý ảnh
  String? _imageString; // Có thể là link http hoặc chuỗi base64
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  final ProductManageService _productService = ProductManageService();

  @override
  void initState() {
    super.initState();
    // Đổ dữ liệu cũ vào các ô text khi vừa mở màn hình
    _productId = widget.initialData?['productId'] ?? 0;
    _nameCtrl = TextEditingController(text: widget.initialData?['title'] ?? '');
    _priceCtrl = TextEditingController(text: widget.initialData?['price']?.toString() ?? '');
    _descCtrl = TextEditingController(text: widget.initialData?['description'] ?? '');
    _nameCategory = TextEditingController(text: widget.initialData?['category'] ?? '');
    
    // Load trạng thái cũ
    bool isAvailable = widget.initialData?['isAvailable'] ?? true;
    _selectActive = isAvailable ? "Active" : "Inactive";
    
    // Load ảnh cũ
    _imageString = widget.initialData?['image'];
  }

  // --- HÀM CHỌN ẢNH VÀ CHUYỂN THÀNH BASE64 ---
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageString = "data:image/jpeg;base64,${base64Encode(bytes)}";
        });
      }
    } catch (e) {
      print('=== LỖI CHỌN ẢNH ===: $e');
    }
  }

  // --- HÀM GỬI LỆNH UPDATE LÊN API ---
  Future<void> _handleUpdateProduct() async {
    if (_nameCtrl.text.trim().isEmpty || _priceCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Tên và Giá sản phẩm!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true); 

    // Gom dữ liệu thành Map (Key phải khớp chuẩn với DTO Update C#)
    Map<String, dynamic> updateData = {
      "ProductId": _productId, // QUAN TRỌNG: Truyền ID để C# biết sửa món nào
      "Name": _nameCtrl.text.trim(),
      "Price": double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      "Category": _nameCategory.text.trim(),
      "IsAvailable": _selectActive == "Active",
      "Description": _descCtrl.text.trim(),
      "AvatarProducts": _imageString ?? "", // Gửi lại ảnh cũ hoặc ảnh base64 mới
    };

    // Gọi API (Giả sử userId = 2 đang sửa món)
    bool isSuccess = await _productService.updateProduct(2, updateData);

    setState(() => _isLoading = false); 

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công!'), backgroundColor: Colors.green),
      );
      // Trả về true để màn hình List biết đường gọi API load lại data
      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi: Không thể cập nhật sản phẩm'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _nameCategory.dispose();
    super.dispose();
  }

  // HÀM HỖ TRỢ HIỂN THỊ ẢNH (Vì ảnh có thể là Link HTTP hoặc Base64)
  Widget _buildImageDisplay() {
    if (_imageString == null || _imageString!.isEmpty) {
      return Container();
    }
    
    if (_imageString!.startsWith('http')) {
      return Image.network(_imageString!, width: double.infinity, height: 200, fit: BoxFit.cover);
    } else if (_imageString!.startsWith('data:image')) {
      return Image.memory(
        base64Decode(_imageString!.split(',').last), 
        width: double.infinity, height: 200, fit: BoxFit.cover
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Update Product", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PHẦN CHỌN ẢNH VÀ HIỂN THỊ ---
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: CustomPaint(
                  painter: DashedBorderPainter(),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Stack(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(20)),
                        
                        // Hiển thị ảnh
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _buildImageDisplay(),
                        ),

                        // Lớp phủ tối mờ
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(_imageString != null ? 0.3 : 0.05),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.add_a_photo, color: Color(0xFF6C63FF), size: 28),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _imageString != null ? "Change Product Image" : "Upload Product Image",
                                  style: TextStyle(
                                    color: _imageString != null ? Colors.white : Colors.black54, 
                                    fontWeight: FontWeight.bold, fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- CÁC TRƯỜNG NHẬP LIỆU ---
            _buildInputField("Product Name", "e.g. Truffle Mushroom Burger", controller: _nameCtrl),
            _buildInputField("Category", "e.g. Cơm", controller: _nameCategory),
            _buildDropdownField("Status"), 
            _buildInputField("Price", "\$ 0.00", isNumber: true, controller: _priceCtrl),
            _buildInputField("Description", "Describe the ingredients...", isMultiline: true, controller: _descCtrl),

            const SizedBox(height: 30),

            // --- HÀNG NÚT BẤM ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleUpdateProduct, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isLoading 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Update Product", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- CÁC WIDGET HỖ TRỢ ---
  Widget _buildInputField(String label, String hint, {bool isMultiline = false, bool isNumber = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF37474F))),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: TextField(
              controller: controller, 
              maxLines: isMultiline ? 4 : 1,
              keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF37474F))),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectActive,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blueGrey),
                items: _statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectActive = newValue!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 4;
    const double radius = 20.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(radius)));

    for (var i in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < i.length) {
        canvas.drawPath(i.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}