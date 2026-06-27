import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/bottom_nav.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  static const _items = [
    _MoreItem(Icons.assignment_outlined, 'Tickets', '/tickets',
        [Color(0xFF5865F2), Color(0xFF7B68EE)],
        'Manage support tickets'),
    _MoreItem(Icons.show_chart_outlined, 'Analytics', '/analytics',
        [Color(0xFF00B0F4), Color(0xFF0080B3)],
        'View detailed analytics'),
    _MoreItem(Icons.monetization_on_outlined, 'Economy', '/economy',
        [Color(0xFFFEE75C), Color(0xFFFFAA00)],
        'Manage server economy'),
    _MoreItem(Icons.list_alt_outlined, 'Logs', '/logs',
        [Color(0xFF57F287), Color(0xFF43B581)],
        'View activity logs'),
    _MoreItem(Icons.music_note_rounded, 'Music', '/music',
        [Color(0xFFEB459E), Color(0xFF9B59B6)],
        'Control music player'),
    _MoreItem(Icons.card_giftcard_rounded, 'Giveaways', '/giveaways',
        [Color(0xFFFF7043), Color(0xFFE64A19)],
        'Manage giveaways'),
    _MoreItem(Icons.waving_hand_outlined, 'Welcome System', '/welcome',
        [Color(0xFF00BCD4), Color(0xFF0097A7)],
        'Set up welcome messages'),
    _MoreItem(Icons.emoji_emotions_outlined, 'Reaction Roles', '/reaction-roles',
        [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
        'Configure reaction roles'),
    _MoreItem(Icons.poll_outlined, 'Polls', '/polls',
        [Color(0xFF3F51B5), Color(0xFF283593)],
        'Create and manage polls'),
    _MoreItem(Icons.trending_up_outlined, 'Leveling', '/leveling',
        [Color(0xFF4CAF50), Color(0xFF388E3C)],
        'XP and leveling system'),
    _MoreItem(Icons.auto_awesome_outlined, 'AI Features', '/ai',
        [Color(0xFF5865F2), Color(0xFFEB459E)],
        'AI-powered bot features'),
    _MoreItem(Icons.settings_outlined, 'Settings', '/settings',
        [Color(0xFF607D8B), Color(0xFF455A64)],
        'App and bot settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 100,
                backgroundColor: isDark
                    ? const Color(0xFF1A1D2E)
                    : AppColors.lightBackground,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF9B59B6), Color(0xFF6C3483)],
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
                              child: const Icon(Icons.grid_view_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'More Features',
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
                ),
                title: const Text('More',
                    style: TextStyle(
                        fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _MoreCard(
                      item: _items[i],
                    ).animate(delay: Duration(milliseconds: i * 60)).fadeIn(duration: 400.ms).scale(begin: const Offset(0.92, 0.92)),
                    childCount: _items.length,
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNav(currentIndex: 4),
          ),
        ],
      ),
    );
  }
}

class _MoreCard extends StatelessWidget {
  final _MoreItem item;

  const _MoreCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.go(item.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.withOpacity(0.12),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: item.gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: Colors.white, size: 20),
            ),
            const Spacer(),
            Text(
              item.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: isDark ? Colors.white45 : Colors.black38,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String label;
  final String route;
  final List<Color> gradient;
  final String subtitle;

  const _MoreItem(
      this.icon, this.label, this.route, this.gradient, this.subtitle);
}
