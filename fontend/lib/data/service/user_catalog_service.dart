import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/user_product_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class UserCatalogService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<List<String>> fetchCategories() async {
    final url = Uri.parse('$_root/api/products/categories');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải danh mục'));
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<List<UserProductDto>> fetchProducts({String? category, String? search}) async {
    final q = <String, String>{};
    if (category != null && category.isNotEmpty) q['category'] = category;
    if (search != null && search.isNotEmpty) q['search'] = search;
    final url = Uri.parse('$_root/api/products').replace(queryParameters: q.isEmpty ? null : q);

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải món'));
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data.map((e) => UserProductDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<UserProductDto?> fetchProductById(int id) async {
    final url = Uri.parse('$_root/api/products/$id');
    final response = await http.get(url);
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải chi tiết món'));
    }
    return UserProductDto.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
