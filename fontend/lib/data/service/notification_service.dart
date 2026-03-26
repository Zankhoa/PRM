import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/notification_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class NotificationService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<List<NotificationDto>> fetchNotifications(int userId) async {
    final url = Uri.parse('$_root/api/users/$userId/notifications');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải thông báo'));
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(int userId, int notificationId) async {
    final url = Uri.parse(
        '$_root/api/users/$userId/notifications/$notificationId/read');
    final response = await http.post(url);
    if (response.statusCode != 204) {
      throw Exception(formatApiException(response, 'Cập nhật thông báo'));
    }
  }
}
