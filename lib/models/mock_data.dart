import 'models.dart';

class MockData {
  static ShopOwner shopOwner = ShopOwner(
    id: '1',
    name: 'Nguyễn Văn An',
    email: 'an.nguyen@coffee.vn',
    phone: '0912345678',
    shopName: 'Coffee House Premium',
    address: '123 Trần Hưng Đạo, Quận 1, TP.HCM',
    avatarUrl: 'https://ui-avatars.com/api/?name=Nguyen+Van+An&size=200&background=6C63FF&color=fff',
    joinedDate: DateTime(2023, 1, 15),
  );

  static List<Product> products = [
    Product(
      id: '1',
      name: 'Espresso',
      price: 35000,
      soldCount: 234,
      revenue: 8190000,
      category: 'Coffee',
      imageUrl: '☕',
    ),
    Product(
      id: '2',
      name: 'Cappuccino',
      price: 45000,
      soldCount: 189,
      revenue: 8505000,
      category: 'Coffee',
      imageUrl: '☕',
    ),
    Product(
      id: '3',
      name: 'Latte',
      price: 42000,
      soldCount: 156,
      revenue: 6552000,
      category: 'Coffee',
      imageUrl: '☕',
    ),
    Product(
      id: '4',
      name: 'Americano',
      price: 38000,
      soldCount: 198,
      revenue: 7524000,
      category: 'Coffee',
      imageUrl: '☕',
    ),
    Product(
      id: '5',
      name: 'Trà Sữa Trân Châu',
      price: 40000,
      soldCount: 267,
      revenue: 10680000,
      category: 'Milk Tea',
      imageUrl: '🧋',
    ),
    Product(
      id: '6',
      name: 'Trà Đào',
      price: 35000,
      soldCount: 145,
      revenue: 5075000,
      category: 'Tea',
      imageUrl: '🍑',
    ),
    Product(
      id: '7',
      name: 'Sinh Tố Bơ',
      price: 48000,
      soldCount: 98,
      revenue: 4704000,
      category: 'Smoothie',
      imageUrl: '🥑',
    ),
    Product(
      id: '8',
      name: 'Matcha Latte',
      price: 52000,
      soldCount: 112,
      revenue: 5824000,
      category: 'Tea',
      imageUrl: '🍵',
    ),
    Product(
      id: '9',
      name: 'Chocolate Nóng',
      price: 45000,
      soldCount: 87,
      revenue: 3915000,
      category: 'Hot Drink',
      imageUrl: '🍫',
    ),
    Product(
      id: '10',
      name: 'Nước Ép Cam',
      price: 38000,
      soldCount: 134,
      revenue: 5092000,
      category: 'Juice',
      imageUrl: '🍊',
    ),
  ];

  static List<Discount> discounts = [
    Discount(
      id: '1',
      code: 'WELCOME20',
      name: 'Giảm giá chào mừng',
      percentage: 20,
      quantity: 100,
      usedCount: 45,
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 3, 31),
      minOrderAmount: 50000,
      description: 'Giảm 20% cho khách hàng mới, đơn tối thiểu 50k',
    ),
    Discount(
      id: '2',
      code: 'FREESHIP',
      name: 'Miễn phí giao hàng',
      percentage: 15,
      quantity: 200,
      usedCount: 178,
      startDate: DateTime(2025, 1, 15),
      endDate: DateTime(2025, 2, 28),
      minOrderAmount: 100000,
      description: 'Giảm 15% phí ship cho đơn từ 100k',
    ),
    Discount(
      id: '3',
      code: 'FLASH30',
      name: 'Flash Sale Cuối Tuần',
      percentage: 30,
      quantity: 50,
      usedCount: 48,
      startDate: DateTime(2025, 2, 1),
      endDate: DateTime(2025, 2, 5),
      minOrderAmount: 80000,
      description: 'Sale sốc 30% cuối tuần, nhanh tay kẻo lỡ!',
    ),
    Discount(
      id: '4',
      code: 'TETHOLIDAY',
      name: 'Khuyến mãi Tết',
      percentage: 25,
      quantity: 300,
      usedCount: 89,
      startDate: DateTime(2025, 1, 20),
      endDate: DateTime(2025, 2, 15),
      minOrderAmount: 70000,
      description: 'Mừng Tết Nguyên Đán - Giảm 25%',
    ),
    Discount(
      id: '5',
      code: 'COMBO50',
      name: 'Combo tiết kiệm',
      percentage: 10,
      quantity: 150,
      usedCount: 134,
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 12, 31),
      minOrderAmount: 150000,
      description: 'Giảm 10% cho combo từ 150k trở lên',
    ),
  ];

  static double get totalRevenue {
    return products.fold(0, (sum, product) => sum + product.revenue);
  }

  static int get totalOrders {
    return products.fold(0, (sum, product) => sum + product.soldCount);
  }

  static Product get bestSellingProduct {
    return products.reduce((a, b) => a.soldCount > b.soldCount ? a : b);
  }
}