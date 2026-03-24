import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/models/order_history_dto.dart';
// Nhớ import file DTO của bạn ở đây

class HistoryOrderService {
  // Thay đổi port cho đúng với server đang chạy của bạn
  static const String _baseUrl = 'https://localhost:7008/api/users';

  Future<List<OrderHistoryDto>> fetchOrderHistory(int userId, int page, int pageSize) async {
    try {
      // Bỏ cặp ngoặc tròn thừa ở Uri.parse
      final uri = Uri.parse('$_baseUrl/$userId/history?page=$page&pageSize=$pageSize');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => OrderHistoryDto.fromJson(json)).toList();
      } else {
        // In ra mã lỗi cụ thể để dễ bắt bệnh
        throw Exception('Failed to load order history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('=== API CÓ VẤN ĐỀ ===: $e');
      throw Exception('Error fetching order history');
    }
  }
}