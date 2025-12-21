import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/goal.dart';
import '../../../../services/goal_service.dart';
import '../../../../shared/services/alarm_service.dart';
import '../../../../shared/services/widget_service.dart';
import '../../../../localization/app_localizations.dart';
import '../../domain/providers/goal_provider.dart';
import 'create_goal_screen.dart';
import 'completed_screen.dart';
import 'failed_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  int _lastUpdatedMinute = -1; // 위젯 업데이트를 위한 마지막 업데이트 분
  static const Color _teal = Color(0xFF0B8080);

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initializeAlarmService();
    // Provider를 통해 목표 로드 (ref는 build 이후에 안전하게 사용 가능)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(goalProvider.notifier).loadGoal();
      }
    });
  }

  Future<void> _initializeAlarmService() async {
    await AlarmService.initialize();
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
    // Provider에서 목표 가져오기
    final goalState = ref.read(goalProvider);
    final currentGoal = goalState.goal;
    if (currentGoal == null) return;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0);
    _remainingTime = midnight.difference(now);

    // 1분마다 위젯 업데이트 (너무 자주 업데이트하지 않기 위해)
    final currentMinute = now.minute;
    if (currentMinute != _lastUpdatedMinute) {
      _lastUpdatedMinute = currentMinute;
      WidgetService.updateWidget(currentGoal);
    }

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
    // GoalProvider 읽기
    final goalState = ref.watch(goalProvider);

    // 로딩 중일 때는 로딩 인디케이터 표시 (Provider 값 사용)
    if (goalState.isLoading) {
      return _buildLoadingState();
    }

    // 목표 가져오기 (Provider 값 사용)
    final currentGoal = goalState.goal;

    // 목표가 없거나 완료된 경우
    if (currentGoal == null) {
      return _buildEmptyState();
    }

    // 목표가 완료된 경우
    if (currentGoal.completed) {
      return _buildCompletedState();
    }

    // 목표가 있는 경우
    return _buildGoalState(currentGoal);
  }

  Widget _buildLoadingState() {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    final dateText = _formatHeaderDate(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Date header
              Text(
                dateText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 52,
                  height: 1.05,
                  fontWeight: FontWeight.w500,
                  color: _teal,
                  letterSpacing: -1.2,
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.08, end: 0),
              const SizedBox(height: 12),
              Text(
                l10n.readyForToday,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.2,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 300.ms),

              const SizedBox(height: 16),

              // Big clock graphic
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ClockFocusGraphic()
                        .animate()
                        .fadeIn(delay: 120.ms, duration: 450.ms)
                        .scale(
                          begin: const Offset(0.98, 0.98),
                          end: const Offset(1, 1),
                        ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.noGoalSetToday,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
                    const SizedBox(height: 4),
                    Text(
                      l10n.clearMindDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ).animate().fadeIn(delay: 260.ms, duration: 350.ms),
                  ],
                ),
              ),

              // Tooltip + button
              const SizedBox(height: 8),
              _StartHereTooltip(text: l10n.startHere)
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 300.ms)
                  .slideY(begin: 0.15, end: 0),
              const SizedBox(height: 8),
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
                      ref.read(goalProvider.notifier).loadGoal();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: _teal, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        l10n.defineYourFocus,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 420.ms, duration: 320.ms),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBarEmptyState(l10n),
    );
  }

  Widget _buildBottomBarEmptyState(AppLocalizations l10n) {
    return SafeArea(
      top: false,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BottomNavItem(
              icon: Icons.home_rounded,
              label: l10n.home,
              isActive: true,
              activeColor: _teal,
            ),
          ],
        ),
      ),
    );
  }

  String _formatHeaderDate(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;

    // 이미지와 동일한 스타일 우선 (en: Monday,\nOct 24)
    const weekdaysEn = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const monthsEn = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (locale == 'ko') {
      // 한국어는 자연스러운 포맷으로 표시
      const weekdaysKo = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
      final weekday = weekdaysKo[now.weekday - 1];
      return '${now.month}월 ${now.day}일\n$weekday';
    }

    final weekday = weekdaysEn[now.weekday - 1];
    final month = monthsEn[now.month - 1];
    return '$weekday,\n$month ${now.day}';
  }

  String _formatGoalHeaderDate(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).languageCode;

    if (locale == 'ko') {
      // 한국어는 자연스러운 한 줄 포맷
      const weekdaysKo = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
      const monthsKo = [
        '1월',
        '2월',
        '3월',
        '4월',
        '5월',
        '6월',
        '7월',
        '8월',
        '9월',
        '10월',
        '11월',
        '12월',
      ];
      final weekday = weekdaysKo[now.weekday - 1];
      final month = monthsKo[now.month - 1];
      return '$month ${now.day}일 $weekday';
    }

    // 이미지와 동일한 영어 스타일: Tuesday, October 24
    const weekdaysEn = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const monthsEn = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final weekday = weekdaysEn[now.weekday - 1];
    final month = monthsEn[now.month - 1];
    return '$weekday, $month ${now.day}';
  }

  String _formatHms(Duration d) {
    final total = d.inSeconds;
    if (total <= 0) return '00:00:00';
    final h = (total ~/ 3600).toString().padLeft(2, '0');
    final m = ((total % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (total % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Widget _buildGoalState(Goal currentGoal) {
    final l10n = AppLocalizations.of(context)!;
    final headerDate = _formatGoalHeaderDate(context);
    final timeText = _formatHms(_remainingTime);

    // 원형 링 진행률 (자정까지 남은 시간을 24시간 기준으로 표시)
    final totalSeconds = const Duration(hours: 24).inSeconds.toDouble();
    final remainingSeconds = _remainingTime.inSeconds
        .clamp(0, totalSeconds.toInt())
        .toDouble();
    final progress = (1 - (remainingSeconds / totalSeconds)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단 헤더: 날짜
              Center(
                child: Text(
                  headerDate,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // IN PROGRESS 배지
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6F5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 18, color: _teal),
                      const SizedBox(width: 10),
                      Text(
                        l10n.inProgress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _teal,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // TODAY'S FOCUS
              Center(
                child: Text(
                  l10n.todaysFocus,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 목표 타이틀
              Center(
                child: Text(
                  currentGoal.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -1.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 26),

              // 원형 타이머
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 320,
                    height: 320,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 320,
                          height: 320,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: const Color(0xFFE5E7EB),
                            color: _teal,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              timeText,
                              style: const TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: -1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.timeRemaining,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 문구(이미지와 동일한 형태)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  l10n.goalQuote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 완료 버튼 (Mark as Complete)
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: _completeGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        l10n.markAsComplete,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
    // 완료된 목표로 위젯 업데이트 (Provider에서 가져오기)
    final goalState = ref.read(goalProvider);
    final completedGoal = goalState.goal?.copyWith(completed: true);
    await WidgetService.updateWidget(completedGoal);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompletedScreen()),
      );
    }
  }
}

class _ClockFocusGraphic extends StatelessWidget {
  static const Color _teal = Color(0xFF0B8080);

  const _ClockFocusGraphic();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEAF6F5),
            boxShadow: [
              BoxShadow(
                color: _teal.withOpacity(0.10),
                blurRadius: 24,
                spreadRadius: 3,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),
        Container(
          width: 156,
          height: 156,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: _teal.withOpacity(0.06), width: 2),
          ),
        ),
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF9CC9C6),
          ),
          child: const Icon(
            Icons.access_time_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class _StartHereTooltip extends StatelessWidget {
  final String text;

  const _StartHereTooltip({required this.text});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF3A3A3A);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        CustomPaint(
          size: const Size(18, 10),
          painter: _TrianglePainter(color: bg),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : Colors.grey.shade400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
