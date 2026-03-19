class OrderHistoryDto {
  final int orderId;
  final String nameProducts;
  final double totalPrice;
  final int status;
  final DateTime createdAt;
  final int quantity;

  OrderHistoryDto({
    required this.orderId,
    required this.nameProducts,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.quantity,
  });

  factory OrderHistoryDto.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDto(
      orderId: json['orderId'] ?? 0,
      nameProducts: json['nameProducts'] ?? 'Sản phẩm không xác định',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      quantity: json['quantity'] ?? 0,
    );
  }
}