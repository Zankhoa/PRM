import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/models/verify_order_dto.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/VerifyOrder.dart';

class VerifyOrderService {
  static const String _baseUrl = 'https://localhost:7008/api/shop/orders';

  // LẤY DANH SÁCH PENDING
  Future<List<OrderItem>> fetchPendingOrders() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pending'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => OrderItem.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Lỗi lấy danh sách đơn: $e");
      return [];
    }
  }
// 1. HÀM MỚI: Gọi API GetAll của C#
  Future<List<OrderItem>> fetchAllOrders() async {
    try {
      // Gọi thẳng vào route gốc: api/shop/orders
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => OrderItem.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Lỗi lấy danh sách TẤT CẢ đơn: $e");
      return [];
    }
  }
  // XÁC NHẬN / HỦY ĐƠN HÀNG (Gọi chung 1 API, chỉ khác biến newStatus)
  Future<bool> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$orderId/status'),
        headers: {'Content-Type': 'application/json'},
        // Truyền cục JSON khớp với ShopUpdateOrderStatusRequest của C#
        body: json.encode({
          "status": newStatus 
        }), 
      );
      
      // Nếu C# trả về Ok(dto) thì statusCode là 200
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi cập nhật trạng thái: $e");
      return false;
    }
  }
}