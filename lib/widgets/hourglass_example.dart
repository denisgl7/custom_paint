import 'dart:math' as math;
import 'package:flutter/material.dart';

class HourglassExample extends StatefulWidget {
  const HourglassExample({Key? key}) : super(key: key);

  @override
  _HourglassExampleState createState() => _HourglassExampleState();
}

class _HourglassExampleState extends State<HourglassExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  )
    ..addListener(() => setState(() {}))
    ..repeat();

  late final Animation<double> _pouringAnimation = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.9),
  );

  late final Animation<double> _rotationAnimation =
      Tween(begin: 0.0, end: 0.5).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.9, 1.0, curve: Curves.fastOutSlowIn),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: CustomPaint(
            painter: HourGlassPainter(
              poured: _pouringAnimation.value,
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}

class HourGlassPainter extends CustomPainter {
  final double poured;
  final Paint _paint;
  final Paint _powderPaint;

  HourGlassPainter({required this.poured, required Color color})
      : _paint = Paint()
          ..style = PaintingStyle.stroke
          ..color = color,
        _powderPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final halfHeight = size.height / 2;
    final hourglassWidth = math.min(centerX * 0.8, halfHeight);
    final gapWidth = math.max(3.0, hourglassWidth * 0.05);
    final yPadding = gapWidth / 2;
    final top = yPadding;
    final bottom = size.height - yPadding;
    _paint.strokeWidth = gapWidth;

    final hourglassPath = Path()
      ..moveTo(centerX - hourglassWidth, top)
      ..lineTo(centerX + hourglassWidth, top)
      ..lineTo(centerX + gapWidth, halfHeight)
      ..lineTo(centerX + hourglassWidth, bottom)
      ..lineTo(centerX - hourglassWidth, bottom)
      ..lineTo(centerX - gapWidth, halfHeight)
      ..close();
    canvas.drawPath(hourglassPath, _paint);

    final upperPartRect = Rect.fromLTRB(
      0.0,
      halfHeight * poured,
      size.width,
      halfHeight,
    );
    final upperPart = Path()
      ..moveTo(0.0, top)
      ..addRect(upperPartRect);
    canvas.drawPath(
      Path.combine(
        PathOperation.intersect,
        hourglassPath,
        upperPart,
      ),
      _powderPaint,
    );

    final lowerPartPath = Path()
      ..moveTo(centerX, bottom)
      ..relativeLineTo(hourglassWidth * poured, 0.0)
      ..lineTo(centerX, bottom - poured * halfHeight - gapWidth)
      ..lineTo(centerX - hourglassWidth * poured, bottom)
      ..close();
    final lowerPartRectPath = Path()
      ..addRect(
        Rect.fromLTRB(0.0, halfHeight, size.width, size.height),
      );
    final lowerPart = Path.combine(
      PathOperation.intersect,
      lowerPartPath,
      lowerPartRectPath,
    );
    canvas.drawPath(lowerPart, _powderPaint);

    canvas.drawLine(
      Offset(centerX, halfHeight),
      Offset(centerX, bottom),
      _paint,
    );
  }

  @override
  bool shouldRepaint(HourGlassPainter oldDelegate) => true;
}
