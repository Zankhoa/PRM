import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config.dart';
import '../models/discount_dto.dart';

class DiscountService {
  static Future<List<DiscountDTO>> getDiscounts() async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/Discount/shop/${AppConfig.userId}'),
    );

    final data = jsonDecode(res.body);

    return (data as List)
        .map((e) => DiscountDTO.fromJson(e))
        .toList();
  }

  static Future<DiscountDTO> getDetail(int id) async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/Discount/$id/shop/${AppConfig.userId}'),
    );

    final data = jsonDecode(res.body);
    return DiscountDTO.fromJson(data);
  }

  static Future<void> create(Map data) async {
    await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/Discount/shop/${AppConfig.userId}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  static Future<void> update(int id, Map data) async {
    await http.put(
      Uri.parse('${AppConfig.baseUrl}/api/Discount/$id/shop/${AppConfig.userId}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  static Future<void> delete(int id) async {
    await http.delete(
      Uri.parse('${AppConfig.baseUrl}/api/Discount/$id/shop/${AppConfig.userId}'),
    );
  }
}