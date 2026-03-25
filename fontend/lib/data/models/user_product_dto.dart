String? _trimUrl(dynamic v) {
  if (v == null) return null;
  var s = v is String ? v : v.toString();
  s = s.trim().replaceAll(RegExp(r'[\uFEFF\u200B-\u200D]'), '');
  return s.isEmpty ? null : s;
}

class UserProductDto {
  final int productId;
  final String name;
  final String? avatarProducts;
  final String? category;
  final double price;
  final String? description;
  final bool? isAvailable;
  final DateTime? createdAt;

  UserProductDto({
    required this.productId,
    required this.name,
    this.avatarProducts,
    this.category,
    required this.price,
    this.description,
    this.isAvailable,
    this.createdAt,
  });

  factory UserProductDto.fromJson(Map<String, dynamic> json) {
    final pid = json['productId'] as int? ?? json['ProductId'] as int?;
    if (pid == null) throw FormatException('productId');
    final price = json['price'] ?? json['Price'];
    return UserProductDto(
      productId: pid,
      name: json['name'] as String? ?? json['Name'] as String? ?? '',
      avatarProducts: _trimUrl(json['avatarProducts'] ?? json['AvatarProducts']),
      category: json['category'] as String? ?? json['Category'] as String?,
      price: price != null ? (price as num).toDouble() : 0,
      description: json['description'] as String? ?? json['Description'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? json['IsAvailable'] as bool?,
      createdAt: (json['createdAt'] ?? json['CreatedAt']) != null
          ? DateTime.tryParse((json['createdAt'] ?? json['CreatedAt']).toString())
          : null,
    );
  }
}
