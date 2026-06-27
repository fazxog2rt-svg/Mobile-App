import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  Future<void> showRaidAlert(String serverName, String message) async {
    await _show(
      id: 1,
      title: '🚨 Raid Alert — $serverName',
      body: message,
      channelId: 'raid_alert',
      channelName: 'Raid Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  Future<void> showMemberJoin(String name, String serverName) async {
    await _show(
      id: 2,
      title: '👋 New Member — $serverName',
      body: '$name joined the server',
      channelId: 'members',
      channelName: 'Member Events',
    );
  }

  Future<void> showTicketUpdate(String ticketId, String update) async {
    await _show(
      id: 3,
      title: '🎫 Ticket #$ticketId Updated',
      body: update,
      channelId: 'tickets',
      channelName: 'Tickets',
    );
  }

  Future<void> showBotOffline(String serverName) async {
    await _show(
      id: 4,
      title: '❌ Bot Offline — $serverName',
      body: 'The bot has gone offline. Tap to investigate.',
      channelId: 'bot_status',
      channelName: 'Bot Status',
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  Future<void> showHighResource(String resource, double value) async {
    await _show(
      id: 5,
      title: '⚠️ High $resource Usage',
      body: '$resource is at ${(value * 100).toStringAsFixed(1)}%',
      channelId: 'system',
      channelName: 'System Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: importance,
          priority: priority,
          color: const Color(0xFF5865F2),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}

// ignore: avoid_classes_with_only_static_members
class Color {
  final int value;
  const Color(this.value);
}
