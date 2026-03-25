import 'dart:convert';

Map<String, dynamic>? tryDecodeJsonObject(String body) {
  try {
    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
  } catch (_) {
    // Ignore parse errors and let the caller handle non-JSON responses.
  }
  return null;
}
