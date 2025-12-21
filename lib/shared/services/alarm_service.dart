import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../../features/goal/data/models/goal.dart';

class AlarmService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // 알람 서비스 초기화
  static Future<void> initialize() async {
    if (_initialized) return;

    // 타임존 초기화
    tz.initializeTimeZones();

    // Android 초기화 설정
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS 초기화 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  // 알람 스케줄링
  static Future<void> scheduleAlarms(Goal goal) async {
    if (!_initialized) {
      await initialize();
    }

    final alarmTimes = goal.getAlarmTimes();
    final now = DateTime.now();

    // 로컬 타임존 가져오기
    final location = tz.getLocation('Asia/Seoul'); // 한국 시간대

    for (final alarmTime in alarmTimes) {
      // 현재 시간보다 미래인 알람만 스케줄링
      if (alarmTime.isAfter(now)) {
        final tzAlarmTime = tz.TZDateTime.from(alarmTime, location);
        final remaining = DateTime(
          alarmTime.year,
          alarmTime.month,
          alarmTime.day + 1,
          0,
          0,
        ).difference(alarmTime);

        final hours = remaining.inHours;
        final minutes = remaining.inMinutes % 60;
        String message;

        if (hours > 0) {
          message = "${goal.name} - $hours시간 남았습니다";
        } else {
          message = "${goal.name} - $minutes분 남았습니다";
        }

        await _notifications.zonedSchedule(
          alarmTime.hashCode, // 고유 ID
          'One Today',
          message,
          tzAlarmTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'one_today_channel',
              'One Today 알림',
              channelDescription: '목표 완료를 위한 알림',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  // 모든 알람 취소
  static Future<void> cancelAllAlarms() async {
    if (!_initialized) {
      await initialize();
    }
    await _notifications.cancelAll();
  }

  // 특정 알람 취소
  static Future<void> cancelAlarm(int id) async {
    if (!_initialized) {
      await initialize();
    }
    await _notifications.cancel(id);
  }

  // 테스트용: 5초 후 알람 표시 (알람 아이콘 클릭 시 사용)
  static Future<void> showTestNotification(Goal goal) async {
    if (!_initialized) {
      await initialize();
    }

    // 5초 후에 알림 표시
    Future.delayed(const Duration(seconds: 5), () async {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'one_today_channel',
          'One Today 알림',
          channelDescription: '목표 완료를 위한 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      await _notifications.show(
        999999, // 테스트용 고유 ID
        'One Today',
        '${goal.name} - 1시간 남았습니다',
        details,
      );
    });
  }

  // 알람 클릭 처리
  static void _onNotificationTapped(NotificationResponse response) {
    // 알람 클릭 시 처리 (선택사항)
  }
}
