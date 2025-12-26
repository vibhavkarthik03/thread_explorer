import 'package:flutter/material.dart';

class IndentLines extends StatelessWidget {
  final int depth;
  final double indentWidth;
  final Widget child;

  const IndentLines({
    super.key,
    required this.depth,
    required this.child,
    this.indentWidth = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _IndentPainter(
              depth: depth,
              indentWidth: indentWidth,
              lineColor: Colors.red,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: depth * indentWidth),
          child: child,
        )
      ],
    );
  }
}

class _IndentPainter extends CustomPainter {
  final int depth;
  final double indentWidth;
  final Color lineColor;

  _IndentPainter({
    required this.depth,
    required this.indentWidth,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.1;

    for (int i = 0; i < depth; i++) {
      final x = (i * indentWidth) + indentWidth / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
