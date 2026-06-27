import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();

  // Discord Brand Colors
  static const Color discordBlurple = Color(0xFF5865F2);
  static const Color discordGreen = Color(0xFF57F287);
  static const Color discordYellow = Color(0xFFFEE75C);
  static const Color discordRed = Color(0xFFED4245);
  static const Color discordFuchsia = Color(0xFFEB459E);
  static const Color discordWhite = Color(0xFFFFFFFF);
  static const Color discordBlack = Color(0xFF23272A);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1D2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkCard = Color(0xFF0F3460);
  static const Color darkNavy = Color(0xFF0D1117);
  static const Color darkElevated = Color(0xFF252840);

  // AMOLED Colors
  static const Color amoledBackground = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF0A0A0F);
  static const Color amoledCard = Color(0xFF111118);
  static const Color amoledElevated = Color(0xFF1A1A25);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F7FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightElevated = Color(0xFFEEF0FF);

  // Semantic Colors
  static const Color success = Color(0xFF57F287);
  static const Color warning = Color(0xFFFEE75C);
  static const Color error = Color(0xFFED4245);
  static const Color info = Color(0xFF00B0F4);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF5865F2),
    Color(0xFF7B68EE),
  ];
  static const List<Color> successGradient = [
    Color(0xFF57F287),
    Color(0xFF43B581),
  ];
  static const List<Color> dangerGradient = [
    Color(0xFFED4245),
    Color(0xFFBF0000),
  ];
  static const List<Color> warningGradient = [
    Color(0xFFFEE75C),
    Color(0xFFFFAA00),
  ];
  static const List<Color> infoGradient = [
    Color(0xFF00B0F4),
    Color(0xFF0080B3),
  ];
  static const List<Color> purpleGradient = [
    Color(0xFF9B59B6),
    Color(0xFF6C3483),
  ];
  static const List<Color> darkGradient = [
    Color(0xFF1A1D2E),
    Color(0xFF16213E),
  ];

  // Glass Colors
  static const Color glassLight = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const Color glassBorder = Color(0x33FFFFFF);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        backgroundColor: AppColors.lightBackground,
        surfaceColor: AppColors.lightSurface,
        cardColor: AppColors.lightCard,
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        backgroundColor: AppColors.darkBackground,
        surfaceColor: AppColors.darkSurface,
        cardColor: AppColors.darkElevated,
      );

  static ThemeData get amoledTheme => _buildTheme(
        brightness: Brightness.dark,
        colorScheme: _amoledColorScheme,
        backgroundColor: AppColors.amoledBackground,
        surfaceColor: AppColors.amoledSurface,
        cardColor: AppColors.amoledCard,
      );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.discordBlurple,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDDE1FF),
    onPrimaryContainer: Color(0xFF001A6E),
    secondary: Color(0xFF57F287),
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFFCEFFE2),
    onSecondaryContainer: Color(0xFF00391A),
    tertiary: Color(0xFF00B0F4),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFCCEEFF),
    onTertiaryContainer: Color(0xFF001F30),
    error: AppColors.discordRed,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: AppColors.lightSurface,
    onSurface: Color(0xFF1A1D2E),
    surfaceContainerHighest: Color(0xFFE8EAFF),
    onSurfaceVariant: Color(0xFF44474F),
    outline: Color(0xFF747780),
    outlineVariant: Color(0xFFC4C6D0),
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: Color(0xFF2F3033),
    onInverseSurface: Color(0xFFF2F0F4),
    inversePrimary: Color(0xFFBEC2FF),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.discordBlurple,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF2D3180),
    onPrimaryContainer: Color(0xFFDDE1FF),
    secondary: Color(0xFF57F287),
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFF004D25),
    onSecondaryContainer: Color(0xFFCEFFE2),
    tertiary: Color(0xFF00B0F4),
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFF004D6E),
    onTertiaryContainer: Color(0xFFCCEEFF),
    error: AppColors.discordRed,
    onError: Colors.white,
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: AppColors.darkSurface,
    onSurface: Color(0xFFE3E2E6),
    surfaceContainerHighest: Color(0xFF44474F),
    onSurfaceVariant: Color(0xFFC4C6D0),
    outline: Color(0xFF8E9099),
    outlineVariant: Color(0xFF44474F),
    shadow: Colors.black,
    scrim: Colors.black87,
    inverseSurface: Color(0xFFE3E2E6),
    onInverseSurface: Color(0xFF2F3033),
    inversePrimary: AppColors.discordBlurple,
  );

  static const ColorScheme _amoledColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.discordBlurple,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF1A1D40),
    onPrimaryContainer: Color(0xFFDDE1FF),
    secondary: Color(0xFF57F287),
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFF002210),
    onSecondaryContainer: Color(0xFFCEFFE2),
    tertiary: Color(0xFF00B0F4),
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFF001F2D),
    onTertiaryContainer: Color(0xFFCCEEFF),
    error: AppColors.discordRed,
    onError: Colors.white,
    errorContainer: Color(0xFF6B0005),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: AppColors.amoledSurface,
    onSurface: Color(0xFFE3E2E6),
    surfaceContainerHighest: Color(0xFF2A2A35),
    onSurfaceVariant: Color(0xFFC4C6D0),
    outline: Color(0xFF6E7180),
    outlineVariant: Color(0xFF2A2D35),
    shadow: Colors.black,
    scrim: Colors.black87,
    inverseSurface: Color(0xFFE3E2E6),
    onInverseSurface: Color(0xFF2F3033),
    inversePrimary: AppColors.discordBlurple,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color cardColor,
  }) {
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF1A1D2E),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF1A1D2E),
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDark
              ? BorderSide(color: Colors.white.withOpacity(0.06), width: 1)
              : BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.discordBlurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.discordBlurple,
          side: const BorderSide(color: AppColors.discordBlurple, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.discordBlurple,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.discordBlurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.discordRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.discordRed, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: isDark ? Colors.white60 : Colors.black45,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          color: isDark ? Colors.white38 : Colors.black26,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.grey.withOpacity(0.12),
        selectedColor: AppColors.discordBlurple.withOpacity(0.2),
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.withOpacity(0.15),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return isDark ? Colors.white38 : Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.discordBlurple;
          }
          return isDark ? Colors.white12 : Colors.grey.shade300;
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.discordBlurple,
        unselectedLabelColor: isDark ? Colors.white54 : Colors.black45,
        indicatorColor: AppColors.discordBlurple,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkElevated : Colors.white,
        selectedItemColor: AppColors.discordBlurple,
        unselectedItemColor: isDark ? Colors.white38 : Colors.black38,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF252840) : const Color(0xFF1A1D2E),
        contentTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkElevated : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1A1D2E),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.discordBlurple,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.discordBlurple,
      ),
      textTheme: _buildTextTheme(isDark),
    );
  }

  static TextTheme _buildTextTheme(bool isDark) {
    final Color primaryText = isDark ? Colors.white : const Color(0xFF1A1D2E);
    final Color secondaryText = isDark ? Colors.white70 : Colors.black54;

    return TextTheme(
      displayLarge: TextStyle(fontFamily: 'Poppins', fontSize: 57, fontWeight: FontWeight.w700, color: primaryText),
      displayMedium: TextStyle(fontFamily: 'Poppins', fontSize: 45, fontWeight: FontWeight.w700, color: primaryText),
      displaySmall: TextStyle(fontFamily: 'Poppins', fontSize: 36, fontWeight: FontWeight.w600, color: primaryText),
      headlineLarge: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700, color: primaryText),
      headlineMedium: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w600, color: primaryText),
      headlineSmall: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.w600, color: primaryText),
      titleLarge: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: primaryText),
      titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: primaryText),
      titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
      bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w400, color: primaryText),
      bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w400, color: primaryText),
      bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w400, color: secondaryText),
      labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
      labelMedium: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: primaryText),
      labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: secondaryText),
    );
  }
}

// Extension for glassmorphism
extension GlassExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get glassColor => isDark
      ? Colors.white.withOpacity(0.05)
      : Colors.white.withOpacity(0.7);

  Color get glassBorderColor => isDark
      ? Colors.white.withOpacity(0.1)
      : Colors.white.withOpacity(0.8);
}
