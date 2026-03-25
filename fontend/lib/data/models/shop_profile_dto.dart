class ShopProfileDto {
  final int userId;
  final String username;
  final String fullName;
  final String? phone;
  final String? email;
  final String? address;
  final String? avatarUser;
  final DateTime? createdAt;

  ShopProfileDto({
    required this.userId,
    required this.username,
    required this.fullName,
    this.phone,
    this.email,
    this.address,
    this.avatarUser,
    this.createdAt,
  });

  factory ShopProfileDto.fromJson(Map<String, dynamic> json) {
    return ShopProfileDto(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      avatarUser: json['avatarUser'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
