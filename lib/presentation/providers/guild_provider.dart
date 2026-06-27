import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/guild_model.dart';
import '../../services/discord_service.dart';

final selectedGuildIdProvider = StateProvider<String?>((ref) => null);

final guildsProvider = FutureProvider<List<GuildModel>>((ref) async {
  final service = ref.watch(discordServiceProvider);
  return service.getGuilds();
});

final selectedGuildProvider = Provider<GuildModel?>((ref) {
  final guildId = ref.watch(selectedGuildIdProvider);
  final guildsAsync = ref.watch(guildsProvider);
  return guildsAsync.when(
    data: (guilds) => guilds.isEmpty
        ? null
        : guilds.firstWhere(
            (g) => g.id == guildId,
            orElse: () => guilds.first,
          ),
    loading: () => null,
    error: (_, __) => null,
  );
});

