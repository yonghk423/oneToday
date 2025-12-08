import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/goal_service.dart';
import '../services/widget_service.dart';
import 'goal_state.dart';

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
