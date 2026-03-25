class ProductManageDto {
  final int productId;
  final String nameProduct;
  final String? avatarImage; // Có thể null nếu chưa có ảnh
  final double price;
  final bool isAvailable;
  final String category;
  final String description; // Ánh xạ với Status ở Backend

  ProductManageDto({
    required this.productId,
    required this.nameProduct,
    this.avatarImage,
    required this.price,
    required this.isAvailable,
    required this.category,
    required this.description,
  });

  factory ProductManageDto.fromJson(Map<String, dynamic> json) {
    return ProductManageDto(
      productId: json['productId'] ?? 0,
      nameProduct: json['nameProduct'] ?? 'Tên sản phẩm trống',
      avatarImage: json['avatarImage'],
      // Ép kiểu an toàn bằng as num?
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      // API của bạn trả về true/false cho trường Status
      isAvailable: json['status'] ?? true, 
      category: json['category'] ?? 'Chưa phân loại',
      description: json['description'] ?? 'Không có mô tả',
    );
  }
}