import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/goal.dart';
import '../../../../services/goal_service.dart';
import '../../../../shared/services/alarm_service.dart';
import '../../../../shared/services/widget_service.dart';
import '../state/goal_state.dart';

/// Goal 상태를 관리하는 Notifier
class GoalNotifier extends StateNotifier<GoalState> {
  GoalNotifier() : super(GoalState.initial());

  /// 목표 로드
  Future<void> loadGoal() async {
    // 로딩 상태로 변경
    state = GoalState.loading();

    try {
      // 기존 GoalService 사용
      final goal = await GoalService.loadGoal();

      // 위젯 업데이트
      await WidgetService.updateWidget(goal);

      // 로드 완료 상태로 변경
      state = GoalState.loaded(goal);
    } catch (e) {
      // 에러 상태로 변경
      state = GoalState.error(e.toString());
    }
  }

  /// 목표 저장
  Future<bool> saveGoal(Goal goal, List<int> alarmMinutes) async {
    try {
      // 오늘 목표가 이미 있는지 확인
      final hasGoal = await GoalService.hasTodayGoal();
      if (hasGoal) {
        // 이미 목표가 있는 경우 false 반환 (에러는 호출하는 쪽에서 처리)
        return false;
      }

      // 알람 정보를 포함한 목표 생성
      final goalWithAlarms = goal.copyWith(alarmMinutes: alarmMinutes);

      // 목표 저장
      await GoalService.saveGoal(goalWithAlarms);

      // 알람 스케줄링 (알람이 설정된 경우)
      if (alarmMinutes.isNotEmpty) {
        await AlarmService.scheduleAlarms(goalWithAlarms);
      }

      // 위젯 업데이트
      await WidgetService.updateWidget(goalWithAlarms);

      // 상태를 로드된 상태로 변경
      state = GoalState.loaded(goalWithAlarms);

      return true;
    } catch (e) {
      // 에러 상태로 변경
      state = GoalState.error(e.toString());
      return false;
    }
  }

  /// 목표 삭제
  Future<void> deleteGoal() async {
    try {
      // 목표 삭제
      await GoalService.deleteGoal();
      // 위젯 업데이트 (목표 없음)
      await WidgetService.updateWidget(null);
      // 상태를 빈 상태로 변경
      state = GoalState.loaded(null);
    } catch (e) {
      // 에러 상태로 변경
      state = GoalState.error(e.toString());
    }
  }
}
