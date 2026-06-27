import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  String get capitalize => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');

  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  bool get isValidDiscordId => RegExp(r'^\d{17,19}$').hasMatch(this);
}

extension IntExtensions on int {
  String get formatCompact {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }

  String get formatWithCommas => NumberFormat('#,###').format(this);
}

extension DoubleExtensions on double {
  String get formatPercent => '${(this * 100).toStringAsFixed(1)}%';

  String toMB() => '${(this / 1024 / 1024).toStringAsFixed(1)} MB';
}

extension DateTimeExtensions on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(this);
  }

  String get formatted => DateFormat('MMM d, yyyy HH:mm').format(this);

  String get shortFormatted => DateFormat('MMM d').format(this);

  String get timeFormatted => DateFormat('HH:mm').format(this);
}

extension ColorExtension on Color {
  Color get lighter => Color.lerp(this, Colors.white, 0.2)!;
  Color get darker => Color.lerp(this, Colors.black, 0.2)!;

  String get hex =>
      '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;

  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError
          ? const Color(0xFFED4245)
          : const Color(0xFF57F287),
    ));
  }

  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute(builder: (_) => page),
      );

  void pop<T>([T? result]) => Navigator.of(this).pop(result);
}
