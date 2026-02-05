class Product {
  final String id;
  final String name;
  final double price;
  final int soldCount;
  final double revenue;
  final String category;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.soldCount,
    required this.revenue,
    required this.category,
    required this.imageUrl,
  });
}

class Discount {
  final String id;
  final String code;
  final String name;
  final int percentage;
  final int quantity;
  final int usedCount;
  final DateTime startDate;
  final DateTime endDate;
  final double minOrderAmount;
  final String description;

  Discount({
    required this.id,
    required this.code,
    required this.name,
    required this.percentage,
    required this.quantity,
    required this.usedCount,
    required this.startDate,
    required this.endDate,
    required this.minOrderAmount,
    required this.description,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && 
           now.isBefore(endDate) && 
           usedCount < quantity;
  }

  int get remainingQuantity => quantity - usedCount;
}

class ShopOwner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String shopName;
  final String address;
  final String avatarUrl;
  final DateTime joinedDate;

  ShopOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.shopName,
    required this.address,
    required this.avatarUrl,
    required this.joinedDate,
  });
}

/// Giỏ hàng: 1 sản phẩm + số lượng
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}

/// Trạng thái đơn hàng
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  delivering,
  delivered,
  cancelled,
}

/// Đơn hàng (cho user)
class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discountAmount;
  final String? discountCode;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? address;
  final String? note;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    this.discountAmount = 0,
    this.discountCode,
    required this.total,
    required this.status,
    required this.createdAt,
    this.address,
    this.note,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.preparing:
        return 'Đang chuẩn bị';
      case OrderStatus.delivering:
        return 'Đang giao';
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }
}