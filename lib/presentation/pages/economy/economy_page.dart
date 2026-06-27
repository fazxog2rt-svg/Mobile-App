import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class EconomyPage extends StatelessWidget {
  const EconomyPage({super.key});

  static const _leaderboard = [
    {'rank': 1, 'name': 'RichGamer', 'coins': 985432, 'level': 45},
    {'rank': 2, 'name': 'MoneyBoss', 'coins': 876210, 'level': 41},
    {'rank': 3, 'name': 'GoldKing', 'coins': 754890, 'level': 38},
    {'rank': 4, 'name': 'CoolGamer2024', 'coins': 623100, 'level': 35},
    {'rank': 5, 'name': 'VIPMember', 'coins': 512890, 'level': 32},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Economy'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFEE75C), Color(0xFFFFAA00)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Economy Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFEE75C), Color(0xFFFFAA00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFEE75C).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.monetization_on_rounded,
                          color: Colors.black54, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Total Economy',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '4,567,890',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'coins in circulation',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _EconStat(
                          label: 'Active Users', value: '2,341'),
                      const SizedBox(width: 20),
                      _EconStat(
                          label: 'Daily Transactions', value: '8,432'),
                      const SizedBox(width: 20),
                      _EconStat(
                          label: 'Avg Balance', value: '1,952'),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),

            const SizedBox(height: 20),

            // Quick Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _EconCard(
                  title: 'Daily Claim',
                  value: '1,243',
                  subtitle: 'claims today',
                  icon: Icons.calendar_today_rounded,
                  gradient: const [Color(0xFF5865F2), Color(0xFF7B68EE)],
                ),
                _EconCard(
                  title: 'Shop Sales',
                  value: '342',
                  subtitle: 'items sold',
                  icon: Icons.storefront_rounded,
                  gradient: const [Color(0xFF57F287), Color(0xFF43B581)],
                ),
                _EconCard(
                  title: 'Gambling',
                  value: '89,430',
                  subtitle: 'coins wagered',
                  icon: Icons.casino_rounded,
                  gradient: const [Color(0xFFEB459E), Color(0xFF9B59B6)],
                ),
                _EconCard(
                  title: 'Work Rewards',
                  value: '5,671',
                  subtitle: 'coins earned',
                  icon: Icons.work_rounded,
                  gradient: const [Color(0xFF00BCD4), Color(0xFF0097A7)],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Coin Distribution Chart
            _SectionTitle(title: 'Coin Distribution'),
            const SizedBox(height: 12),
            Container(
              height: 200,
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
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: AppColors.discordBlurple,
                      title: 'Top 10%',
                      radius: 70,
                      titleStyle: const TextStyle(
                          fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    PieChartSectionData(
                      value: 35,
                      color: AppColors.discordGreen,
                      title: 'Mid',
                      radius: 65,
                      titleStyle: const TextStyle(
                          fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: AppColors.discordYellow,
                      title: 'New',
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w700),
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 3,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Leaderboard
            _SectionTitle(title: 'Top Richest Members'),
            const SizedBox(height: 12),
            ..._leaderboard.asMap().entries.map((e) {
              final member = e.value;
              return _LeaderboardTile(
                rank: member['rank'] as int,
                name: member['name'] as String,
                coins: member['coins'] as int,
                level: member['level'] as int,
              ).animate(delay: Duration(milliseconds: e.key * 80)).fadeIn().slideX(begin: 0.15);
            }),

            const SizedBox(height: 24),

            // Activity Chart
            _SectionTitle(title: 'Daily Transactions'),
            const SizedBox(height: 12),
            Container(
              height: 160,
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
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 15000,
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          final idx = v.toInt();
                          if (idx < 0 || idx >= days.length)
                            return const SizedBox.shrink();
                          return Text(
                            days[idx],
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [8500, 12300, 9800, 14200, 11100, 7600, 6200]
                      .asMap()
                      .entries
                      .map((e) => BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.toDouble(),
                                color: AppColors.discordYellow,
                                width: 16,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _EconStat extends StatelessWidget {
  final String label;
  final String value;

  const _EconStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _EconCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _EconCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
            blurRadius: 10,
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
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
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final int coins;
  final int level;

  const _LeaderboardTile({
    required this.rank,
    required this.name,
    required this.coins,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTop3 = rank <= 3;
    final medalColors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFC0C0C0), // Silver
      const Color(0xFFCD7F32), // Bronze
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTop3
            ? medalColors[rank - 1].withOpacity(0.08)
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTop3
              ? medalColors[rank - 1].withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              isTop3 ? ['🥇', '🥈', '🥉'][rank - 1] : '#$rank',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: isTop3 ? 20 : 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.discordBlurple.withOpacity(0.15),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: AppColors.discordBlurple,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Level $level',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.discordBlurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.monetization_on_rounded,
                  color: AppColors.discordYellow, size: 16),
              const SizedBox(width: 4),
              Text(
                _formatCoins(coins),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.discordYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCoins(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}
