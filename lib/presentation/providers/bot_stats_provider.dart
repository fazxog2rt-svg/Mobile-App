import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/bot_stats_model.dart';

class BotStatsNotifier extends StateNotifier<AsyncValue<BotStatsModel>> {
  Timer? _refreshTimer;

  BotStatsNotifier() : super(const AsyncValue.loading()) {
    _loadStats();
    _startAutoRefresh();
  }

  Future<void> _loadStats() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      state = AsyncValue.data(BotStatsModel.mock);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      refresh();
    });
  }

  Future<void> refresh() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = AsyncValue.data(BotStatsModel.mock);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}

final botStatsProvider =
    StateNotifierProvider<BotStatsNotifier, AsyncValue<BotStatsModel>>((ref) {
  return BotStatsNotifier();
});
