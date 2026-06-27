import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/servers/servers_page.dart';
import '../presentation/pages/security/security_page.dart';
import '../presentation/pages/moderation/moderation_page.dart';
import '../presentation/pages/logs/logs_page.dart';
import '../presentation/pages/tickets/tickets_page.dart';
import '../presentation/pages/economy/economy_page.dart';
import '../presentation/pages/music/music_page.dart';
import '../presentation/pages/analytics/analytics_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/more/more_page.dart';
import '../presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (ctx, state) {
      final isAuthenticated = auth.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      if (!isAuthenticated && !isLoggingIn) return '/login';
      if (isAuthenticated && isLoggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
      GoRoute(path: '/servers', builder: (_, __) => const ServersPage()),
      GoRoute(path: '/security', builder: (_, __) => const SecurityPage()),
      GoRoute(path: '/moderation', builder: (_, __) => const ModerationPage()),
      GoRoute(path: '/logs', builder: (_, __) => const LogsPage()),
      GoRoute(path: '/tickets', builder: (_, __) => const TicketsPage()),
      GoRoute(path: '/economy', builder: (_, __) => const EconomyPage()),
      GoRoute(path: '/music', builder: (_, __) => const MusicPage()),
      GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsPage()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
      GoRoute(path: '/more', builder: (_, __) => const MorePage()),
      GoRoute(path: '/giveaways', builder: (_, __) => const _PlaceholderPage(title: 'Giveaways')),
      GoRoute(path: '/welcome', builder: (_, __) => const _PlaceholderPage(title: 'Welcome System')),
      GoRoute(path: '/reaction-roles', builder: (_, __) => const _PlaceholderPage(title: 'Reaction Roles')),
      GoRoute(path: '/polls', builder: (_, __) => const _PlaceholderPage(title: 'Polls')),
      GoRoute(path: '/leveling', builder: (_, __) => const _PlaceholderPage(title: 'Leveling')),
      GoRoute(path: '/ai', builder: (_, __) => const _PlaceholderPage(title: 'AI Features')),
      GoRoute(path: '/notifications', builder: (_, __) => const _PlaceholderPage(title: 'Notifications')),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Color(0xFFED4245)),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}', style: const TextStyle(fontFamily: 'Poppins')),
          ],
        ),
      ),
    ),
  );
});

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_rounded, size: 72, color: Color(0xFF5865F2)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
            const SizedBox(height: 8),
            const Text('Coming soon...', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
