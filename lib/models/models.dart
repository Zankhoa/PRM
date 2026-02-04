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