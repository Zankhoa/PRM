import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/account_manage_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class AdminAccountService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<List<AccountManageDto>> fetchAccounts(
      {int page = 1, int pageSize = 50}) async {
    final url =
        Uri.parse('$_root/api/admin/users?page=$page&pageSize=$pageSize');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải danh sách tài khoản'));
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((e) => AccountManageDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AccountManageDto> fetchAccount(int userId) async {
    final url = Uri.parse('$_root/api/admin/users/$userId');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải tài khoản'));
    }
    return AccountManageDto.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }

  Future<AccountManageDto> createAccount(CreateAccountRequest request) async {
    final url = Uri.parse('$_root/api/admin/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception(formatApiException(response, 'Tạo tài khoản'));
    }
    return AccountManageDto.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }

  Future<void> updateAccount(int userId, UpdateAccountRequest request) async {
    final url = Uri.parse('$_root/api/admin/users/$userId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception(formatApiException(response, 'Cập nhật tài khoản'));
    }
  }
}
