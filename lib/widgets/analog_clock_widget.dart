import 'dart:math' as math;
import 'package:flutter/material.dart';

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
    // 오늘 자정까지의 전체 시간 (24시간)
    final totalHoursInDay = 24;
    
    // 남은 시간을 시간 단위로 변환 (0.0 ~ 24.0)
    final remainingHours = remainingTime.inHours + (remainingTime.inMinutes / 60.0);
    
    // 시계 바늘 각도 계산 (12시 방향이 0도, 시계 방향)
    // 남은 시간이 적을수록 바늘이 아래쪽(6시 방향)으로 이동
    final angle = (remainingHours / totalHoursInDay) * 2 * math.pi;
    // 12시 방향이 0도이므로 -90도 회전
    final adjustedAngle = angle - (math.pi / 2);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockPainter(adjustedAngle, remainingHours),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final double angle;
  final double remainingHours;

  _ClockPainter(this.angle, this.remainingHours);

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

    // 시계 바늘 그리기
    final handLength = radius * 0.7;
    final handEndX = center.dx + handLength * math.cos(angle);
    final handEndY = center.dy + handLength * math.sin(angle);

    final handPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, Offset(handEndX, handEndY), handPaint);

    // 중심점
    final centerPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 6, centerPaint);

    // 남은 시간 텍스트 표시
    final hours = remainingHours.toInt();
    final minutes = ((remainingHours - hours) * 60).toInt();
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
      Offset(
        center.dx - timeTextPainter.width / 2,
        center.dy + radius * 0.4,
      ),
    );
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.remainingHours != remainingHours;
  }
}

