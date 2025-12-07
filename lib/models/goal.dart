class Goal {
  final String name;
  final DateTime createdAt;
  final bool completed;
  final List<int> alarmMinutes; // 알람 설정 (분 단위)

  Goal({
    required this.name,
    required this.createdAt,
    this.completed = false,
    this.alarmMinutes = const [],
  });

  // 오늘 자정까지 남은 시간 계산
  Duration getRemainingTimeUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0);
    return midnight.difference(now);
  }

  // 오늘 날짜인지 확인
  bool isToday() {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  // 알람 시간을 DateTime으로 변환
  List<DateTime> getAlarmTimes() {
    final midnight = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day + 1,
      0,
      0,
    );

    return alarmMinutes.map((minutes) {
      return midnight.subtract(Duration(minutes: minutes));
    }).toList();
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'completed': completed,
      'alarm_minutes': alarmMinutes,
    };
  }

  // JSON에서 생성
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      completed: json['completed'] as bool? ?? false,
      alarmMinutes:
          (json['alarm_minutes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  // 완료된 목표 복사
  Goal copyWith({bool? completed}) {
    return Goal(
      name: name,
      createdAt: createdAt,
      completed: completed ?? this.completed,
      alarmMinutes: alarmMinutes,
    );
  }
}
