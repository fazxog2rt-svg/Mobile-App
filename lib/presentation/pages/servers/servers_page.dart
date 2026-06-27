import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/guild_model.dart';
import '../../providers/guild_provider.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/shimmer_loading.dart';

class ServersPage extends ConsumerWidget {
  const ServersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guildState = ref.watch(guildsProvider);
    final selectedGuild = ref.watch(selectedGuildProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                backgroundColor:
                    isDark ? const Color(0xFF1A1D2E) : AppColors.lightBackground,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF57F287), Color(0xFF43B581)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.dns_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Servers',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
                title: const Text(
                  'Servers',
                  style:
                      TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),

              // Summary bar
              SliverToBoxAdapter(
                child: guildState.when(
                  loading: () => const ShimmerListTile(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (guilds) {
                    final active = guilds.where((g) => g.botPresent).length;
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5865F2), Color(0xFF7B68EE)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          _SummaryStat(
                            label: 'Total',
                            value: guilds.length.toString(),
                            icon: Icons.dns_rounded,
                          ),
                          const SizedBox(width: 20),
                          _SummaryStat(
                            label: 'Bot Active',
                            value: active.toString(),
                            icon: Icons.check_circle_outline,
                          ),
                          const SizedBox(width: 20),
                          _SummaryStat(
                            label: 'Inactive',
                            value: (guilds.length - active).toString(),
                            icon: Icons.cancel_outlined,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Guild List
              guildState.when(
                loading: () => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ShimmerListTile()),
                    childCount: 5,
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: AppColors.discordRed),
                          const SizedBox(height: 12),
                          Text('Failed to load servers: $e'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => ref.refresh(guildsProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                data: (guilds) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final guild = guilds[i];
                      final isSelected = selectedGuild?.id == guild.id;
                      return _ServerListItem(
                        guild: guild,
                        isSelected: isSelected,
                        onTap: () {
                          ref
                              .read(selectedGuildIdProvider.notifier)
                              .state = guild.id;
                        },
                        onRemoveBot: () => _confirmRemoveBot(ctx, ref, guild),
                        index: i,
                      );
                    },
                    childCount: guilds.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // FAB - Invite Bot
          Positioned(
            right: 20,
            bottom: 90,
            child: FloatingActionButton.extended(
              onPressed: () => _showInviteDialog(context),
              backgroundColor: AppColors.discordBlurple,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Invite Bot',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNav(currentIndex: 1),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveBot(
      BuildContext context, WidgetRef ref, GuildModel guild) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Bot'),
        content: Text(
          'Remove the bot from "${guild.name}"? This will disable all bot features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.discordRed),
            onPressed: () {
              Navigator.pop(ctx);
              // ref.read(guildProvider.notifier).removeBot(guild.id);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A1D2E)
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.add_circle_outline,
                color: AppColors.discordBlurple, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Invite Bot to Server',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your bot to a new Discord server using the OAuth invite link.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(ctx),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open Invite Link'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ServerListItem extends StatelessWidget {
  final GuildModel guild;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRemoveBot;
  final int index;

  const _ServerListItem({
    required this.guild,
    required this.isSelected,
    required this.onTap,
    required this.onRemoveBot,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(guild.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.discordRed.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.remove_circle_outline, color: Colors.white, size: 26),
            SizedBox(height: 4),
            Text('Remove Bot',
                style: TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        onRemoveBot();
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.discordBlurple.withOpacity(0.1)
                : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.discordBlurple.withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Server Icon
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.discordBlurple.withOpacity(0.15),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: guild.iconUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Center(
                    child: Text(
                      guild.name.isNotEmpty
                          ? guild.name[0].toUpperCase()
                          : 'S',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.discordBlurple,
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
                              color:
                                  isDark ? Colors.white : Colors.black87,
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
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.people_outline,
                            size: 12,
                            color: AppColors.discordBlurple),
                        const SizedBox(width: 4),
                        Text(
                          _formatCount(guild.memberCount),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppColors.discordBlurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.discordGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatCount(guild.onlineCount)} online',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppColors.discordGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Status
              _BotStatusIndicator(isPresent: guild.botPresent),
            ],
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: index * 60))
          .fadeIn(duration: 400.ms)
          .slideX(begin: 0.1, curve: Curves.easeOut),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
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
            colors: [Color(0xFFFF73FA), Color(0xFF9B59B6)]),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'T$tier',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BotStatusIndicator extends StatelessWidget {
  final bool isPresent;
  const _BotStatusIndicator({required this.isPresent});

  @override
  Widget build(BuildContext context) {
    final color =
        isPresent ? AppColors.discordGreen : AppColors.discordRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        isPresent ? 'Active' : 'Inactive',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
