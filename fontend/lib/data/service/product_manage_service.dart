import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_manage_dto.dart';

class ProductManageService {
  // Thay đổi port cho đúng với server đang chạy
  static const String _baseUrl = 'https://localhost:7008/api/shop-owner';

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
  /// HÀM THÊM SẢN PHẨM MỚI (POST)
  Future<bool> createProduct(int userId, Map<String, dynamic> productData) async {
    try {
      final uri = Uri.parse('$_baseUrl/$userId/products');
      
      final response = await http.post(
        uri,
        // Bắt buộc phải có dòng headers này để .NET biết đây là chuỗi JSON
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(productData), // Chuyển Map (Dart) thành JSON String
      );

      if (response.statusCode == 200) {
        return true; // Thành công
      } else {
        print('Lỗi Server Create: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('=== LỖI MẠNG KHI TẠO SẢN PHẨM ===: $e');
      return false;
    }
  }

  /// HÀM CẬP NHẬT SẢN PHẨM (PUT)
  Future<bool> updateProduct(int userId, Map<String, dynamic> productData) async {
    try {
      final uri = Uri.parse('$_baseUrl/$userId/products');
      
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(productData),
      );

      if (response.statusCode == 200) {
        return true; // Thành công
      } else {
        print('Lỗi Server Update: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('=== LỖI MẠNG KHI CẬP NHẬT SẢN PHẨM ===: $e');
      return false;
    }
  }
}