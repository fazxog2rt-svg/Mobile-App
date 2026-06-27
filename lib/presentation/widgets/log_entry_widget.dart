import 'package:flutter/material.dart';
import '../../data/models/log_model.dart';
import '../../core/utils/extensions.dart';

class LogEntryWidget extends StatelessWidget {
  final LogModel log;
  final VoidCallback? onTap;

  const LogEntryWidget({super.key, required this.log, this.onTap});

  Color _getCategoryColor() {
    switch (log.category) {
      case LogCategory.moderation:
        return const Color(0xFFED4245);
      case LogCategory.messages:
        return const Color(0xFF5865F2);
      case LogCategory.voice:
        return const Color(0xFF9B59B6);
      case LogCategory.members:
        return const Color(0xFF57F287);
      case LogCategory.server:
        return const Color(0xFFFEE75C);
      case LogCategory.bot:
        return const Color(0xFF00B0F4);
      case LogCategory.commands:
        return const Color(0xFFEB459E);
      case LogCategory.security:
        return const Color(0xFFFF7043);
    }
  }

  IconData _getCategoryIcon() {
    switch (log.category) {
      case LogCategory.moderation:
        return Icons.shield_outlined;
      case LogCategory.messages:
        return Icons.chat_bubble_outline;
      case LogCategory.voice:
        return Icons.headset_outlined;
      case LogCategory.members:
        return Icons.person_outline;
      case LogCategory.server:
        return Icons.dns_outlined;
      case LogCategory.bot:
        return Icons.smart_toy_outlined;
      case LogCategory.commands:
        return Icons.terminal_outlined;
      case LogCategory.security:
        return Icons.security_outlined;
    }
  }

  Color _getSeverityColor() {
    switch (log.severity) {
      case LogSeverity.info:
        return const Color(0xFF00B0F4);
      case LogSeverity.warning:
        return const Color(0xFFFEE75C);
      case LogSeverity.error:
        return const Color(0xFFED4245);
      case LogSeverity.success:
        return const Color(0xFF57F287);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = _getCategoryColor();
    final severityColor = _getSeverityColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: categoryColor, width: 3),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getCategoryIcon(), color: categoryColor, size: 16),
            ),
            const SizedBox(width: 10),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          log.title,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: severityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    log.description,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _CategoryChip(
                        label: log.category.name.toUpperCase(),
                        color: categoryColor,
                      ),
                      const Spacer(),
                      Text(
                        log.timestamp.timeAgo,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;

  const _CategoryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
