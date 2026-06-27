import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/log_model.dart';

enum WsStatus { disconnected, connecting, connected, error }

class WebSocketState {
  final WsStatus status;
  final List<LogModel> realtimeLogs;
  final String? error;

  const WebSocketState({
    this.status = WsStatus.disconnected,
    this.realtimeLogs = const [],
    this.error,
  });

  WebSocketState copyWith({
    WsStatus? status,
    List<LogModel>? realtimeLogs,
    String? error,
  }) {
    return WebSocketState(
      status: status ?? this.status,
      realtimeLogs: realtimeLogs ?? this.realtimeLogs,
      error: error ?? this.error,
    );
  }
}

class WebSocketNotifier extends StateNotifier<WebSocketState> {
  Timer? _simulationTimer;
  int _logCounter = 100;

  WebSocketNotifier() : super(const WebSocketState()) {
    _connect();
  }

  void _connect() {
    state = state.copyWith(status: WsStatus.connecting);
    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(
        status: WsStatus.connected,
        realtimeLogs: LogModel.mockList,
      );
      _startSimulation();
    });
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _addRealtimeLog();
    });
  }

  void _addRealtimeLog() {
    final categories = LogCategory.values;
    final severities = LogSeverity.values;
    final titles = [
      'Message Deleted',
      'Member Joined',
      'Command Used',
      'Role Updated',
      'Voice Activity',
      'Warning Issued',
    ];
    final descriptions = [
      'Auto-moderation removed a message',
      'A new member joined the server',
      '/help was used in #general',
      'Role permissions were updated',
      'User joined #Music Voice',
      'User received a warning for spam',
    ];

    final idx = _logCounter % titles.length;
    final newLog = LogModel(
      id: '${++_logCounter}',
      category: categories[_logCounter % categories.length],
      severity: severities[_logCounter % severities.length],
      title: titles[idx],
      description: descriptions[idx],
      timestamp: DateTime.now(),
    );

    final updated = [newLog, ...state.realtimeLogs];
    if (updated.length > 100) updated.removeLast();
    state = state.copyWith(realtimeLogs: updated);
  }

  void disconnect() {
    _simulationTimer?.cancel();
    state = state.copyWith(status: WsStatus.disconnected);
  }

  void reconnect() {
    _connect();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}

final webSocketProvider =
    StateNotifierProvider<WebSocketNotifier, WebSocketState>((ref) {
  return WebSocketNotifier();
});

final realtimeLogsProvider = Provider<List<LogModel>>((ref) {
  return ref.watch(webSocketProvider).realtimeLogs;
});

final wsStatusProvider = Provider<WsStatus>((ref) {
  return ref.watch(webSocketProvider).status;
});
