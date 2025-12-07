import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';

class GoalService {
  static const String _goalKey = 'today_goal';

  // 목표 저장
  static Future<void> saveGoal(Goal goal) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(goal.toJson());
    await prefs.setString(_goalKey, jsonString);
  }

  // 목표 로드
  static Future<Goal?> loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_goalKey);

    if (jsonString == null) {
      return null;
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final goal = Goal.fromJson(json);

      // 오늘 날짜인지 확인
      if (!goal.isToday()) {
        // 다음날이면 삭제
        await deleteGoal();
        return null;
      }

      return goal;
    } catch (e) {
      // 파싱 에러 시 삭제
      await deleteGoal();
      return null;
    }
  }

  // 목표 삭제
  static Future<void> deleteGoal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_goalKey);
  }

  // 오늘 목표가 있는지 확인
  static Future<bool> hasTodayGoal() async {
    final goal = await loadGoal();
    return goal != null && !goal.completed;
  }

  // 목표 완료 처리
  static Future<void> completeGoal() async {
    final goal = await loadGoal();
    if (goal != null) {
      final completedGoal = goal.copyWith(completed: true);
      await saveGoal(completedGoal);
    }
  }
}
