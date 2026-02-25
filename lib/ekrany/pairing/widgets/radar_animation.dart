import 'package:flutter/material.dart';

class RadarAnimation extends StatefulWidget {
  final bool isScanning;
  final double size;

  const RadarAnimation({
    super.key,
    required this.isScanning,
    this.size = 180,
  });

  @override
  State<RadarAnimation> createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<RadarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.isScanning) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RadarAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isScanning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isScanning && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _RadarPainter(
              progress: _controller.value,
              color: primaryColor,
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RadarPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width / 2;

    const circleCount = 3;

    for (int i = 0; i < circleCount; i++) {
      final delayedProgress = (progress + i / circleCount) % 1.0;
      final radius = maxRadius * delayedProgress;
      final opacity = (1 - delayedProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withOpacity(0.4 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }
  

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}