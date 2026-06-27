import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/member_model.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/section_header.dart';

class ModerationPage extends ConsumerStatefulWidget {
  const ModerationPage({super.key});

  @override
  ConsumerState<ModerationPage> createState() => _ModerationPageState();
}

class _ModerationPageState extends ConsumerState<ModerationPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  MemberModel? _selectedMember;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MemberModel> get _filteredMembers {
    if (_searchQuery.isEmpty) return MemberModel.mockList;
    return MemberModel.mockList
        .where((m) =>
            m.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m.id.contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                backgroundColor: isDark
                    ? const Color(0xFF1A1D2E)
                    : AppColors.lightBackground,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFED4245), Color(0xFF9B59B6)],
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
                              child: const Icon(Icons.gavel_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Moderation',
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
                  'Moderation',
                  style:
                      TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                ),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _quickActions.map((action) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _QuickActionChip(action: action),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // User Search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Member',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search by username or user ID...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Member List
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Members'),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final member = _filteredMembers[i];
                    return _MemberTile(
                      member: member,
                      isSelected: _selectedMember?.id == member.id,
                      onTap: () => setState(() => _selectedMember = member),
                      onAction: (action) =>
                          _handleModAction(ctx, member, action),
                    ).animate(delay: Duration(milliseconds: i * 50)).fadeIn();
                  },
                  childCount: _filteredMembers.length,
                ),
              ),

              // Recent Actions
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Recent Mod Actions'),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _RecentActionTile(action: _recentActions[i]),
                  childCount: _recentActions.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNav(currentIndex: 3),
          ),
        ],
      ),
    );
  }

  void _handleModAction(
      BuildContext context, MemberModel member, String action) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ModActionSheet(member: member, action: action),
    );
  }

  static const List<_QuickAction> _quickActions = [
    _QuickAction(
      icon: Icons.gavel_rounded,
      label: 'Ban',
      color: Color(0xFFED4245),
    ),
    _QuickAction(
      icon: Icons.person_remove_rounded,
      label: 'Kick',
      color: Color(0xFFFF7043),
    ),
    _QuickAction(
      icon: Icons.timer_off_rounded,
      label: 'Timeout',
      color: Color(0xFFFEE75C),
    ),
    _QuickAction(
      icon: Icons.warning_rounded,
      label: 'Warn',
      color: Color(0xFFEB459E),
    ),
    _QuickAction(
      icon: Icons.volume_off_rounded,
      label: 'Mute',
      color: Color(0xFF9B59B6),
    ),
    _QuickAction(
      icon: Icons.cleaning_services_rounded,
      label: 'Purge',
      color: Color(0xFF5865F2),
    ),
  ];

  static final List<Map<String, dynamic>> _recentActions = [
    {
      'action': 'Ban',
      'target': 'TroubleUser99',
      'by': 'Moderator_Sam',
      'reason': 'Repeated violations',
      'time': '5 min ago',
      'color': AppColors.discordRed,
      'icon': Icons.gavel_rounded,
    },
    {
      'action': 'Warn',
      'target': 'DiscordUser1',
      'by': 'AutoMod',
      'reason': 'Spamming in #general',
      'time': '23 min ago',
      'color': AppColors.discordYellow,
      'icon': Icons.warning_rounded,
    },
    {
      'action': 'Kick',
      'target': 'NoisyBot123',
      'by': 'Moderator_Sam',
      'reason': 'Bot spam',
      'time': '1 hr ago',
      'color': AppColors.discordRed,
      'icon': Icons.person_remove_rounded,
    },
    {
      'action': 'Timeout',
      'target': 'CoolGamer2024',
      'by': 'Helper_Jane',
      'reason': 'Arguing in off-topic',
      'time': '2 hr ago',
      'color': AppColors.discordFuchsia,
      'icon': Icons.timer_off_rounded,
    },
  ];
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _QuickActionChip extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionChip({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: action.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: action.color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(action.icon, color: action.color, size: 22),
            const SizedBox(height: 5),
            Text(
              action.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: action.color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final MemberModel member;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(String) onAction;

  const _MemberTile({
    required this.member,
    required this.isSelected,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(member.status);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.discordBlurple.withOpacity(0.08)
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.discordBlurple.withOpacity(0.4)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.discordBlurple.withOpacity(0.15),
                  child: Text(
                    member.username[0].toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: AppColors.discordBlurple,
                      fontSize: 18,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1A1D2E) : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.displayName,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (member.warnCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.discordYellow.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${member.warnCount}⚠',
                            style: const TextStyle(
                              color: AppColors.discordYellow,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      if (member.isMuted) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.volume_off_rounded,
                            color: AppColors.discordRed, size: 14),
                      ],
                    ],
                  ),
                  Text(
                    member.tag,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: isDark ? Colors.white45 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? Colors.white38 : Colors.black26,
                size: 20,
              ),
              onSelected: (action) => onAction(action),
              itemBuilder: (_) => [
                _popupItem('Ban', Icons.gavel_rounded, AppColors.discordRed),
                _popupItem('Kick', Icons.person_remove_rounded, AppColors.discordRed),
                _popupItem('Timeout', Icons.timer_off_rounded, AppColors.discordYellow),
                _popupItem('Warn', Icons.warning_rounded, AppColors.discordYellow),
                _popupItem('Mute', Icons.volume_off_rounded, AppColors.discordFuchsia),
                _popupItem('Note', Icons.note_add_outlined, AppColors.discordBlurple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _popupItem(String label, IconData icon, Color color) {
    return PopupMenuItem<String>(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return AppColors.discordGreen;
      case 'idle':
        return AppColors.discordYellow;
      case 'dnd':
        return AppColors.discordRed;
      default:
        return Colors.grey;
    }
  }
}

class _RecentActionTile extends StatelessWidget {
  final Map<String, dynamic> action;

  const _RecentActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = action['color'] as Color;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(action['icon'] as IconData, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: action['action'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      TextSpan(
                          text: ' → ${action['target']}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: ' by ${action['by']}',
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black45,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  action['reason'] as String,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          Text(
            action['time'] as String,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModActionSheet extends StatefulWidget {
  final MemberModel member;
  final String action;

  const _ModActionSheet({required this.member, required this.action});

  @override
  State<_ModActionSheet> createState() => _ModActionSheetState();
}

class _ModActionSheetState extends State<_ModActionSheet> {
  final _reasonController = TextEditingController();
  String _duration = '1h';
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1D2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.discordRed.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.action,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.discordRed,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.member.displayName,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Reason',
                hintText: 'Enter reason for this action...',
              ),
            ),
            if (widget.action == 'Timeout' || widget.action == 'Mute') ...[
              const SizedBox(height: 16),
              Text(
                'Duration',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['5m', '10m', '30m', '1h', '6h', '1d', '7d']
                    .map(
                      (d) => ChoiceChip(
                        label: Text(d),
                        selected: _duration == d,
                        onSelected: (_) => setState(() => _duration = d),
                        selectedColor: AppColors.discordBlurple,
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.discordRed),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            await Future.delayed(
                                const Duration(milliseconds: 1000));
                            if (context.mounted) Navigator.pop(context);
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Confirm ${widget.action}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
