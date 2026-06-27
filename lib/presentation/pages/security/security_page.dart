import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/section_header.dart';

// Security settings state
final securitySettingsProvider =
    StateProvider<Map<String, bool>>((ref) => {
          'antiRaidEnabled': true,
          'raidJoinLimit': true,
          'raidAccountAge': true,
          'raidAvatarCheck': true,
          'raidAutoKick': false,
          'raidAutoban': true,
          'antiNukeEnabled': true,
          'nukeMassChannel': true,
          'nukeMassRole': true,
          'nukeMassKick': true,
          'nukeMassBan': true,
          'nukeWebhook': true,
          'verifyEnabled': true,
          'verifyCaptcha': true,
          'verifyEmail': false,
          'verifyPhone': false,
          'verifyNewAccount': true,
          'automodBadWords': true,
          'automodSpam': true,
          'automodLinks': true,
          'automodInvites': true,
          'automodMassMention': true,
          'automodCaps': false,
          'automodZalgo': true,
          'automodPhishing': true,
        });

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({super.key});

  @override
  ConsumerState<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(securitySettingsProvider);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFED4245), Color(0xFFBF0000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.security_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Security',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.shield,
                                      color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'Protected',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white60,
                          indicator: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(text: '🛡️  Anti-Raid'),
                            Tab(text: '💣  Anti-Nuke'),
                            Tab(text: '✅  Verification'),
                            Tab(text: '🤖  Auto-Mod'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _AntiRaidTab(settings: settings, ref: ref),
                    _AntiNukeTab(settings: settings, ref: ref),
                    _VerificationTab(settings: settings, ref: ref),
                    _AutoModerationTab(settings: settings, ref: ref),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNav(currentIndex: 2),
          ),
        ],
      ),
    );
  }
}

class _AntiRaidTab extends StatelessWidget {
  final Map<String, bool> settings;
  final WidgetRef ref;

  const _AntiRaidTab({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          _SecurityCard(
            title: 'Anti-Raid Protection',
            description: 'Protect your server from mass join attacks',
            icon: Icons.security_rounded,
            iconColor: AppColors.discordRed,
            isEnabled: settings['antiRaidEnabled'] ?? false,
            onToggle: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'antiRaidEnabled': v}),
          ),
          const SectionHeader(title: 'Detection Settings'),
          _SettingTile(
            icon: Icons.group_add_rounded,
            title: 'Join Rate Limit',
            subtitle: 'Detect mass joins above threshold',
            value: settings['raidJoinLimit'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'raidJoinLimit': v}),
            badgeLabel: '10/min',
            badgeColor: AppColors.discordYellow,
          ),
          _SettingTile(
            icon: Icons.cake_outlined,
            title: 'Account Age Check',
            subtitle: 'Block accounts newer than threshold',
            value: settings['raidAccountAge'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'raidAccountAge': v}),
            badgeLabel: '< 7 days',
            badgeColor: AppColors.discordYellow,
          ),
          _SettingTile(
            icon: Icons.face_outlined,
            title: 'Avatar Verification',
            subtitle: 'Detect default-avatar accounts',
            value: settings['raidAvatarCheck'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'raidAvatarCheck': v}),
          ),
          const SectionHeader(title: 'Actions'),
          _SettingTile(
            icon: Icons.no_accounts_rounded,
            title: 'Auto-Kick Raiders',
            subtitle: 'Automatically kick suspected raiders',
            value: settings['raidAutoKick'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'raidAutoKick': v}),
            danger: true,
          ),
          _SettingTile(
            icon: Icons.block_rounded,
            title: 'Auto-Ban Raiders',
            subtitle: 'Permanently ban confirmed raiders',
            value: settings['raidAutoban'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'raidAutoban': v}),
            danger: true,
          ),
        ],
      ),
    );
  }
}

class _AntiNukeTab extends StatelessWidget {
  final Map<String, bool> settings;
  final WidgetRef ref;

  const _AntiNukeTab({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          _SecurityCard(
            title: 'Anti-Nuke System',
            description: 'Prevent mass destructive server actions',
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.discordYellow,
            isEnabled: settings['antiNukeEnabled'] ?? false,
            onToggle: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'antiNukeEnabled': v}),
          ),
          const SectionHeader(title: 'Detection'),
          _SettingTile(
            icon: Icons.forum_outlined,
            title: 'Mass Channel Deletion',
            subtitle: 'Detect and reverse channel mass delete',
            value: settings['nukeMassChannel'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'nukeMassChannel': v}),
          ),
          _SettingTile(
            icon: Icons.badge_outlined,
            title: 'Mass Role Deletion',
            subtitle: 'Detect and reverse role mass delete',
            value: settings['nukeMassRole'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'nukeMassRole': v}),
          ),
          _SettingTile(
            icon: Icons.person_remove_outlined,
            title: 'Mass Kick Detection',
            subtitle: 'Alert on mass member kicks',
            value: settings['nukeMassKick'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'nukeMassKick': v}),
            danger: true,
          ),
          _SettingTile(
            icon: Icons.gavel_rounded,
            title: 'Mass Ban Detection',
            subtitle: 'Alert on mass member bans',
            value: settings['nukeMassBan'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'nukeMassBan': v}),
            danger: true,
          ),
          _SettingTile(
            icon: Icons.webhook_outlined,
            title: 'Webhook Spam Protection',
            subtitle: 'Block malicious webhook creation',
            value: settings['nukeWebhook'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'nukeWebhook': v}),
          ),
        ],
      ),
    );
  }
}

class _VerificationTab extends StatelessWidget {
  final Map<String, bool> settings;
  final WidgetRef ref;

  const _VerificationTab({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          _SecurityCard(
            title: 'Member Verification',
            description: 'Require members to verify before accessing server',
            icon: Icons.verified_user_rounded,
            iconColor: AppColors.discordGreen,
            isEnabled: settings['verifyEnabled'] ?? false,
            onToggle: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'verifyEnabled': v}),
          ),
          const SectionHeader(title: 'Verification Methods'),
          _SettingTile(
            icon: Icons.psychology_outlined,
            title: 'CAPTCHA Verification',
            subtitle: 'Solve a visual CAPTCHA to join',
            value: settings['verifyCaptcha'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'verifyCaptcha': v}),
            badgeLabel: 'Recommended',
            badgeColor: AppColors.discordGreen,
          ),
          _SettingTile(
            icon: Icons.email_outlined,
            title: 'Email Verification',
            subtitle: 'Verify email address before joining',
            value: settings['verifyEmail'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'verifyEmail': v}),
          ),
          _SettingTile(
            icon: Icons.phone_outlined,
            title: 'Phone Verification',
            subtitle: 'Require verified phone number',
            value: settings['verifyPhone'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'verifyPhone': v}),
            badgeLabel: 'Strict',
            badgeColor: AppColors.discordRed,
          ),
          _SettingTile(
            icon: Icons.new_releases_outlined,
            title: 'New Account Filter',
            subtitle: 'Block accounts under 30 days old',
            value: settings['verifyNewAccount'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'verifyNewAccount': v}),
          ),
        ],
      ),
    );
  }
}

class _AutoModerationTab extends StatelessWidget {
  final Map<String, bool> settings;
  final WidgetRef ref;

  const _AutoModerationTab({required this.settings, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          const SectionHeader(title: 'Content Filters'),
          _SettingTile(
            icon: Icons.text_snippet_outlined,
            title: 'Bad Word Filter',
            subtitle: 'Remove messages with prohibited words',
            value: settings['automodBadWords'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodBadWords': v}),
          ),
          _SettingTile(
            icon: Icons.link_off_rounded,
            title: 'Link Filter',
            subtitle: 'Block unauthorized external links',
            value: settings['automodLinks'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodLinks': v}),
          ),
          _SettingTile(
            icon: Icons.group_remove_outlined,
            title: 'Discord Invites',
            subtitle: 'Remove other server invites',
            value: settings['automodInvites'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodInvites': v}),
          ),
          _SettingTile(
            icon: Icons.phishing_outlined,
            title: 'Phishing Protection',
            subtitle: 'Block known phishing domains',
            value: settings['automodPhishing'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodPhishing': v}),
            badgeLabel: 'Critical',
            badgeColor: AppColors.discordRed,
          ),
          const SectionHeader(title: 'Spam Protection'),
          _SettingTile(
            icon: Icons.message_outlined,
            title: 'Spam Detection',
            subtitle: 'Detect and remove spam messages',
            value: settings['automodSpam'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodSpam': v}),
          ),
          _SettingTile(
            icon: Icons.alternate_email_rounded,
            title: 'Mass Mention',
            subtitle: 'Limit the number of mentions per message',
            value: settings['automodMassMention'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodMassMention': v}),
            badgeLabel: 'Max: 5',
            badgeColor: AppColors.discordYellow,
          ),
          _SettingTile(
            icon: Icons.text_format_rounded,
            title: 'Zalgo Text',
            subtitle: 'Remove corrupted/zalgo text messages',
            value: settings['automodZalgo'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodZalgo': v}),
          ),
          _SettingTile(
            icon: Icons.keyboard_capslock_rounded,
            title: 'Excessive Caps',
            subtitle: 'Filter messages that are ALL CAPS',
            value: settings['automodCaps'] ?? false,
            onChanged: (v) => ref
                .read(securitySettingsProvider.notifier)
                .update((s) => {...s, 'automodCaps': v}),
            badgeLabel: '> 70%',
            badgeColor: AppColors.discordYellow,
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const _SecurityCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? [iconColor.withOpacity(0.2), iconColor.withOpacity(0.08)]
              : [
                  (isDark ? Colors.white : Colors.grey).withOpacity(0.06),
                  (isDark ? Colors.white : Colors.grey).withOpacity(0.03),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled
              ? iconColor.withOpacity(0.35)
              : Colors.grey.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isEnabled ? iconColor.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: isEnabled ? iconColor : Colors.grey, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: iconColor,
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? badgeLabel;
  final Color? badgeColor;
  final bool danger;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.badgeLabel,
    this.badgeColor,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = danger
        ? AppColors.discordRed
        : (value ? AppColors.discordBlurple : Colors.grey);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: danger && value
              ? AppColors.discordRed.withOpacity(0.2)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (badgeLabel != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (badgeColor ?? AppColors.discordBlurple)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeLabel!,
                          style: TextStyle(
                            color: badgeColor ?? AppColors.discordBlurple,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isDark ? Colors.white45 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: danger ? AppColors.discordRed : AppColors.discordBlurple,
          ),
        ],
      ),
    );
  }
}
