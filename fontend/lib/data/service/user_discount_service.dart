import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/user_discount_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class UserDiscountService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<List<UserDiscountDto>> fetchActive() async {
    final url = Uri.parse('$_root/api/discounts');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải mã giảm giá'));
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data.map((e) => UserDiscountDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
