import 'package:flutter/material.dart';

enum LogCategory {
  moderation,
  messages,
  voice,
  members,
  server,
  bot,
  commands,
  security,
}

enum LogSeverity { info, warning, error, success }

class LogModel {
  final String id;
  final LogCategory category;
  final LogSeverity severity;
  final String title;
  final String description;
  final String? userId;
  final String? username;
  final String? targetId;
  final String? targetName;
  final String? channelId;
  final String? channelName;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const LogModel({
    required this.id,
    required this.category,
    required this.severity,
    required this.title,
    required this.description,
    this.userId,
    this.username,
    this.targetId,
    this.targetName,
    this.channelId,
    this.channelName,
    required this.timestamp,
    this.metadata = const {},
  });

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
        id: json['id'] as String,
        category: LogCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => LogCategory.bot,
        ),
        severity: LogSeverity.values.firstWhere(
          (e) => e.name == json['severity'],
          orElse: () => LogSeverity.info,
        ),
        title: json['title'] as String,
        description: json['description'] as String,
        userId: json['user_id'] as String?,
        username: json['username'] as String?,
        targetId: json['target_id'] as String?,
        targetName: json['target_name'] as String?,
        channelId: json['channel_id'] as String?,
        channelName: json['channel_name'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
        metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      );

  Color get severityColor {
    switch (severity) {
      case LogSeverity.error: return const Color(0xFFED4245);
      case LogSeverity.warning: return const Color(0xFFFEE75C);
      case LogSeverity.success: return const Color(0xFF57F287);
      case LogSeverity.info: return const Color(0xFF00B0F4);
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case LogCategory.moderation: return Icons.gavel_rounded;
      case LogCategory.messages: return Icons.message_rounded;
      case LogCategory.voice: return Icons.mic_rounded;
      case LogCategory.members: return Icons.people_rounded;
      case LogCategory.server: return Icons.dns_rounded;
      case LogCategory.bot: return Icons.smart_toy_rounded;
      case LogCategory.commands: return Icons.terminal_rounded;
      case LogCategory.security: return Icons.security_rounded;
    }
  }

  static List<LogModel> get mockList => [
        LogModel(
          id: '1',
          category: LogCategory.moderation,
          severity: LogSeverity.warning,
          title: 'User Banned',
          description: 'TroubleUser99 was banned by Moderator_Sam',
          userId: '222222222222222222',
          username: 'Moderator_Sam',
          targetId: '333333333333333333',
          targetName: 'TroubleUser99',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        LogModel(
          id: '2',
          category: LogCategory.members,
          severity: LogSeverity.success,
          title: 'Member Joined',
          description: 'NewMember2024 joined the server',
          targetName: 'NewMember2024',
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        LogModel(
          id: '3',
          category: LogCategory.security,
          severity: LogSeverity.error,
          title: 'Raid Detected',
          description: 'Auto-raid protection activated: 15 accounts joined within 2 minutes',
          timestamp: DateTime.now().subtract(const Duration(minutes: 23)),
        ),
        LogModel(
          id: '4',
          category: LogCategory.messages,
          severity: LogSeverity.info,
          title: 'Message Deleted',
          description: 'A message containing profanity was auto-deleted in #general',
          channelName: 'general',
          timestamp: DateTime.now().subtract(const Duration(minutes: 34)),
        ),
        LogModel(
          id: '5',
          category: LogCategory.voice,
          severity: LogSeverity.info,
          title: 'Voice Channel Activity',
          description: 'CoolGamer2024 joined #Gaming Voice',
          userId: '444444444444444444',
          username: 'CoolGamer2024',
          channelName: 'Gaming Voice',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        LogModel(
          id: '6',
          category: LogCategory.commands,
          severity: LogSeverity.info,
          title: 'Command Used',
          description: '/play was used 234 times today',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        LogModel(
          id: '7',
          category: LogCategory.server,
          severity: LogSeverity.info,
          title: 'Role Created',
          description: 'New role "VIP Member" was created',
          username: 'ServerAdmin',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        LogModel(
          id: '8',
          category: LogCategory.moderation,
          severity: LogSeverity.warning,
          title: 'User Warned',
          description: 'DiscordUser1 received warning #1 for spamming',
          targetName: 'DiscordUser1',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
}
