import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_owner_screen/data/api_config.dart';
import 'package:shop_owner_screen/data/models/blog_dto.dart';
import 'package:shop_owner_screen/data/service/api_http_helpers.dart';

class BlogService {
  String get _root => ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;

  Future<List<BlogDto>> fetchBlogs({int page = 1, int pageSize = 20}) async {
    final url = Uri.parse('$_root/api/blogs?page=$page&pageSize=$pageSize');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception(formatApiException(response, 'Tải blog'));
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((e) => BlogDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BlogDto> createBlog(CreateBlogRequest request) async {
    final url = Uri.parse('$_root/api/blogs');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception(formatApiException(response, 'Tạo blog'));
    }
    return BlogDto.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
