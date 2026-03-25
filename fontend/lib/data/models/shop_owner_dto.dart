class ShopOwnerDTO {
  final int userId;
  final String name;
  final String email;

  ShopOwnerDTO({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory ShopOwnerDTO.fromJson(Map<String, dynamic> json) {
    return ShopOwnerDTO(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}