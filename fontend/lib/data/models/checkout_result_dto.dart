class CheckoutResultDto {
  final int orderId;
  final double totalPrice;
  final double discountAmount;
  final String? status;
  final int? paymentId;
  final String? paymentStatus;

  CheckoutResultDto({
    required this.orderId,
    required this.totalPrice,
    required this.discountAmount,
    this.status,
    this.paymentId,
    this.paymentStatus,
  });

  factory CheckoutResultDto.fromJson(Map<String, dynamic> json) {
    final tp = json['totalPrice'] ?? json['TotalPrice'];
    final da = json['discountAmount'] ?? json['DiscountAmount'];
    return CheckoutResultDto(
      orderId: json['orderId'] as int? ?? json['OrderId'] as int? ?? 0,
      totalPrice: tp != null ? (tp as num).toDouble() : 0,
      discountAmount: da != null ? (da as num).toDouble() : 0,
      status: json['status'] as String? ?? json['Status'] as String?,
      paymentId: json['paymentId'] as int? ?? json['PaymentId'] as int?,
      paymentStatus: json['paymentStatus'] as String? ?? json['PaymentStatus'] as String?,
    );
  }
}
