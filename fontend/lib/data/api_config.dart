import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// `--dart-define=API_BASE_URL=http://...` ghi đè.
/// Android emulator: `http://10.0.2.2:PORT` — đổi PORT theo launchSettings / Kestrel.
class ApiConfig {
  ApiConfig._();

  static const String _fromEnv = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_fromEnv.isNotEmpty) return _fromEnv;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5089';
    }
    return 'http://localhost:5089';
  }
}
