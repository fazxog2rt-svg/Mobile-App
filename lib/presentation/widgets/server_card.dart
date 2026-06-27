import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/guild_model.dart';

class ServerCard extends StatelessWidget {
  final GuildModel guild;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemoveBot;

  const ServerCard({
    super.key,
    required this.guild,
    this.isSelected = false,
    this.onTap,
    this.onRemoveBot,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? scheme.primary.withOpacity(0.12)
              : (isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? scheme.primary.withOpacity(0.5)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Server Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: scheme.primary.withOpacity(0.2),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: guild.iconUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Center(
                  child: Text(
                    guild.name.isNotEmpty ? guild.name[0].toUpperCase() : 'S',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Server Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          guild.name,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (guild.premiumTier > 0) ...[
                        const SizedBox(width: 6),
                        _PremiumBadge(tier: guild.premiumTier),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.people_outline,
                        label: _formatCount(guild.memberCount),
                        color: const Color(0xFF5865F2),
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.circle,
                        label: '${_formatCount(guild.onlineCount)} online',
                        color: const Color(0xFF57F287),
                        iconSize: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bot Status & Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _BotStatusDot(isPresent: guild.botPresent),
                if (onRemoveBot != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onRemoveBot,
                    child: Icon(
                      Icons.more_vert,
                      color: isDark ? Colors.white38 : Colors.black26,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _PremiumBadge extends StatelessWidget {
  final int tier;
  const _PremiumBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF73FA), Color(0xFF9B59B6)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Tier $tier',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double iconSize;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    this.iconSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: iconSize),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BotStatusDot extends StatelessWidget {
  final bool isPresent;
  const _BotStatusDot({required this.isPresent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (isPresent ? const Color(0xFF57F287) : const Color(0xFFED4245))
            .withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isPresent ? const Color(0xFF57F287) : const Color(0xFFED4245))
              .withOpacity(0.4),
        ),
      ),
      child: Text(
        isPresent ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isPresent ? const Color(0xFF57F287) : const Color(0xFFED4245),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
