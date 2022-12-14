import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedGradientExample extends StatelessWidget {
  const AnimatedGradientExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _AnimatedGradient(),
    );
  }
}

class _AnimatedGradient extends StatefulWidget {
  @override
  __AnimatedGradientState createState() => __AnimatedGradientState();
}

class __AnimatedGradientState extends State<_AnimatedGradient>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )
    ..addListener(() => setState(() {}))
    ..repeat();

  late final Animation<double> _animation =
      Tween(begin: -0.5, end: 1.5).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          height: 200,
          width: 200,
          child: CustomPaint(
            painter:
                _GradientPainter(tick: _animation.value), //_animation.value
          ),
        );
      },
    );
  }
}

class _GradientPainter extends CustomPainter {
  final double tick;

  _GradientPainter({required this.tick});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, size.height),
        Offset(size.width, 0),
        [Colors.red, Colors.yellowAccent, Colors.red],
        [tick - 0.3, tick, tick + 0.3],
      );

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientPainter oldPainter) =>
      tick != oldPainter.tick;
}
