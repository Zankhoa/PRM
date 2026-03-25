import 'package:shop_owner_screen/data/models/user_discount_dto.dart';

/// Khớp mã với danh sách giảm giá đang hoạt động (client preview, server vẫn xác nhận lúc checkout).
class DiscountPreviewHelper {
  DiscountPreviewHelper._();

  /// Trả về % giảm nếu khớp, không thì null.
  static int? matchPercent(String raw, List<UserDiscountDto> active) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    for (final d in active) {
      if (d.discountCode.toLowerCase() == t.toLowerCase()) {
        final p = d.percentDiscount;
        if (p != null && p > 0) return p;
      }
    }
    return null;
  }

  static double discountAmount(double subtotal, int percent) {
    return (subtotal * percent / 100 * 100).round() / 100;
  }
}
