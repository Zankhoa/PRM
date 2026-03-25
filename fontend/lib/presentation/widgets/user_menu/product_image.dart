import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/api_config.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final String fallbackLetter;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double placeholderFontSize;
  final List<Color>? backgroundGradient;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.fallbackLetter,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.placeholderFontSize = 40,
    this.backgroundGradient,
  });

  static String? _normalizeUrl(String? raw) {
    if (raw == null) return null;
    var s = raw.trim();
    if (s.isEmpty) return null;

    final lower = s.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      // Flutter web đôi khi không tải được ảnh host ngoài trực tiếp.
      // Dùng backend proxy để lấy ảnh (tránh chặn bởi trình duyệt/CORS).
      if (kIsWeb) {
        final proxied = '${ApiConfig.baseUrl}/api/images/proxy?url=${Uri.encodeComponent(s)}';
        return proxied;
      }
      return s;
    }
    if (lower.startsWith('data:image/')) return s;

    // Nếu DB lưu đường dẫn tương đối (vd: "/uploads/a.jpg" hoặc "uploads/a.jpg"),
    // ghép thêm base URL backend để Image.network fetch đúng host.
    if (s.startsWith('/')) {
      return '${ApiConfig.baseUrl}$s';
    }
    return '${ApiConfig.baseUrl}/$s';
  }

  static bool isNetworkImage(String? raw) {
    if (raw == null) return false;
    final s = raw.trim().toLowerCase();
    return s.startsWith('http://') || s.startsWith('https://') || s.startsWith('data:image/');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final letter = fallbackLetter.isNotEmpty ? fallbackLetter[0].toUpperCase() : '?';
    final url = _normalizeUrl(imageUrl);

    final gradientColors = backgroundGradient ??
        [
          scheme.primaryContainer.withOpacity(0.28),
          scheme.surface,
          scheme.primaryContainer.withOpacity(0.12),
        ];

    Widget placeholder() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: TextStyle(
              fontSize: placeholderFontSize,
              fontWeight: FontWeight.w600,
              color: scheme.primary.withOpacity(0.85),
            ),
          ),
        );

    if (!isNetworkImage(url)) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: placeholder(),
      );
    }

    Widget framed(Widget child) {
      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius!, child: child);
      }
      return child;
    }

    Widget net = LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          alignment: Alignment.center,
          child: Image.network(
            url!,
            fit: fit,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            webHtmlElementStrategy: kIsWeb ? WebHtmlElementStrategy.prefer : WebHtmlElementStrategy.never,
            // Flutter web không cho phép tuỳ ý set header request (trình duyệt chặn),
            // nên chỉ set headers cho nền tảng không phải web.
            headers: kIsWeb
                ? const {}
                : const {
                    'User-Agent': 'Mozilla/5.0 (compatible; FoodOrderApp/1.0)',
                  },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: scheme.primary,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => placeholder(),
          ),
        );
      },
    );

    return framed(net);
  }
}
