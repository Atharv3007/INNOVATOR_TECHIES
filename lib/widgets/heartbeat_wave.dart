import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated heartbeat ECG-style wave at the top of the home screen
class HeartbeatWave extends StatefulWidget {
  const HeartbeatWave({super.key});

  @override
  State<HeartbeatWave> createState() => _HeartbeatWaveState();
}

class _HeartbeatWaveState extends State<HeartbeatWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF130808), AppTheme.bgCard, Color(0xFF130808)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _HeartbeatPainter(_controller.value),
            child: Container(),
          );
        },
      ),
    );
  }
}

class _HeartbeatPainter extends CustomPainter {
  final double progress;

  _HeartbeatPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    // Generate ECG-like path
    final points = _generateEcgPoints(w, midY, h);

    if (points.isEmpty) return;

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Draw with scroll effect using clipping
    final scrollOffset = progress * w;

    // Glow layer
    glowPaint.color = AppTheme.accentRed.withOpacity(0.25);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, w, h));
    canvas.translate(-scrollOffset, 0);
    canvas.drawPath(path, glowPaint);
    canvas.translate(w, 0);
    canvas.drawPath(path, glowPaint);
    canvas.restore();

    // Main line
    final gradient = LinearGradient(
      colors: [
        Colors.transparent,
        AppTheme.accentRed.withOpacity(0.3),
        AppTheme.accentRed,
        AppTheme.accentRedGlow,
        AppTheme.accentRed,
        AppTheme.accentRed.withOpacity(0.3),
        Colors.transparent,
      ],
      stops: const [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
    );

    paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, w, h));
    canvas.translate(-scrollOffset, 0);
    canvas.drawPath(path, paint);
    canvas.translate(w, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  List<Offset> _generateEcgPoints(double w, double midY, double h) {
    final List<Offset> points = [];
    const int segments = 2; // repeat pattern twice for seamless scroll

    for (int s = 0; s < segments; s++) {
      final baseX = s * w;

      // Flat line
      for (double x = 0; x <= w * 0.3; x += 4) {
        points.add(Offset(baseX + x, midY));
      }

      // P wave (small bump)
      final pStart = w * 0.3;
      for (double x = 0; x <= w * 0.06; x += 2) {
        final y = midY - 6 * math.sin((x / (w * 0.06)) * math.pi);
        points.add(Offset(baseX + pStart + x, y));
      }

      // PR segment (flat)
      final prStart = pStart + w * 0.06;
      for (double x = 0; x <= w * 0.04; x += 2) {
        points.add(Offset(baseX + prStart + x, midY));
      }

      // QRS complex
      final qrsStart = prStart + w * 0.04;
      // Q dip
      points.add(Offset(baseX + qrsStart, midY));
      points.add(Offset(baseX + qrsStart + w * 0.012, midY + h * 0.12));
      // R spike (tall)
      points.add(Offset(baseX + qrsStart + w * 0.025, midY - h * 0.38));
      // S dip
      points.add(Offset(baseX + qrsStart + w * 0.04, midY + h * 0.08));
      points.add(Offset(baseX + qrsStart + w * 0.055, midY));

      // ST segment
      final stStart = qrsStart + w * 0.055;
      for (double x = 0; x <= w * 0.06; x += 2) {
        points.add(Offset(baseX + stStart + x, midY));
      }

      // T wave
      final tStart = stStart + w * 0.06;
      for (double x = 0; x <= w * 0.1; x += 2) {
        final y = midY - 12 * math.sin((x / (w * 0.1)) * math.pi);
        points.add(Offset(baseX + tStart + x, y));
      }

      // Flat line to end
      final flatStart = tStart + w * 0.1;
      final remaining = w - flatStart;
      for (double x = 0; x <= remaining; x += 4) {
        points.add(Offset(baseX + flatStart + x, midY));
      }
    }

    return points;
  }

  @override
  bool shouldRepaint(_HeartbeatPainter old) => old.progress != progress;
}
