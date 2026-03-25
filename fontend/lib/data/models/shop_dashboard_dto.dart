class ShopDashboardDto {
  final double totalRevenue;
  final int totalOrders;
  final int totalProducts;
  final int activeDiscounts;
  final List<ProductSalesDto> topProducts;

  ShopDashboardDto({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProducts,
    required this.activeDiscounts,
    required this.topProducts,
  });

  factory ShopDashboardDto.fromJson(Map<String, dynamic> json) {
    return ShopDashboardDto(
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalOrders: json['totalOrders'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      activeDiscounts: json['activeDiscounts'] ?? 0,
      topProducts: (json['topProducts'] as List<dynamic>?)
              ?.map((e) => ProductSalesDto.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProductSalesDto {
  final int productId;
  final String productName;
  final String? category;
  final double price;
  final int soldCount;
  final double revenue;

  ProductSalesDto({
    required this.productId,
    required this.productName,
    this.category,
    required this.price,
    required this.soldCount,
    required this.revenue,
  });

  factory ProductSalesDto.fromJson(Map<String, dynamic> json) {
    return ProductSalesDto(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      category: json['category'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      soldCount: json['soldCount'] ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
