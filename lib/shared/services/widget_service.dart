import 'package:home_widget/home_widget.dart';
import '../../features/goal/data/models/goal.dart';

/// 홈 화면 위젯 데이터를 관리하는 서비스
class WidgetService {
  // 위젯 데이터 키
  static const String _goalNameKey = 'goal_name';
  static const String _remainingHoursKey = 'remaining_hours';
  static const String _remainingMinutesKey = 'remaining_minutes';
  static const String _hasGoalKey = 'has_goal';
  static const String _goalCompletedKey = 'goal_completed';

  // App Group ID (iOS에서 앱과 위젯 간 데이터 공유용)
  // Xcode > Signing & Capabilities > App Groups 에서 설정한 값과 동일해야 합니다.
  static const String _appGroupId = 'group.com.smileDragon.onetoday';

  /// 위젯 초기화
  /// 앱 시작 시 한 번만 호출하면 됩니다
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(_appGroupId);
    } catch (e) {
      // iOS에서 App Group이 아직 설정되지 않았을 수 있음
      // 나중에 Xcode에서 설정하면 해결됩니다
      print('WidgetService 초기화 오류 (나중에 Xcode 설정 필요): $e');
    }
  }

  /// 목표 정보를 위젯에 업데이트
  /// 목표가 생성, 완료, 삭제될 때 호출합니다
  static Future<void> updateWidget(Goal? goal) async {
    try {
      if (goal == null || goal.completed) {
        // 목표가 없거나 완료된 경우
        await HomeWidget.saveWidgetData(_hasGoalKey, false);
        await HomeWidget.saveWidgetData(
          _goalCompletedKey,
          goal?.completed ?? false,
        );
        await HomeWidget.updateWidget(
          name: 'OneTodayWidget', // Android 위젯 이름
          iOSName: 'oneTodayWidget', // iOS 위젯 이름 (Swift kind와 동일)
        );
        return;
      }

      // 남은 시간 계산
      final remainingTime = goal.getRemainingTimeUntilMidnight();
      final hours = remainingTime.inHours;
      final minutes = remainingTime.inMinutes % 60;

      // 위젯 데이터 저장
      await HomeWidget.saveWidgetData(_hasGoalKey, true);
      await HomeWidget.saveWidgetData(_goalNameKey, goal.name);
      await HomeWidget.saveWidgetData(_remainingHoursKey, hours);
      await HomeWidget.saveWidgetData(_remainingMinutesKey, minutes);
      await HomeWidget.saveWidgetData(_goalCompletedKey, false);

      // 위젯 새로고침
      await HomeWidget.updateWidget(
        name: 'OneTodayWidget', // Android 위젯 이름
        iOSName: 'oneTodayWidget', // iOS 위젯 이름 (Swift kind와 동일)
      );
    } catch (e) {
      print('위젯 업데이트 오류: $e');
      // 위젯이 아직 구현되지 않았을 수 있으므로 에러를 무시합니다
    }
  }

  /// 위젯 데이터 삭제 (목표 삭제 시)
  static Future<void> clearWidget() async {
    await updateWidget(null);
  }
}
