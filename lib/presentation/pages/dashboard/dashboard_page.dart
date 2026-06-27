import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/bot_stats_model.dart';
import '../../../data/models/log_model.dart';
import '../../providers/bot_stats_provider.dart';
import '../../providers/guild_provider.dart';
import '../../providers/websocket_provider.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/log_entry_widget.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(botStatsProvider);
    final selectedGuild = ref.watch(selectedGuildProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Gradient App Bar
              SliverAppBar(
                expandedHeight: 130,
                pinned: true,
                backgroundColor: isDark
                    ? const Color(0xFF1A1D2E)
                    : AppColors.lightBackground,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF5865F2), Color(0xFF7B68EE)],
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
                              child: const Icon(Icons.smart_toy_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Bot Dashboard',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    selectedGuild?.name ?? 'All Servers',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/settings'),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.settings_outlined,
                                    color: Colors.white, size: 20),
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
                  'Bot Dashboard',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                ),
              ),

              // Dashboard Content
              statsAsync.when(
                loading: () => const SliverToBoxAdapter(
                    child: _ShimmerDashboard()),
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const Icon(Icons.error_outline,
                            size: 56, color: AppColors.discordRed),
                        const SizedBox(height: 16),
                        Text('Failed to load stats',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            )),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              ref.read(botStatsProvider.notifier).refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (stats) => _DashboardContent(stats: stats),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Floating Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNav(currentIndex: 0),
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  final BotStatsModel stats;

  const _DashboardContent({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(realtimeLogsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverList(
      delegate: SliverChildListDelegate([
        // Status Row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              _StatusBadge(
                label: stats.botStatus,
                color: AppColors.discordGreen,
                icon: Icons.circle,
              ),
              const SizedBox(width: 8),
              _StatusBadge(
                label: 'Up ${stats.uptimeFormatted}',
                color: AppColors.discordBlurple,
                icon: Icons.timer_outlined,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => ref.read(botStatsProvider.notifier).refresh(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.discordBlurple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: AppColors.discordBlurple, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Refresh',
                        style: TextStyle(
                          color: AppColors.discordBlurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Primary Stats
        const SectionHeader(title: 'Overview', actionLabel: 'Details'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              _StatCard(
                title: 'Total Servers',
                value: stats.totalServers.toString(),
                icon: Icons.dns_rounded,
                gradient: const [Color(0xFF5865F2), Color(0xFF7B68EE)],
                delay: 0,
              ),
              _StatCard(
                title: 'Total Members',
                value: _compact(stats.totalMembers),
                icon: Icons.people_rounded,
                gradient: const [Color(0xFF57F287), Color(0xFF43B581)],
                delay: 100,
              ),
              _StatCard(
                title: 'Online Now',
                value: _compact(stats.onlineMembers),
                icon: Icons.wifi_rounded,
                gradient: const [Color(0xFF00B0F4), Color(0xFF0080B3)],
                delay: 200,
              ),
              _StatCard(
                title: 'Bot Ping',
                value: '${stats.ping}ms',
                icon: Icons.network_ping_rounded,
                gradient: const [Color(0xFFFEE75C), Color(0xFFFFAA00)],
                delay: 300,
              ),
            ],
          ),
        ),

        // System Health
        const SectionHeader(title: 'System Health'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              _StatCard(
                title: 'CPU Usage',
                value: '${(stats.cpuUsage * 100).toStringAsFixed(1)}%',
                icon: Icons.memory_rounded,
                gradient: const [Color(0xFFEB459E), Color(0xFF9B59B6)],
                delay: 0,
              ),
              _StatCard(
                title: 'RAM Usage',
                value: '${(stats.ramUsage * 100).toStringAsFixed(1)}%',
                icon: Icons.storage_rounded,
                gradient: const [Color(0xFF9B59B6), Color(0xFF6C3483)],
                delay: 100,
              ),
              _StatCard(
                title: 'Latency',
                value: '${stats.latency}ms',
                icon: Icons.speed_rounded,
                gradient: const [Color(0xFFFF7043), Color(0xFFE64A19)],
                delay: 200,
              ),
              _StatCard(
                title: 'Commands Today',
                value: _compact(stats.commandsToday),
                icon: Icons.terminal_rounded,
                gradient: const [Color(0xFF00BCD4), Color(0xFF0097A7)],
                delay: 300,
              ),
            ],
          ),
        ),

        // Moderation Stats Row
        const SectionHeader(title: 'Moderation Today'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
            children: [
              _MiniStatCard(
                title: 'Actions',
                value: stats.moderationToday.toString(),
                color: AppColors.discordRed,
                icon: Icons.gavel_rounded,
                delay: 0,
              ),
              _MiniStatCard(
                title: 'Warnings',
                value: stats.warningsToday.toString(),
                color: AppColors.discordYellow,
                icon: Icons.warning_rounded,
                delay: 80,
              ),
              _MiniStatCard(
                title: 'Tickets',
                value: stats.activeTickets.toString(),
                color: AppColors.discordBlurple,
                icon: Icons.confirmation_num_rounded,
                delay: 160,
              ),
            ],
          ),
        ),

        // Active Features
        const SectionHeader(title: 'Active Features'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
            children: [
              _MiniStatCard(
                title: 'Giveaways',
                value: stats.activeGiveaways.toString(),
                color: AppColors.discordFuchsia,
                icon: Icons.card_giftcard_rounded,
                delay: 0,
              ),
              _MiniStatCard(
                title: 'Music Queue',
                value: stats.musicQueueSize.toString(),
                color: AppColors.discordGreen,
                icon: Icons.music_note_rounded,
                delay: 80,
              ),
              _MiniStatCard(
                title: 'Verify Queue',
                value: stats.verificationQueue.toString(),
                color: const Color(0xFF00B0F4),
                icon: Icons.verified_user_rounded,
                delay: 160,
              ),
            ],
          ),
        ),

        // Health Scores
        const SectionHeader(title: 'Health Scores'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _CircularScore(
                  label: 'Server Health',
                  score: stats.serverHealthScore,
                  color: AppColors.discordGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CircularScore(
                  label: 'Security Score',
                  score: stats.securityScore,
                  color: AppColors.discordBlurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CircularScore(
                  label: 'Bot Score',
                  score: 0.95,
                  color: AppColors.discordYellow,
                ),
              ),
            ],
          ),
        ),

        // Activity Chart
        const SectionHeader(title: 'Activity — 7 Days'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _ActivityChart(stats: stats),
        ),

        // Top Commands
        const SectionHeader(title: 'Top Commands', actionLabel: 'All Commands'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _TopCommandsList(commands: stats.topCommands),
        ),

        // Recent Activity Feed
        const SectionHeader(title: 'Live Activity', actionLabel: 'View Logs'),
        ...logs.take(5).map((log) => LogEntryWidget(log: log)),

        const SizedBox(height: 8),
      ]),
    );
  }

  String _compact(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradient;
  final int delay;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, curve: Curves.easeOut);
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final int delay;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1D2E),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 400.ms)
        .scale(begin: 0.9, curve: Curves.easeOut);
  }
}

class _CircularScore extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _CircularScore({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score,
                  strokeWidth: 6,
                  backgroundColor: color.withOpacity(0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '${(score * 100).toInt()}%',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1D2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  final BotStatsModel stats;

  const _ActivityChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spots = stats.activityHistory.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.commands.toDouble());
    }).toList();

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.grey.withOpacity(0.12),
        ),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) => FlLine(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.08),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= stats.activityHistory.length) {
                    return const SizedBox.shrink();
                  }
                  final d = stats.activityHistory[idx].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${d.month}/${d.day}',
                      style: TextStyle(
                        fontSize: 9,
                        fontFamily: 'Poppins',
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.discordBlurple,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.discordBlurple.withOpacity(0.3),
                    AppColors.discordBlurple.withOpacity(0.0),
                  ],
                ),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCommandsList extends StatelessWidget {
  final List<CommandStat> commands;

  const _TopCommandsList({required this.commands});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const colors = [
      AppColors.discordBlurple,
      AppColors.discordGreen,
      AppColors.discordYellow,
      AppColors.discordRed,
      AppColors.discordFuchsia,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.grey.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: commands.asMap().entries.map((e) {
          final cmd = e.value;
          final color = colors[e.key % colors.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '#${e.key + 1}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '/${cmd.name}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            cmd.count.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: cmd.percentage,
                        backgroundColor: color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 9),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerDashboard extends StatelessWidget {
  const _ShimmerDashboard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: List.generate(8, (_) => const ShimmerStatCard()),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            5,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ShimmerListTile(),
            ),
          ),
        ],
      ),
    );
  }
}
