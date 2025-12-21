import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../data/models/goal.dart';
import '../../../../localization/app_localizations.dart';
import '../../domain/providers/goal_provider.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final TextEditingController _goalController = TextEditingController();
  List<int> _selectedAlarms = [];

  bool _alarmEnabled = false;
  int _alarmHours = 1;
  int _alarmMinutes = 30;
  final List<Map<String, int>> _alarms = []; // [{hours: 1, minutes: 30}, ...]

  static const Color _teal = Color(0xFF0B8080);
  static const Color _pageBg = Color(0xFFF6F7F8);

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

  void _resetForm() {
    setState(() {
      _goalController.clear();
      _alarmEnabled = false;
      _selectedAlarms = [];
      _alarms.clear();
      _alarmHours = 1;
      _alarmMinutes = 30;
    });
  }

  void _updateAlarmList() {
    _selectedAlarms = _alarms.map((alarm) {
      return alarm['hours']! * 60 + alarm['minutes']!;
    }).toList();
  }

  void _addAlarmFromPicker() {
    final l10n = AppLocalizations.of(context)!;

    if (!_alarmEnabled) return;

    // 중복 체크
    final isDuplicate = _alarms.any(
      (alarm) =>
          alarm['hours'] == _alarmHours && alarm['minutes'] == _alarmMinutes,
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.duplicateAlarm),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // 0시간 0분 체크
    if (_alarmHours == 0 && _alarmMinutes == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectTime),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // 자정 기준으로 현재 남은 시간보다 더 큰 값은 선택 불가
    final remainingMinutes = _getRemainingTimeUntilMidnight().inMinutes;
    final selectedMinutes = _alarmHours * 60 + _alarmMinutes;

    if (selectedMinutes > remainingMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.timeExceedsRemaining),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _alarms.add({'hours': _alarmHours, 'minutes': _alarmMinutes});
      _updateAlarmList();
    });
  }

  void _removeAlarm(int index) {
    setState(() {
      _alarms.removeAt(index);
      _updateAlarmList();
    });
  }

  void _createGoal() async {
    final l10n = AppLocalizations.of(context)!;
    if (_goalController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.goalNameRequired)));
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

    // Provider를 통해 목표 저장 (이미 목표가 있는지 확인, 저장, 알람 스케줄링, 위젯 업데이트 모두 포함)
    final success = await ref
        .read(goalProvider.notifier)
        .saveGoal(goal, _selectedAlarms);

    if (!success) {
      // 이미 목표가 있는 경우
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.goalAlreadyExists)));
      }
      return;
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remaining = _getRemainingTimeUntilMidnight();
    final hoursRemaining = remaining.inHours;
    final minutesRemaining = remaining.inMinutes % 60;

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: _pageBg,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.createGoal),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: _CircleIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _CircleIconButton(
              icon: Icons.history_toggle_off_rounded,
              onPressed: _resetForm,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 목표 입력 카드
            _SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        l10n.myGoal,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _teal,
                          letterSpacing: 0.6,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF6F5),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: _teal,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${l10n.remainingTime}: '
                              '$hoursRemaining${l10n.hours} '
                              '${minutesRemaining.toString().padLeft(2, '0')}${l10n.minutes}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _teal,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _goalController,
                    maxLength: 50,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.35,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      letterSpacing: -0.2,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: l10n.myGoalQuestion,
                      hintStyle: TextStyle(
                        fontSize: 18,
                        height: 1.35,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.edit, color: Colors.grey.shade300),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 120.ms, duration: 260.ms),

            const SizedBox(height: 18),

            // 알람 추가 시간 (상시 표시)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6F5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    l10n.goalTime,
                    style: const TextStyle(
                      color: _teal,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.alarmTimeDescription,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 180.ms, duration: 220.ms),
            const SizedBox(height: 12),
            _AlarmTimePickerCard(
              hours: _alarmHours,
              minutes: _alarmMinutes,
              onHoursChanged: (h) => setState(() => _alarmHours = h),
              onMinutesChanged: (m) => setState(() => _alarmMinutes = m),
            ).animate().fadeIn(delay: 220.ms, duration: 260.ms),

            const SizedBox(height: 18),

            // 알람 설정 + 토글
            Row(
              children: [
                Text(
                  l10n.alarmSetting,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.alarmActivation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Switch.adaptive(
                  value: _alarmEnabled,
                  activeColor: _teal,
                  onChanged: (v) {
                    setState(() {
                      _alarmEnabled = v;
                      if (!v) {
                        _selectedAlarms = [];
                        _alarms.clear();
                      }
                    });
                  },
                ),
              ],
            ).animate().fadeIn(delay: 260.ms, duration: 240.ms),
            const SizedBox(height: 10),

            AnimatedCrossFade(
              crossFadeState: _alarmEnabled
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 220),
              firstChild: _AlarmListWidget(
                alarms: _alarms,
                onRemove: _removeAlarm,
                onAdd: _addAlarmFromPicker,
              ),
              secondChild: const SizedBox.shrink(),
            ),

            // 목표 생성 버튼
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: _teal.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _createGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow_rounded, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      l10n.createGoalButton,
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
            // 하단 여백
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.75),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final Widget child;

  const _SoftCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B8080).withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AlarmTimePickerCard extends StatelessWidget {
  final int hours;
  final int minutes;
  final ValueChanged<int> onHoursChanged;
  final ValueChanged<int> onMinutesChanged;

  const _AlarmTimePickerCard({
    required this.hours,
    required this.minutes,
    required this.onHoursChanged,
    required this.onMinutesChanged,
  });

  static const Color _teal = Color(0xFF0B8080);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: _teal.withOpacity(0.08),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 시간
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.hours,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B8080).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: NumberPicker(
                      value: hours,
                      minValue: 0,
                      maxValue: 23,
                      itemHeight: 60,
                      itemWidth: 80,
                      axis: Axis.vertical,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade400,
                      ),
                      selectedTextStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B8080),
                      ),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: const Color(0xFF0B8080).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: onHoursChanged,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            // 분
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.minutes,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A6B6B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: NumberPicker(
                      value: minutes,
                      minValue: 0,
                      maxValue: 59,
                      itemHeight: 60,
                      itemWidth: 80,
                      axis: Axis.vertical,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade400,
                      ),
                      selectedTextStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A6B6B),
                      ),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: const Color(0xFF0A6B6B).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: onMinutesChanged,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlarmListWidget extends StatelessWidget {
  final List<Map<String, int>> alarms;
  final void Function(int index) onRemove;
  final VoidCallback onAdd;

  const _AlarmListWidget({
    required this.alarms,
    required this.onRemove,
    required this.onAdd,
  });

  static const Color _teal = Color(0xFF0B8080);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (alarms.isNotEmpty)
          ...List.generate(alarms.length, (index) {
            final alarm = alarms[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6F5).withOpacity(0.55),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _teal.withOpacity(0.22)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _teal.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: _teal,
                    size: 22,
                  ),
                ),
                title: Text(
                  l10n.alarmBefore(alarm['hours']!, alarm['minutes']!),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                subtitle: Text(
                  l10n.goalEndAlarm,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade500),
                  onPressed: () => onRemove(index),
                ),
              ),
            ).animate().fadeIn(duration: 220.ms).slideX(begin: -0.05, end: 0);
          }),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onAdd,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              side: BorderSide(color: _teal.withOpacity(0.35), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              backgroundColor: Colors.white,
              foregroundColor: _teal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: _teal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.addAlarm,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 220.ms),
      ],
    );
  }
}
