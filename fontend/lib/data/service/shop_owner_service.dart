import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config.dart';
import '../models/shop_owner_dto.dart';

class ShopOwnerService {
  /// ================== GET PROFILE ==================
  static Future<ShopOwnerDTO> getProfile() async {
    final url =
        '${AppConfig.baseUrl}/api/User/${AppConfig.userId}';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return ShopOwnerDTO.fromJson(data);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  /// ================== UPDATE PROFILE ==================
  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    final url =
        '${AppConfig.baseUrl}/api/User/${AppConfig.userId}';

    final res = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return res.statusCode == 200;
  }

  /// ================== DASHBOARD STATS (OPTIONAL) ==================
  /// Nếu sau này bạn có API thống kê thì dùng
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final url =
        '${AppConfig.baseUrl}/api/Dashboard/${AppConfig.userId}';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return {};
    }
  }
}