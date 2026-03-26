class PaymentStatusDto {
  final int paymentId;
  final String? status;
  final String? paymentMethod;
  final double amount;
  final DateTime? createdAt;

  const PaymentStatusDto({
    required this.paymentId,
    this.status,
    this.paymentMethod,
    required this.amount,
    this.createdAt,
  });

  factory PaymentStatusDto.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'] ?? json['Amount'];
    return PaymentStatusDto(
      paymentId: json['paymentId'] as int? ?? json['PaymentId'] as int? ?? 0,
      status: json['status'] as String? ?? json['Status'] as String?,
      paymentMethod:
          json['paymentMethod'] as String? ?? json['PaymentMethod'] as String?,
      amount: rawAmount != null ? (rawAmount as num).toDouble() : 0,
      createdAt: _parseDate(json['createdAt'] ?? json['CreatedAt']),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
