import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/discount_dto.dart';

class DiscountService {
  static const String _baseUrl = 'https://localhost:7008/api/Discount';

  static Future<List<DiscountDTO>> getDiscounts(int userId) async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/shop/$userId'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data as List).map((e) => DiscountDTO.fromJson(e)).toList();
      } else {
        throw Exception('Lỗi tải danh sách. Status: ${res.statusCode}');
      }
    } catch (e) {
      print('=== API LỖI getDiscounts ===: $e');
      rethrow;
    }
  }

  static Future<DiscountDTO> getDetail(int id, int userId) async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/$id/shop/$userId'));
      if (res.statusCode == 200) {
        return DiscountDTO.fromJson(jsonDecode(res.body));
      } else {
        throw Exception('Lỗi tải chi tiết. Status: ${res.statusCode}');
      }
    } catch (e) {
      print('=== API LỖI getDetail ===: $e');
      rethrow;
    }
  }

  static Future<bool> create(int userId, Map data) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/shop/$userId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print('=== API LỖI create ===: $e');
      return false;
    }
  }

  static Future<bool> update(int id, int userId, Map data) async {
    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/$id/shop/$userId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('=== API LỖI update ===: $e');
      return false;
    }
  }

  static Future<bool> delete(int id, int userId) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/$id/shop/$userId'));
      return res.statusCode == 200;
    } catch (e) {
      print('=== API LỖI delete ===: $e');
      return false;
    }
  }
}