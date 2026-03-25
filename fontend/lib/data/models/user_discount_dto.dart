class UserDiscountDto {
  final int discountId;
  final String discountCode;
  final int? percentDiscount;

  UserDiscountDto({
    required this.discountId,
    required this.discountCode,
    this.percentDiscount,
  });

  factory UserDiscountDto.fromJson(Map<String, dynamic> json) {
    return UserDiscountDto(
      discountId: json['discountId'] as int? ?? json['DiscountId'] as int? ?? 0,
      discountCode: json['discountCode'] as String? ?? json['DiscountCode'] as String? ?? '',
      percentDiscount: json['percentDiscount'] as int? ?? json['PercentDiscount'] as int?,
    );
  }
}
