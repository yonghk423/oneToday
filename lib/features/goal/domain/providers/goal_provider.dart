import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'goal_notifier.dart';
import '../state/goal_state.dart';

/// Goal 상태를 관리하는 Provider
final goalProvider = StateNotifierProvider<GoalNotifier, GoalState>((ref) {
  return GoalNotifier();
});
