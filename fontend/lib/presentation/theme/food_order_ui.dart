import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Giao diện app khách: nền lavender, chữ tím đậm (như mockup).
class FoodOrderUi {
  FoodOrderUi._();

  static const double radiusMd = 14;
  static const double radiusLg = 16;

  /// Nền màn hình
  static const Color scaffoldBg = Color(0xFFF3F0F7);

  /// Tiêu đề / nhấn mạnh
  static const Color textPrimary = Color(0xFF4A3F6F);

  /// Cam badge / highlight
  static const Color accentOrange = Color(0xFFFFB84D);

  /// Chip / nav indicator
  static const Color chipSelectedBg = Color(0xFFE8E0F5);

  static String formatVnd(num n) {
    final s = NumberFormat('#,###', 'vi_VN').format(n.round());
    return '$s đ';
  }

  static ThemeData themeData() {
    const seed = Color(0xFF6C63FF);
    final cs = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ).copyWith(
      primary: seed,
      onPrimary: Colors.white,
      primaryContainer: chipSelectedBg,
      onPrimaryContainer: textPrimary,
      surface: Colors.white,
      onSurface: textPrimary,
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: chipSelectedBg,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          final sel = s.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
            color: sel ? textPrimary : textPrimary.withOpacity(0.55),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          final sel = s.contains(WidgetState.selected);
          return IconThemeData(
            color: sel ? textPrimary : textPrimary.withOpacity(0.45),
            size: 26,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: chipSelectedBg,
        disabledColor: Colors.grey.shade200,
        labelStyle: const TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: textPrimary.withOpacity(0.12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: textPrimary.withOpacity(0.45)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: textPrimary.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: textPrimary.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: seed, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
