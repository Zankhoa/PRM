import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/checkout_result_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class UserCheckoutService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<CheckoutResultDto> checkout({
    required int userId,
    required String deliveryAddress,
    String paymentMethod = 'COD',
    String? discountCode,
    double deliveryFee = 15000,
    bool useCartFromDatabase = true,
  }) async {
    final url = Uri.parse('$_root/api/checkout');
    final body = <String, dynamic>{
      'userId': userId,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'deliveryFee': deliveryFee,
      'useCartFromDatabase': useCartFromDatabase,
    };
    if (discountCode != null && discountCode.isNotEmpty) {
      body['discountCode'] = discountCode;
    }
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Thanh toán'));
    }
    return CheckoutResultDto.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
