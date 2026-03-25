import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shop_profile_dto.dart';
import '../models/shop_dashboard_dto.dart';

class ShopOwnerService {
  // Dùng cùng base URL với product_manage_service.dart
  static const String _baseUrl = 'https://localhost:7008/api/ShopOwner';

  // ================== GET DASHBOARD ==================
  Future<ShopDashboardDto> fetchDashboard(int userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/$userId/dashboard');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ShopDashboardDto.fromJson(data);
      } else {
        throw Exception('Lỗi load dashboard. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('=== API LỖI fetchDashboard ===: $e');
      rethrow;
    }
  }

  // ================== GET PROFILE ==================
  Future<ShopProfileDto> fetchProfile(int userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/$userId/profile');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ShopProfileDto.fromJson(data);
      } else {
        throw Exception('Lỗi load profile. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('=== API LỖI fetchProfile ===: $e');
      rethrow;
    }
  }

  // ================== UPDATE PROFILE ==================
  Future<bool> updateProfile(int userId, Map<String, dynamic> profileData) async {
    try {
      final uri = Uri.parse('$_baseUrl/$userId/profile');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Lỗi Server Update Profile: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('=== LỖI MẠNG KHI CẬP NHẬT PROFILE ===: $e');
      return false;
    }
  }
}
