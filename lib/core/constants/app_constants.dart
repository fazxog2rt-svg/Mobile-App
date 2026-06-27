class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Discord Bot Manager';
  static const String appVersion = '1.0.0';

  // Discord API
  static const String discordApiBaseUrl = 'https://discord.com/api/v10';
  static const String discordCdnBaseUrl = 'https://cdn.discordapp.com';
  static const String discordOAuthUrl = 'https://discord.com/oauth2/authorize';
  static const String discordTokenUrl = 'https://discord.com/api/oauth2/token';

  // Bot Dashboard API (your backend)
  static const String botApiBaseUrl = 'https://api.yourbotdashboard.com/v1';
  static const String wsBaseUrl = 'wss://ws.yourbotdashboard.com';

  // OAuth
  static const String discordClientId = 'YOUR_DISCORD_CLIENT_ID';
  static const String discordRedirectUri = 'discordbotmanager://auth';
  static const String discordScopes = 'identify guilds bot applications.commands';

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keySelectedGuildId = 'selected_guild_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyOnboardingComplete = 'onboarding_complete';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // WebSocket
  static const int wsReconnectDelay = 3000;
  static const int wsMaxRetries = 5;
  static const int wsPingInterval = 30000;

  // Animations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  static const Duration extraLongAnimation = Duration(milliseconds: 1000);

  // Discord Colors
  static const int discordBlurple = 0xFF5865F2;
  static const int discordGreen = 0xFF57F287;
  static const int discordYellow = 0xFFFEE75C;
  static const int discordRed = 0xFFED4245;
  static const int discordFuchsia = 0xFFEB459E;
  static const int discordWhite = 0xFFFFFFFF;
  static const int discordBlack = 0xFF23272A;
  static const int discordDark = 0xFF2C2F33;
  static const int discordDarker = 0xFF23272A;
  static const int discordDarkest = 0xFF1E2124;
  static const int discordNotQuiteBlack = 0xFF36393F;

  // Log Categories
  static const List<String> logCategories = [
    'All',
    'Moderation',
    'Messages',
    'Voice',
    'Members',
    'Server',
    'Bot',
    'Commands',
    'Security',
  ];

  // Permission Levels
  static const List<String> permissionLevels = [
    'Admin',
    'Moderator',
    'Helper',
    'Member',
    'Muted',
    'Banned',
  ];

  // Ticket Statuses
  static const List<String> ticketStatuses = [
    'Open',
    'In Progress',
    'Waiting',
    'Closed',
    'Resolved',
  ];

  // Moderation Actions
  static const List<String> moderationActions = [
    'Ban',
    'Softban',
    'Tempban',
    'Kick',
    'Timeout',
    'Warn',
    'Mute',
    'Unmute',
    'Unban',
    'Clear Warnings',
    'Note',
    'Slowmode',
  ];

  // Chart Colors
  static const List<int> chartColors = [
    0xFF5865F2,
    0xFF57F287,
    0xFFFEE75C,
    0xFFED4245,
    0xFFEB459E,
    0xFF00B0F4,
    0xFFFF7043,
    0xFF9C27B0,
  ];
}
