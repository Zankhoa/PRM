import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/payment_status_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class PaymentStatusService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<PaymentStatusDto> fetchPaymentStatus({
    required int userId,
    required int orderId,
  }) async {
    final url = Uri.parse('$_root/api/users/$userId/payments/$orderId');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(
          formatApiException(response, 'Tải trạng thái thanh toán'));
    }
    return PaymentStatusDto.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }
}
