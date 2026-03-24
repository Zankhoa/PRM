class OrderHistoryDto {
  final int orderId;
  final String nameProducts;
  final double totalPrice;
  final String status;       // 1. CHUYỂN TỪ int SANG String
  final DateTime createdAt;
  final int quantity;

  OrderHistoryDto({
    required this.orderId,
    required this.nameProducts,
    required this.totalPrice,
    required this.status,    // Cập nhật kiểu
    required this.createdAt,
    required this.quantity,
  });

  factory OrderHistoryDto.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDto(
      orderId: json['orderId'] ?? 0,
      
      nameProducts: json['nameProducts'] ?? 'Sản phẩm không xác định',
      
      // 2. Dùng 'as num?' cực kỳ quan trọng: Đề phòng API trả về số chẵn (VD: 95000) 
      // Flutter sẽ hiểu nhầm là int và báo lỗi nếu chỉ dùng .toDouble() trực tiếp
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      
      // 3. Hứng giá trị String từ JSON (VD: "Pending", "Completed")
      status: json['status']?.toString() ?? 'Pending',
      
      // 4. Check null trước khi parse để chống crash app
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
          
      quantity: json['quantity'] ?? 0,
    );
  }
}