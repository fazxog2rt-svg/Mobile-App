enum TicketStatus { open, inProgress, waiting, closed, resolved }

enum TicketPriority { low, medium, high, urgent }

class TicketModel {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final String creatorId;
  final String creatorName;
  final String? assignedToId;
  final String? assignedToName;
  final String channelId;
  final int messageCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closedAt;
  final List<String> tags;
  final String category;

  const TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.creatorId,
    required this.creatorName,
    this.assignedToId,
    this.assignedToName,
    required this.channelId,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
    this.tags = const [],
    required this.category,
  });

  Duration get age => DateTime.now().difference(createdAt);

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        status: TicketStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => TicketStatus.open,
        ),
        priority: TicketPriority.values.firstWhere(
          (e) => e.name == json['priority'],
          orElse: () => TicketPriority.medium,
        ),
        creatorId: json['creator_id'] as String,
        creatorName: json['creator_name'] as String,
        assignedToId: json['assigned_to_id'] as String?,
        assignedToName: json['assigned_to_name'] as String?,
        channelId: json['channel_id'] as String,
        messageCount: (json['message_count'] as int?) ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        closedAt: json['closed_at'] != null
            ? DateTime.parse(json['closed_at'] as String)
            : null,
        tags: List<String>.from(json['tags'] as List? ?? []),
        category: json['category'] as String,
      );

  static List<TicketModel> get mockList => [
        TicketModel(
          id: 'TKT-001',
          title: 'Bot not responding to commands',
          description: 'The bot stopped responding to all commands in the server.',
          status: TicketStatus.open,
          priority: TicketPriority.high,
          creatorId: '111111111111111111',
          creatorName: 'DiscordUser1',
          channelId: '999999999999999999',
          messageCount: 5,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          tags: ['bug', 'bot'],
          category: 'Technical Support',
        ),
        TicketModel(
          id: 'TKT-002',
          title: 'Need help with verification',
          description: 'Cannot complete the verification process.',
          status: TicketStatus.inProgress,
          priority: TicketPriority.medium,
          creatorId: '444444444444444444',
          creatorName: 'CoolGamer2024',
          assignedToId: '222222222222222222',
          assignedToName: 'Moderator_Sam',
          channelId: '888888888888888888',
          messageCount: 12,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          tags: ['verification'],
          category: 'General Support',
        ),
        TicketModel(
          id: 'TKT-003',
          title: 'Appeal for ban',
          description: 'I was wrongly banned and would like to appeal.',
          status: TicketStatus.waiting,
          priority: TicketPriority.urgent,
          creatorId: '333333333333333333',
          creatorName: 'TroubleUser99',
          channelId: '777777777777777777',
          messageCount: 8,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
          tags: ['ban', 'appeal'],
          category: 'Ban Appeal',
        ),
      ];
}
