class GuildModel {
  final String id;
  final String name;
  final String? icon;
  final String? banner;
  final String? description;
  final int memberCount;
  final int onlineCount;
  final bool botPresent;
  final String? ownerId;
  final List<String> features;
  final int premiumTier;
  final DateTime createdAt;

  const GuildModel({
    required this.id,
    required this.name,
    this.icon,
    this.banner,
    this.description,
    required this.memberCount,
    required this.onlineCount,
    required this.botPresent,
    this.ownerId,
    this.features = const [],
    this.premiumTier = 0,
    required this.createdAt,
  });

  String get iconUrl => icon != null
      ? 'https://cdn.discordapp.com/icons/$id/$icon.png?size=256'
      : 'https://cdn.discordapp.com/embed/avatars/0.png';

  String get bannerUrl => banner != null
      ? 'https://cdn.discordapp.com/banners/$id/$banner.png?size=1024'
      : '';

  factory GuildModel.fromJson(Map<String, dynamic> json) {
    return GuildModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      banner: json['banner'] as String?,
      description: json['description'] as String?,
      memberCount: (json['approximate_member_count'] as int?) ?? 0,
      onlineCount: (json['approximate_presence_count'] as int?) ?? 0,
      botPresent: (json['bot_present'] as bool?) ?? false,
      ownerId: json['owner_id'] as String?,
      features: List<String>.from(json['features'] as List? ?? []),
      premiumTier: (json['premium_tier'] as int?) ?? 0,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'banner': banner,
        'description': description,
        'approximate_member_count': memberCount,
        'approximate_presence_count': onlineCount,
        'bot_present': botPresent,
        'owner_id': ownerId,
        'features': features,
        'premium_tier': premiumTier,
      };

  GuildModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? banner,
    String? description,
    int? memberCount,
    int? onlineCount,
    bool? botPresent,
    String? ownerId,
    List<String>? features,
    int? premiumTier,
    DateTime? createdAt,
  }) {
    return GuildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      banner: banner ?? this.banner,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      onlineCount: onlineCount ?? this.onlineCount,
      botPresent: botPresent ?? this.botPresent,
      ownerId: ownerId ?? this.ownerId,
      features: features ?? this.features,
      premiumTier: premiumTier ?? this.premiumTier,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Mock data
  static List<GuildModel> get mockList => [
        GuildModel(
          id: '123456789',
          name: 'Gaming Community',
          memberCount: 15234,
          onlineCount: 2341,
          botPresent: true,
          premiumTier: 2,
          features: ['COMMUNITY', 'ANIMATED_ICON'],
          createdAt: DateTime(2021, 3, 15),
        ),
        GuildModel(
          id: '987654321',
          name: 'Dev Hub',
          memberCount: 8763,
          onlineCount: 1205,
          botPresent: true,
          premiumTier: 1,
          features: ['COMMUNITY'],
          createdAt: DateTime(2020, 8, 22),
        ),
        GuildModel(
          id: '111222333',
          name: 'Anime Central',
          memberCount: 42100,
          onlineCount: 5670,
          botPresent: true,
          premiumTier: 3,
          features: ['COMMUNITY', 'ANIMATED_ICON', 'BANNER'],
          createdAt: DateTime(2019, 1, 10),
        ),
        GuildModel(
          id: '444555666',
          name: 'Music Lovers',
          memberCount: 3421,
          onlineCount: 432,
          botPresent: false,
          premiumTier: 0,
          features: [],
          createdAt: DateTime(2022, 6, 5),
        ),
      ];
}
