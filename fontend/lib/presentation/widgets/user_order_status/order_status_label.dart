class OrderStatusLabel {
  OrderStatusLabel._();

  static String vi(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'pending':
        return 'Chờ shop xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status ?? '—';
    }
  }
}
