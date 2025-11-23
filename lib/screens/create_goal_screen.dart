import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../services/alarm_service.dart';
import '../widgets/alarm_setting_widget.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final TextEditingController _goalController = TextEditingController();
  List<int> _selectedAlarms = [];

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  // 오늘 자정까지 남은 시간 계산
  Duration _getRemainingTimeUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0);
    return midnight.difference(now);
  }

  void _createGoal() async {
    if (_goalController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('목표 이름을 입력해주세요')),
        );
      }
      return;
    }

    // 오늘 목표가 이미 있는지 확인
    final hasGoal = await GoalService.hasTodayGoal();
    if (hasGoal) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('오늘의 목표는 이미 설정되어 있습니다')),
        );
      }
      return;
    }

    final now = DateTime.now();
    final goal = Goal(
      name: _goalController.text.trim(),
      createdAt: now,
      completed: false,
      alarmMinutes: _selectedAlarms,
    );

    // 목표 저장
    await GoalService.saveGoal(goal);

    // 알람 스케줄링 (실제 설정한 시간에 맞춰 알람 표시)
    if (_selectedAlarms.isNotEmpty) {
      await AlarmService.scheduleAlarms(goal);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _getRemainingTimeUntilMidnight();
    final hoursRemaining = remaining.inHours;
    final minutesRemaining = remaining.inMinutes % 60;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('오늘의 목표 설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 오늘 남은 시간 안내
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '오늘 남은 시간',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$hoursRemaining',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '시간',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$minutesRemaining',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '분',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '자정까지 남은 시간입니다',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ).animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.2, end: 0),
            const SizedBox(height: 32),

            // 목표 이름 입력
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '목표 이름',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _goalController,
                  decoration: InputDecoration(
                    hintText: '예: 영어 문법 공부',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    counterStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: const Icon(Icons.edit_note, color: Color(0xFF6366F1)),
                  ),
                  maxLength: 50,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ).animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 24),

            // 구분선
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 24),

            // 알람 설정
            AlarmSettingWidget(
              onAlarmChanged: (alarms) {
                setState(() {
                  _selectedAlarms = alarms;
                });
              },
            ).animate()
              .fadeIn(delay: 300.ms)
              .slideX(begin: -0.2, end: 0),

            const SizedBox(height: 32),

            // 생성 버튼
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _createGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flag, size: 24),
                    SizedBox(width: 12),
                    Text(
                      '목표 생성',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate()
              .fadeIn(delay: 400.ms)
              .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}

