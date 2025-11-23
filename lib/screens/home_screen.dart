import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../services/alarm_service.dart';
import '../widgets/analog_clock_widget.dart';
import 'create_goal_screen.dart';
import 'completed_screen.dart';
import 'failed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Goal? _currentGoal;
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadGoal();
    _startTimer();
    _initializeAlarmService();
  }

  Future<void> _initializeAlarmService() async {
    await AlarmService.initialize();
  }

  Future<void> _loadGoal() async {
    final goal = await GoalService.loadGoal();
    setState(() {
      _currentGoal = goal;
      if (goal != null) {
        _updateRemainingTime();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateRemainingTime();
        });
      }
    });
  }

  void _updateRemainingTime() {
    if (_currentGoal == null) return;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0);
    _remainingTime = midnight.difference(now);

    // 시간이 만료되었으면 실패 화면으로
    if (_remainingTime.isNegative || _remainingTime.inHours < 0) {
      _handleExpired();
    }
  }

  void _handleExpired() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FailedScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 목표가 없거나 완료된 경우
    if (_currentGoal == null) {
      return _buildEmptyState();
    }

    // 목표가 완료된 경우
    if (_currentGoal!.completed) {
      return _buildCompletedState();
    }

    // 목표가 있는 경우
    return _buildGoalState();
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('One Today'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withOpacity(0.1),
                      const Color(0xFF8B5CF6).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flag_rounded,
                  size: 80,
                  color: const Color(0xFF6366F1),
                ),
              ).animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 32),
              const Text(
                '오늘 목표가 없습니다',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ).animate()
                .fadeIn(delay: 300.ms),
              const SizedBox(height: 12),
              Text(
                '하루에 딱 하나, 오늘 꼭 이루고 싶은\n목표를 설정해보세요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(delay: 400.ms),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateGoalScreen(),
                      ),
                    );
                    if (result == true) {
                      _loadGoal();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, size: 24),
                      SizedBox(width: 8),
                      Text(
                        '목표 추가',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate()
                .fadeIn(delay: 500.ms)
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalState() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('One Today'),
        actions: [
          // 알람 테스트 버튼 (5초 후 알람 표시)
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: '5초 후 알람 테스트',
            onPressed: () async {
              if (_currentGoal == null) return;
              
              await AlarmService.showTestNotification(_currentGoal!);
              if (!mounted) return;
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('5초 후 알람이 표시됩니다. 앱을 잠그거나 다른 앱으로 이동해보세요!'),
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 목표 카드
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '오늘의 목표',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentGoal!.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ).animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.2, end: 0),
            const SizedBox(height: 40),

            // 남은 시간 표시 - 아날로그 시계
            Text(
              '오늘',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ).animate()
              .fadeIn(delay: 200.ms),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: AnalogClockWidget(
                  remainingTime: _remainingTime,
                  size: 220,
                ),
              ),
            ).animate()
              .fadeIn(delay: 300.ms)
              .scale(delay: 300.ms, duration: 500.ms),
            const SizedBox(height: 24),
            Text(
              '남았습니다',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ).animate()
              .fadeIn(delay: 400.ms),

            const Spacer(),

            // 완료 버튼
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _completeGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '목표 완료',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate()
              .fadeIn(delay: 500.ms)
              .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedState() {
    // 완료된 목표는 완료 화면으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompletedScreen()),
      );
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<void> _completeGoal() async {
    await GoalService.completeGoal();
    await AlarmService.cancelAllAlarms();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompletedScreen()),
      );
    }
  }
}

