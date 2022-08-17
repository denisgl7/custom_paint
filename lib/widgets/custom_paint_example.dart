import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomPaintExample extends StatelessWidget {
  const CustomPaintExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _buildSquare(),
            // _buildRectangle(),
      ),
    );
  }

  Widget _buildSquare() {
    return const CustomPaint(
      painter: SimpleSquarePainter(),
    );
  }

  Widget _buildRectangle() {
    return const SizedBox(
      width: 300,
      height: 200,
      child: CustomPaint(
        painter: AdvancedRectanglePainter(color: Colors.cyan),
      ),
    );
  }
}

class SimpleSquarePainter extends CustomPainter {
  const SimpleSquarePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(10, 10);
    path.lineTo(100, 10);
    path.lineTo(100, 100);
    path.lineTo(10, 100);
    path.close();

    final paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xffff0000);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AdvancedRectanglePainter extends CustomPainter {
  final Color color;

  const AdvancedRectanglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AdvancedRectanglePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
