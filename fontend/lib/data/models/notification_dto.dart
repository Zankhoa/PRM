class NotificationDto {
  final int notificationId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationDto({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      notificationId:
          json['notificationId'] as int? ?? json['NotificationId'] as int? ?? 0,
      title: json['title'] as String? ?? json['Title'] as String? ?? '',
      message: json['message'] as String? ?? json['Message'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? json['IsRead'] as bool? ?? false,
      createdAt: _parseDate(json['createdAt'] ?? json['CreatedAt']),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
