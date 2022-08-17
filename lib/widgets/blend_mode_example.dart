import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BlendModeExample extends StatelessWidget {
  const BlendModeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 300,
            height: 200,
            child: CustomPaint(painter: BlendModePainter()),
            // child: ImageBlendModeExample(),
          ),
        ),
      ),
    );
  }
}

class BlendModePainter extends CustomPainter {
  const BlendModePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final circle = Path()..addOval(Offset.zero & (size / 2));
    canvas.drawPath(circle, Paint()..color = Colors.yellow);

    final rectangle = Path()
      ..addRect(Offset(size.width / 4, size.height / 4) & (size / 2));
    canvas.drawPath(
      rectangle,
      Paint()
        ..color = Colors.blue
        ..blendMode = BlendMode.modulate,
    );
  }

  @override
  bool shouldRepaint(covariant BlendModePainter oldDelegate) {
    return false;
  }
}

class ImageBlendModeExample extends StatefulWidget {
  const ImageBlendModeExample({Key? key}) : super(key: key);

  @override
  _ImageBlendModeExampleState createState() => _ImageBlendModeExampleState();
}

class _ImageBlendModeExampleState extends State<ImageBlendModeExample> {
  late Future<ui.Image> _imageFuture;

  @override
  void initState() {
    super.initState();

    _imageFuture = _loadImage();
  }

  Future<ui.Image> _loadImage() async {
    final bytes = await rootBundle.load('assets/image.jpg');
    final list = bytes.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(list);
    return (await codec.getNextFrame()).image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imageFuture,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (!snapshot.hasData) return Container();

        return SizedBox(
          width: 200,
          height: 300,
          child: CustomPaint(
            painter: ImageFilterPainter(snapshot.data!),
          ),
        );
      },
    );
  }
}

class ImageFilterPainter extends CustomPainter {
  final ui.Image image;

  ImageFilterPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final imagePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      );

    final filterPaint = Paint()..color = Colors.red
        ..blendMode = BlendMode.saturation
        // ..blendMode = BlendMode.softLight
        // ..blendMode = BlendMode.difference
        ;

    canvas.drawRect(Offset.zero & size, imagePaint);
    canvas.drawRect(Offset.zero & size, filterPaint);
  }

  @override
  bool shouldRepaint(covariant ImageFilterPainter oldDelegate) =>
      image != oldDelegate.image;
}
