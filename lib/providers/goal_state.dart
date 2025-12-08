import '../models/goal.dart';

/// Goal의 상태를 관리하는 클래스
class GoalState {
  final Goal? goal;
  final bool isLoading;
  final String? error;

  const GoalState({this.goal, this.isLoading = false, this.error});

  /// 초기 상태
  factory GoalState.initial() {
    return const GoalState();
  }

  /// 로딩 상태
  factory GoalState.loading() {
    return const GoalState(isLoading: true);
  }

  /// 로드 완료 상태
  factory GoalState.loaded(Goal? goal) {
    return GoalState(goal: goal, isLoading: false);
  }

  /// 에러 상태
  factory GoalState.error(String error) {
    return GoalState(error: error, isLoading: false);
  }

  /// 상태 복사
  GoalState copyWith({Goal? goal, bool? isLoading, String? error}) {
    return GoalState(
      goal: goal ?? this.goal,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
