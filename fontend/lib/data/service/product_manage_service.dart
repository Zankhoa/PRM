import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_manage_dto.dart';

class ProductManageService {
  // Thay đổi port cho đúng với server đang chạy
  static const String _baseUrl = 'https://localhost:7008/api/users';

  Future<List<ProductManageDto>> fetchProducts(int userId, int page, int pageSize) async {
    try {
      // Gọi đúng Endpoint GET API Products của Backend
      final uri = Uri.parse('$_baseUrl/$userId/products?page=$page&pageSize=$pageSize');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductManageDto.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi load sản phẩm. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('=== API LỖI ===: $e');
      return []; // Trả về list rỗng nếu sập mạng để không crash app
    }
  }
}