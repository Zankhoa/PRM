import 'dart:convert'; // Dùng để ép kiểu sang Base64
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Thư viện chọn ảnh
import 'package:shop_owner_screen/data/service/product_manage_service.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  // 1. Khai báo các Controller để lấy dữ liệu từ Text Field
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _nameCategory = TextEditingController();
  
  // 2. Biến lưu giá trị Dropdown và trạng thái Loading
  String _selectActive = "Active"; 
  final List<String> _statusOptions = ["Active", "Inactive"]; 
  
  // 3. Biến xử lý ảnh
  String? _base64ImageString; 
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  final ProductManageService _productService = ProductManageService();

  // --- HÀM CHỌN ẢNH VÀ CHUYỂN THÀNH CHUỖI VĂN BẢN (BASE64) ---
  Future<void> _pickImage() async {
    try {
      // Mở thư viện ảnh trên máy
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        // Đọc dữ liệu ảnh và ép thành chuỗi Base64
        final bytes = await pickedFile.readAsBytes();
        
        setState(() {
          // Gắn tiền tố để Flutter hiển thị lại được, và C# cũng dễ lưu
          _base64ImageString = "data:image/jpeg;base64,${base64Encode(bytes)}";
        });
      }
    } catch (e) {
      print('=== LỖI CHỌN ẢNH ===: $e');
    }
  }

  // --- HÀM GỬI DATA LÊN API ---
  Future<void> _handleSaveProduct() async {
    // Validate cơ bản
    if (_nameCtrl.text.trim().isEmpty || _priceCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Tên và Giá sản phẩm!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_base64ImageString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ảnh cho sản phẩm!'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true); 

    // Gom dữ liệu thành Map (Key phải khớp chuẩn với DTO C#)
    Map<String, dynamic> newProductData = {
      "UserId": 2, // Nếu C# của bạn đang bắt thuộc tính UserId
      "Name": _nameCtrl.text.trim(),
      "Price": double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      "Category": _nameCategory.text.trim(),
      "AvatarProducts": _base64ImageString, // Nhét chuỗi ảnh khổng lồ vào đây
      "IsAvailable": _selectActive == "Active",
      "Description": _descCtrl.text.trim(),
    };

    // Gọi API (Giả sử userId = 2 đang tạo món)
    bool isSuccess = await _productService.createProduct(2, newProductData);

    setState(() => _isLoading = false); 

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm sản phẩm thành công!'), backgroundColor: Colors.green),
      );
      // Trả về true để màn hình danh sách gọi lại API kéo list mới
      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi: Không thể lưu sản phẩm'), backgroundColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("New Product", 
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
            // --- PHẦN CHỌN ẢNH VÀ HIỂN THỊ ẢNH BASE64 ---
            GestureDetector(
              onTap: _pickImage, // Bấm vào vùng đứt nét để gọi hàm chọn ảnh
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
                        
                        // Hiển thị ảnh Base64 nếu người dùng đã chọn
                        if (_base64ImageString != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(
                              base64Decode(_base64ImageString!.split(',').last), 
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),

                        // Lớp phủ tối mờ và Icon máy ảnh
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              // Nếu có ảnh rồi thì lớp phủ tối đi 1 chút để nổi bật chữ Change Image
                              color: Colors.black.withOpacity(_base64ImageString != null ? 0.3 : 0.05),
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
                                  _base64ImageString != null ? "Change Product Image" : "Upload Product Image",
                                  style: TextStyle(
                                    color: _base64ImageString != null ? Colors.white : Colors.black54, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 14
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
                    onPressed: _isLoading ? null : _handleSaveProduct, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isLoading 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Save Product", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- CÁC WIDGET HỖ TRỢ GIỮ NGUYÊN ---
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