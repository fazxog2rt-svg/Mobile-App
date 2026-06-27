import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../core/constants/app_constants.dart';

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(service.disconnect);
  return service;
});

enum WsEvent {
  memberJoin,
  memberLeave,
  messageSent,
  messageDelete,
  botStats,
  raidAlert,
  moderationAction,
  ticketUpdate,
  giveawayEnd,
  serverDown,
  botOffline,
  highResource,
}

class WebSocketService {
  WebSocketChannel? _channel;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _retryCount = 0;
  bool _shouldReconnect = true;

  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get events => _eventController.stream;

  void connect(String guildId, String token) {
    _shouldReconnect = true;
    _connect(guildId, token);
  }

  void _connect(String guildId, String token) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('${AppConstants.wsBaseUrl}?guild_id=$guildId&token=$token'),
      );

      _channel!.stream.listen(
        (data) {
          _retryCount = 0;
          final decoded = jsonDecode(data as String) as Map<String, dynamic>;
          _eventController.add(decoded);
        },
        onError: (_) => _scheduleReconnect(guildId, token),
        onDone: () => _scheduleReconnect(guildId, token),
      );

      _startPing();
    } catch (_) {
      _scheduleReconnect(guildId, token);
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(
      const Duration(milliseconds: AppConstants.wsPingInterval),
      (_) => _channel?.sink.add(jsonEncode({'op': 1, 'd': null})),
    );
  }

  void _scheduleReconnect(String guildId, String token) {
    if (!_shouldReconnect || _retryCount >= AppConstants.wsMaxRetries) return;
    _retryCount++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(milliseconds: AppConstants.wsReconnectDelay * _retryCount),
      () => _connect(guildId, token),
    );
  }

  void send(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }

  void disconnect() {
    _shouldReconnect = false;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _eventController.close();
  }
}
