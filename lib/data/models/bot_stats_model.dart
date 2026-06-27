class BotStatsModel {
  final int totalServers;
  final int totalMembers;
  final int onlineMembers;
  final String botStatus;
  final double cpuUsage;
  final double ramUsage;
  final int ping;
  final int latency;
  final Duration uptime;
  final int commandsToday;
  final int moderationToday;
  final int warningsToday;
  final int activeTickets;
  final int activeGiveaways;
  final int musicQueueSize;
  final double economyBalance;
  final int verificationQueue;
  final double serverHealthScore;
  final double securityScore;
  final List<CommandStat> topCommands;
  final List<ActivityPoint> activityHistory;

  const BotStatsModel({
    required this.totalServers,
    required this.totalMembers,
    required this.onlineMembers,
    required this.botStatus,
    required this.cpuUsage,
    required this.ramUsage,
    required this.ping,
    required this.latency,
    required this.uptime,
    required this.commandsToday,
    required this.moderationToday,
    required this.warningsToday,
    required this.activeTickets,
    required this.activeGiveaways,
    required this.musicQueueSize,
    required this.economyBalance,
    required this.verificationQueue,
    required this.serverHealthScore,
    required this.securityScore,
    required this.topCommands,
    required this.activityHistory,
  });

  String get uptimeFormatted {
    final days = uptime.inDays;
    final hours = uptime.inHours.remainder(24);
    final minutes = uptime.inMinutes.remainder(60);
    if (days > 0) return '${days}d ${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  factory BotStatsModel.fromJson(Map<String, dynamic> json) {
    return BotStatsModel(
      totalServers: json['total_servers'] as int,
      totalMembers: json['total_members'] as int,
      onlineMembers: json['online_members'] as int,
      botStatus: json['bot_status'] as String,
      cpuUsage: (json['cpu_usage'] as num).toDouble(),
      ramUsage: (json['ram_usage'] as num).toDouble(),
      ping: json['ping'] as int,
      latency: json['latency'] as int,
      uptime: Duration(seconds: json['uptime_seconds'] as int),
      commandsToday: json['commands_today'] as int,
      moderationToday: json['moderation_today'] as int,
      warningsToday: json['warnings_today'] as int,
      activeTickets: json['active_tickets'] as int,
      activeGiveaways: json['active_giveaways'] as int,
      musicQueueSize: json['music_queue_size'] as int,
      economyBalance: (json['economy_balance'] as num).toDouble(),
      verificationQueue: json['verification_queue'] as int,
      serverHealthScore: (json['server_health_score'] as num).toDouble(),
      securityScore: (json['security_score'] as num).toDouble(),
      topCommands: (json['top_commands'] as List? ?? [])
          .map((e) => CommandStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      activityHistory: (json['activity_history'] as List? ?? [])
          .map((e) => ActivityPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static BotStatsModel get mock => BotStatsModel(
        totalServers: 42,
        totalMembers: 156789,
        onlineMembers: 23456,
        botStatus: 'Online',
        cpuUsage: 0.23,
        ramUsage: 0.67,
        ping: 45,
        latency: 62,
        uptime: const Duration(days: 12, hours: 5, minutes: 34),
        commandsToday: 8432,
        moderationToday: 127,
        warningsToday: 45,
        activeTickets: 23,
        activeGiveaways: 5,
        musicQueueSize: 12,
        economyBalance: 4567890.50,
        verificationQueue: 8,
        serverHealthScore: 0.92,
        securityScore: 0.87,
        topCommands: [
          const CommandStat(name: 'play', count: 1234, percentage: 0.42),
          const CommandStat(name: 'ban', count: 456, percentage: 0.16),
          const CommandStat(name: 'help', count: 389, percentage: 0.13),
          const CommandStat(name: 'warn', count: 312, percentage: 0.11),
          const CommandStat(name: 'kick', count: 201, percentage: 0.07),
        ],
        activityHistory: List.generate(
          7,
          (i) => ActivityPoint(
            date: DateTime.now().subtract(Duration(days: 6 - i)),
            commands: 5000 + (i * 500) + (i % 3 == 0 ? 1200 : 0),
            members: 100 + (i * 20),
          ),
        ),
      );
}

class CommandStat {
  final String name;
  final int count;
  final double percentage;

  const CommandStat({
    required this.name,
    required this.count,
    required this.percentage,
  });

  factory CommandStat.fromJson(Map<String, dynamic> json) => CommandStat(
        name: json['name'] as String,
        count: json['count'] as int,
        percentage: (json['percentage'] as num).toDouble(),
      );
}

class ActivityPoint {
  final DateTime date;
  final int commands;
  final int members;

  const ActivityPoint({
    required this.date,
    required this.commands,
    required this.members,
  });

  factory ActivityPoint.fromJson(Map<String, dynamic> json) => ActivityPoint(
        date: DateTime.parse(json['date'] as String),
        commands: json['commands'] as int,
        members: json['members'] as int,
      );
}
