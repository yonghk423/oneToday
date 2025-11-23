import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnalogClockWidget extends StatelessWidget {
  final Duration remainingTime;
  final double size;

  const AnalogClockWidget({
    super.key,
    required this.remainingTime,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    // 남은 시간 계산
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes % 60;

    // 시침 각도: 시간을 12시간 형식으로 변환 (0-12시)
    final hour12 = hours % 12;
    final hourAngle =
        (hour12 * 30 + minutes * 0.5) * math.pi / 180; // 시침은 분에 따라 조금씩 이동
    final hourAdjustedAngle = hourAngle - (math.pi / 2); // 12시 방향이 0도

    // 분침 각도: 분을 60분 형식으로 변환
    final minuteAngle = (minutes * 6) * math.pi / 180; // 1분 = 6도
    final minuteAdjustedAngle = minuteAngle - (math.pi / 2); // 12시 방향이 0도

    return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ClockPainter(
              hourAdjustedAngle,
              minuteAdjustedAngle,
              hours,
              minutes,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(
          delay: 200.ms,
          duration: 500.ms,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
        );
  }
}

class _ClockPainter extends CustomPainter {
  final double hourAngle;
  final double minuteAngle;
  final int hours;
  final int minutes;

  _ClockPainter(this.hourAngle, this.minuteAngle, this.hours, this.minutes);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 시계 외곽 원 그리기
    final outlinePaint = Paint()
      ..color = Colors.blue.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius - 2, outlinePaint);

    // 시계 배경
    final backgroundPaint = Paint()
      ..color = Colors.blue.shade50
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius - 2, backgroundPaint);

    // 시간 표시 (12, 3, 6, 9시)
    final hourMarkPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 12; i++) {
      final hourAngle = (i * 30 - 90) * math.pi / 180;
      final startX = center.dx + (radius - 15) * math.cos(hourAngle);
      final startY = center.dy + (radius - 15) * math.sin(hourAngle);
      final endX = center.dx + (radius - 5) * math.cos(hourAngle);
      final endY = center.dy + (radius - 5) * math.sin(hourAngle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        hourMarkPaint,
      );
    }

    // 숫자 표시 (12, 3, 6, 9)
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final numbers = ['12', '3', '6', '9'];
    for (int i = 0; i < 4; i++) {
      final hourAngle = (i * 90 - 90) * math.pi / 180;
      final textX = center.dx + (radius - 25) * math.cos(hourAngle);
      final textY = center.dy + (radius - 25) * math.sin(hourAngle);

      textPainter.text = TextSpan(
        text: numbers[i],
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
      );
    }

    // 시침 그리기 (짧고 두꺼운 바늘, 더 진한 색상)
    final hourHandLength = radius * 0.5;
    final hourHandEndX = center.dx + hourHandLength * math.cos(hourAngle);
    final hourHandEndY = center.dy + hourHandLength * math.sin(hourAngle);

    final hourHandPaint = Paint()
      ..color = Colors.blue.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, Offset(hourHandEndX, hourHandEndY), hourHandPaint);

    // 분침 그리기 (길고 얇은 바늘)
    final minuteHandLength = radius * 0.7;
    final minuteHandEndX = center.dx + minuteHandLength * math.cos(minuteAngle);
    final minuteHandEndY = center.dy + minuteHandLength * math.sin(minuteAngle);

    final minuteHandPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(minuteHandEndX, minuteHandEndY),
      minuteHandPaint,
    );

    // 중심점
    final centerPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 6, centerPaint);

    // 남은 시간 텍스트 표시
    final timeText = hours > 0 ? '$hours시간 ${minutes}분' : '$minutes분';

    final timeTextPainter = TextPainter(
      text: TextSpan(
        text: timeText,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    timeTextPainter.layout();
    timeTextPainter.paint(
      canvas,
      Offset(center.dx - timeTextPainter.width / 2, center.dy + radius * 0.4),
    );
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) {
    return oldDelegate.hourAngle != hourAngle ||
        oldDelegate.minuteAngle != minuteAngle ||
        oldDelegate.hours != hours ||
        oldDelegate.minutes != minutes;
  }
}
