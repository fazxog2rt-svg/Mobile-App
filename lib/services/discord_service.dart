import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../core/network/api_client.dart';
import '../data/models/guild_model.dart';
import '../data/models/member_model.dart';
import '../data/models/log_model.dart';

final discordServiceProvider = Provider<DiscordService>((ref) {
  final dio = ref.watch(dioProvider);
  return DiscordService(dio);
});

class DiscordService {
  final Dio _dio;

  DiscordService(this._dio);

  Future<List<GuildModel>> getGuilds() async {
    try {
      final response = await _dio.get('/guilds');
      final list = response.data as List;
      return list.map((e) => GuildModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return GuildModel.mockList;
    }
  }

  Future<List<MemberModel>> getMembers(String guildId, {int page = 1}) async {
    try {
      final response = await _dio.get('/guilds/$guildId/members', queryParameters: {'page': page});
      final list = response.data as List;
      return list.map((e) => MemberModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return MemberModel.mockList;
    }
  }

  Future<void> banMember(String guildId, String userId, {String? reason, int? deleteMessageDays}) async {
    await _dio.put('/guilds/$guildId/bans/$userId', data: {
      'delete_message_days': deleteMessageDays ?? 1,
      'reason': reason ?? '',
    });
  }

  Future<void> kickMember(String guildId, String userId, {String? reason}) async {
    await _dio.delete('/guilds/$guildId/members/$userId', data: {'reason': reason ?? ''});
  }

  Future<void> timeoutMember(String guildId, String userId, Duration duration, {String? reason}) async {
    final until = DateTime.now().add(duration).toIso8601String();
    await _dio.patch('/guilds/$guildId/members/$userId', data: {
      'communication_disabled_until': until,
      'reason': reason ?? '',
    });
  }

  Future<void> warnMember(String guildId, String userId, String reason) async {
    await _dio.post('/guilds/$guildId/warnings', data: {'user_id': userId, 'reason': reason});
  }

  Future<List<LogModel>> getLogs(String guildId, {String? category, int page = 1}) async {
    try {
      final response = await _dio.get('/guilds/$guildId/logs', queryParameters: {
        'category': category,
        'page': page,
      });
      final list = response.data as List;
      return list.map((e) => LogModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return LogModel.mockList;
    }
  }

  Future<void> restartBot(String guildId) async {
    await _dio.post('/guilds/$guildId/bot/restart');
  }

  Future<void> reloadCommands(String guildId) async {
    await _dio.post('/guilds/$guildId/bot/reload-commands');
  }

  Future<void> syncSlashCommands(String guildId) async {
    await _dio.post('/guilds/$guildId/bot/sync-slash');
  }

  Future<Map<String, dynamic>> getSecuritySettings(String guildId) async {
    try {
      final response = await _dio.get('/guilds/$guildId/security');
      return response.data as Map<String, dynamic>;
    } catch (_) {
      return _defaultSecuritySettings();
    }
  }

  Future<void> updateSecuritySettings(String guildId, Map<String, dynamic> settings) async {
    await _dio.patch('/guilds/$guildId/security', data: settings);
  }

  Map<String, dynamic> _defaultSecuritySettings() => {
    'anti_raid': {
      'enabled': true,
      'anti_bot_raid': true,
      'anti_member_raid': true,
      'anti_channel_raid': false,
      'anti_role_raid': true,
      'anti_emoji_raid': false,
      'anti_sticker_raid': false,
      'anti_webhook_raid': true,
      'anti_spam': true,
      'anti_mention_everyone': true,
      'anti_link': false,
      'anti_scam': true,
      'anti_phishing': true,
      'anti_token_leak': true,
      'anti_invite_spam': true,
    },
    'anti_nuke': {
      'enabled': true,
      'detect_delete_channel': true,
      'detect_delete_role': true,
      'detect_delete_emoji': false,
      'detect_delete_sticker': false,
      'detect_delete_thread': true,
      'detect_delete_category': true,
      'auto_restore': true,
      'action': 'ban',
      'threshold': 3,
    },
    'verification': {
      'enabled': true,
      'type': 'button',
      'role_id': null,
    },
    'auto_mod': {
      'enabled': true,
      'auto_delete_spam': true,
      'auto_timeout': true,
      'auto_warn': true,
      'auto_kick': false,
      'auto_ban': false,
      'auto_slowmode': true,
      'auto_mute': false,
    },
  };
}
