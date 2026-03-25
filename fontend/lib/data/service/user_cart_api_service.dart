import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/user_cart_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class UserCartApiService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<CartSummaryDto> getCart(int userId) async {
    final url = Uri.parse('$_root/api/users/$userId/cart');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải giỏ hàng'));
    }
    return CartSummaryDto.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<CartSummaryDto> addOrUpdate(int userId, int productId, int quantity) async {
    final url = Uri.parse('$_root/api/users/$userId/cart');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'productId': productId, 'quantity': quantity}),
    );
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Cập nhật giỏ'));
    }
    return CartSummaryDto.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
