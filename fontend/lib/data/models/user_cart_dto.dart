String? _trimUrl(dynamic v) {
  if (v == null) return null;
  var s = v is String ? v : v.toString();
  s = s.trim().replaceAll(RegExp(r'[\uFEFF\u200B-\u200D]'), '');
  return s.isEmpty ? null : s;
}

class CartLineDto {
  final int cartItemId;
  final int productId;
  final String productName;
  final String? avatarProducts;
  final double unitPrice;
  final int quantity;
  final double lineTotal;

  CartLineDto({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    this.avatarProducts,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  factory CartLineDto.fromJson(Map<String, dynamic> json) {
    final up = json['unitPrice'] ?? json['UnitPrice'];
    final lt = json['lineTotal'] ?? json['LineTotal'];
    return CartLineDto(
      cartItemId: json['cartItemId'] as int? ?? json['CartItemId'] as int? ?? 0,
      productId: json['productId'] as int? ?? json['ProductId'] as int? ?? 0,
      productName: json['productName'] as String? ?? json['ProductName'] as String? ?? '',
      avatarProducts: _trimUrl(json['avatarProducts'] ?? json['AvatarProducts']),
      unitPrice: up != null ? (up as num).toDouble() : 0,
      quantity: json['quantity'] as int? ?? json['Quantity'] as int? ?? 0,
      lineTotal: lt != null ? (lt as num).toDouble() : 0,
    );
  }
}

class CartSummaryDto {
  final List<CartLineDto> items;
  final double subtotal;

  CartSummaryDto({required this.items, required this.subtotal});

  factory CartSummaryDto.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] ?? json['Items'];
    final list = <CartLineDto>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map<String, dynamic>) list.add(CartLineDto.fromJson(e));
      }
    }
    final st = json['subtotal'] ?? json['Subtotal'];
    return CartSummaryDto(
      items: list,
      subtotal: st != null ? (st as num).toDouble() : 0,
    );
  }
}
