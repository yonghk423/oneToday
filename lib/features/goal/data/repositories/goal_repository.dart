import '../../../../services/goal_service.dart';
import '../models/goal.dart';

/// Goal 데이터를 관리하는 Repository
/// GoalService를 래핑하여 데이터 레이어와 도메인 레이어를 분리
class GoalRepository {
  /// 목표 저장
  Future<void> saveGoal(Goal goal) async {
    await GoalService.saveGoal(goal);
  }

  /// 목표 로드
  Future<Goal?> loadGoal() async {
    return await GoalService.loadGoal();
  }

  /// 목표 삭제
  Future<void> deleteGoal() async {
    await GoalService.deleteGoal();
  }

  /// 오늘 목표가 있는지 확인
  Future<bool> hasTodayGoal() async {
    return await GoalService.hasTodayGoal();
  }

  /// 목표 완료 처리
  Future<void> completeGoal() async {
    await GoalService.completeGoal();
  }
}
