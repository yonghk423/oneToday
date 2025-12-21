import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../localization/app_localizations.dart';

class AlarmSettingWidget extends StatefulWidget {
  final Function(List<int>) onAlarmChanged;

  const AlarmSettingWidget({super.key, required this.onAlarmChanged});

  @override
  State<AlarmSettingWidget> createState() => _AlarmSettingWidgetState();
}

class _AlarmSettingWidgetState extends State<AlarmSettingWidget> {
  final List<Map<String, int>> _alarms = []; // [{hours: 1, minutes: 30}, ...]

  void _addAlarm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AlarmTimePickerSheet(
        onTimeSelected: (hours, minutes) {
          // 중복 체크: 같은 시간(시간+분)이 이미 있는지 확인
          final isDuplicate = _alarms.any(
            (alarm) => alarm['hours'] == hours && alarm['minutes'] == minutes,
          );

          if (isDuplicate) {
            final l10n = AppLocalizations.of(context)!;
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

          setState(() {
            _alarms.add({'hours': hours, 'minutes': minutes});
            _updateAlarmList();
          });
        },
      ),
    );
  }

  void _removeAlarm(int index) {
    setState(() {
      _alarms.removeAt(index);
      _updateAlarmList();
    });
  }

  void _updateAlarmList() {
    final alarmMinutes = _alarms.map((alarm) {
      return alarm['hours']! * 60 + alarm['minutes']!;
    }).toList();
    widget.onAlarmChanged(alarmMinutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.alarmSetting,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.optional,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 알람 목록
        if (_alarms.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade50, Colors.grey.shade100],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_none,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.noAlarmSet,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        else
          ...List.generate(_alarms.length, (index) {
            final alarm = _alarms[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0B8080).withOpacity(0.1),
                    const Color(0xFF0A6B6B).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0B8080).withOpacity(0.3),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B8080).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Color(0xFF0B8080),
                    size: 24,
                  ),
                ),
                title: Text(
                  l10n.alarmBefore(alarm['hours']!, alarm['minutes']!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.untilMidnightBased,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeAlarm(index),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0);
          }),
        const SizedBox(height: 16),
        // 알람 추가 버튼
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addAlarm,
            icon: const Icon(Icons.add_alarm),
            label: Text(l10n.addAlarm, style: const TextStyle(fontSize: 16)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: const Color(0xFF0B8080).withOpacity(0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 알람 시간 선택 바텀시트
class _AlarmTimePickerSheet extends StatefulWidget {
  final Function(int hours, int minutes) onTimeSelected;

  const _AlarmTimePickerSheet({required this.onTimeSelected});

  @override
  State<_AlarmTimePickerSheet> createState() => _AlarmTimePickerSheetState();
}

class _AlarmTimePickerSheetState extends State<_AlarmTimePickerSheet> {
  int _hours = 1;
  int _minutes = 30;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 드래그 핸들
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // 타이틀
            Text(
              l10n.alarmTimeSetting,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.untilMidnightBased,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            // 시간 선택기
            Container(
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
                            value: _hours,
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
                                  color: const Color(
                                    0xFF0B8080,
                                  ).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) =>
                                setState(() => _hours = value),
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
                            value: _minutes,
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
                                  color: const Color(
                                    0xFF0A6B6B,
                                  ).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) =>
                                setState(() => _minutes = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // 선택된 시간이 0시간 0분인 경우
                        if (_hours == 0 && _minutes == 0) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              final dialogL10n = AppLocalizations.of(
                                dialogContext,
                              )!;
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                content: Text(
                                  dialogL10n.selectTime,
                                  textAlign: TextAlign.center,
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(),
                                    child: Text(dialogL10n.confirm),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        // 자정 기준으로 현재 남은 시간보다 더 큰 값은 선택 불가
                        final now = DateTime.now();
                        final midnight = DateTime(
                          now.year,
                          now.month,
                          now.day + 1,
                          0,
                          0,
                        );
                        final remainingMinutes = midnight
                            .difference(now)
                            .inMinutes;
                        final selectedMinutes = _hours * 60 + _minutes;

                        if (selectedMinutes > remainingMinutes) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              final dialogL10n = AppLocalizations.of(
                                dialogContext,
                              )!;
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                content: Text(
                                  dialogL10n.timeExceedsRemaining,
                                  textAlign: TextAlign.center,
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(),
                                    child: Text(dialogL10n.confirm),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        widget.onTimeSelected(_hours, _minutes);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B8080),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.confirm,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.2, end: 0);
  }
}
