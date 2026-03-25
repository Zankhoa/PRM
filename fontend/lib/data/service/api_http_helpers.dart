import 'package:http/http.dart' as http;

String formatApiException(http.Response response, String action) {
  final b = response.body;
  if (b.length > 200) return '$action: ${response.statusCode}';
  return '$action: ${response.statusCode} — $b';
}
