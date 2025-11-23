import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/goal_service.dart';
import '../services/alarm_service.dart';
import 'home_screen.dart';

class FailedScreen extends StatefulWidget {
  const FailedScreen({super.key});

  @override
  State<FailedScreen> createState() => _FailedScreenState();
}

class _FailedScreenState extends State<FailedScreen> {
  @override
  void initState() {
    super.initState();
    _cleanup();
  }

  Future<void> _cleanup() async {
    // 실패한 목표 삭제 및 알람 취소
    await GoalService.deleteGoal();
    await AlarmService.cancelAllAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('One Today'),
        automaticallyImplyLeading: false,
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
                      Colors.orange.shade300,
                      Colors.orange.shade500,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ).animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .then()
                .shake(hz: 2, duration: 400.ms),
              const SizedBox(height: 40),
              const Text(
                '시간이 지났어요',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(delay: 300.ms)
                .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 16),
              Text(
                '오늘의 목표를 완료하지 못했습니다',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(delay: 400.ms),
              const SizedBox(height: 8),
              Text(
                '괜찮아요! 내일 다시 도전해봐요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(delay: 500.ms),
              const SizedBox(height: 48),
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
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 18,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate()
                .fadeIn(delay: 600.ms)
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}


