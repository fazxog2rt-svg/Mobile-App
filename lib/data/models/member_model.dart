class MemberModel {
  final String id;
  final String username;
  final String discriminator;
  final String? avatar;
  final String? nickname;
  final List<String> roles;
  final DateTime joinedAt;
  final bool isOnline;
  final String status;
  final int warnCount;
  final bool isBanned;
  final bool isMuted;
  final DateTime? timeoutUntil;

  const MemberModel({
    required this.id,
    required this.username,
    required this.discriminator,
    this.avatar,
    this.nickname,
    this.roles = const [],
    required this.joinedAt,
    this.isOnline = false,
    this.status = 'offline',
    this.warnCount = 0,
    this.isBanned = false,
    this.isMuted = false,
    this.timeoutUntil,
  });

  String get displayName => nickname ?? username;

  String get tag => discriminator == '0' ? username : '$username#$discriminator';

  String get avatarUrl => avatar != null
      ? 'https://cdn.discordapp.com/avatars/$id/$avatar.png?size=256'
      : 'https://cdn.discordapp.com/embed/avatars/${int.parse(id) % 5}.png';

  bool get isTimedOut =>
      timeoutUntil != null && timeoutUntil!.isAfter(DateTime.now());

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return MemberModel(
      id: user['id'] as String,
      username: user['username'] as String,
      discriminator: (user['discriminator'] as String?) ?? '0',
      avatar: user['avatar'] as String?,
      nickname: json['nick'] as String?,
      roles: List<String>.from(json['roles'] as List? ?? []),
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : DateTime.now(),
      isOnline: (json['is_online'] as bool?) ?? false,
      status: (json['status'] as String?) ?? 'offline',
      warnCount: (json['warn_count'] as int?) ?? 0,
      isBanned: (json['is_banned'] as bool?) ?? false,
      isMuted: (json['is_muted'] as bool?) ?? false,
      timeoutUntil: json['timeout_until'] != null
          ? DateTime.parse(json['timeout_until'] as String)
          : null,
    );
  }

  static List<MemberModel> get mockList => [
        MemberModel(
          id: '111111111111111111',
          username: 'DiscordUser1',
          discriminator: '0',
          joinedAt: DateTime.now().subtract(const Duration(days: 120)),
          isOnline: true,
          status: 'online',
          warnCount: 0,
        ),
        MemberModel(
          id: '222222222222222222',
          username: 'Moderator_Sam',
          discriminator: '0',
          joinedAt: DateTime.now().subtract(const Duration(days: 450)),
          isOnline: true,
          status: 'dnd',
          warnCount: 0,
        ),
        MemberModel(
          id: '333333333333333333',
          username: 'TroubleUser99',
          discriminator: '1234',
          joinedAt: DateTime.now().subtract(const Duration(days: 30)),
          isOnline: false,
          status: 'offline',
          warnCount: 3,
          isMuted: true,
        ),
        MemberModel(
          id: '444444444444444444',
          username: 'CoolGamer2024',
          discriminator: '0',
          joinedAt: DateTime.now().subtract(const Duration(days: 7)),
          isOnline: true,
          status: 'idle',
          warnCount: 1,
        ),
      ];
}
