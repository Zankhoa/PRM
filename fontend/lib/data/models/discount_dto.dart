class DiscountDTO {
  final int discountId;
  final String discountCode;
  final String startDate;
  final String endDate;
  final int percentDiscount;
  final bool isActive;

  DiscountDTO({
    required this.discountId,
    required this.discountCode,
    required this.startDate,
    required this.endDate,
    required this.percentDiscount,
    required this.isActive,
  });

  factory DiscountDTO.fromJson(Map<String, dynamic> json) {
    return DiscountDTO(
      discountId: json['discountId'] ?? 0,
      discountCode: json['discountCode'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      percentDiscount: json['percentDiscount'] ?? 0,
      isActive: (json['isActived'] ?? json['isActive'] ?? false) == true || (json['isActived'] ?? json['isActive'] ?? 0) == 1,
    );
  }
}