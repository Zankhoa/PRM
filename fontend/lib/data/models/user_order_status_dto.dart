class OrderLineItemDto {
  final int productId;
  final String productName;
  final String? avatarProducts;
  final int quantity;
  final double unitPrice;

  OrderLineItemDto({
    required this.productId,
    required this.productName,
    this.avatarProducts,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderLineItemDto.fromJson(Map<String, dynamic> json) {
    final pid = json['productId'] as int? ?? json['ProductId'] as int? ?? 0;
    final qty = json['quantity'] as int? ?? json['Quantity'] as int? ?? 0;
    final up = json['unitPrice'] ?? json['UnitPrice'];
    return OrderLineItemDto(
      productId: pid,
      productName: json['productName'] as String? ?? json['ProductName'] as String? ?? '',
      avatarProducts: _trimUrl(json['avatarProducts'] ?? json['AvatarProducts']),
      quantity: qty,
      unitPrice: up != null ? (up as num).toDouble() : 0,
    );
  }
}

String? _trimUrl(dynamic v) {
  if (v == null) return null;
  var s = v is String ? v : v.toString();
  s = s.trim().replaceAll(RegExp(r'[\uFEFF\u200B-\u200D]'), '');
  return s.isEmpty ? null : s;
}

class UserOrderStatusDto {
  final int orderId;
  final double? totalPrice;
  final String? status;
  final DateTime? createdAt;
  final String? deliveryAddress;
  final int itemCount;
  final List<OrderLineItemDto> items;

  UserOrderStatusDto({
    required this.orderId,
    this.totalPrice,
    this.status,
    this.createdAt,
    this.deliveryAddress,
    required this.itemCount,
    this.items = const [],
  });

  factory UserOrderStatusDto.fromJson(Map<String, dynamic> json) {
    final orderId = json['orderId'] as int? ?? json['OrderId'] as int?;
    if (orderId == null) throw FormatException('orderId missing');
    final tp = json['totalPrice'] ?? json['TotalPrice'];
    final ic = json['itemCount'] ?? json['ItemCount'];
    final rawItems = json['items'] ?? json['Items'];
    final list = <OrderLineItemDto>[];
    if (rawItems is List) {
      for (final e in rawItems) {
        if (e is Map<String, dynamic>) {
          list.add(OrderLineItemDto.fromJson(e));
        }
      }
    }
    return UserOrderStatusDto(
      orderId: orderId,
      totalPrice: tp != null ? (tp as num).toDouble() : null,
      status: json['status'] as String? ?? json['Status'] as String?,
      createdAt: (json['createdAt'] ?? json['CreatedAt']) != null
          ? DateTime.tryParse((json['createdAt'] ?? json['CreatedAt']).toString())
          : null,
      deliveryAddress: json['deliveryAddress'] as String? ?? json['DeliveryAddress'] as String?,
      itemCount: ic as int? ?? list.fold<int>(0, (a, b) => a + b.quantity),
      items: list,
    );
  }
}
