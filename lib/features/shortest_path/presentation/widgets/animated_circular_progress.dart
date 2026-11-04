
import 'package:flutter/material.dart';

class AnimatedCircularProgress extends StatefulWidget {
  final double progress;
  final VoidCallback? onCompleted;

  const AnimatedCircularProgress({
    super.key,
    required this.progress,
    this.onCompleted,
  });

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState
    extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animateToProgress(widget.progress);
  }

  @override
  void didUpdateWidget(covariant AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      _animateToProgress(widget.progress);
    }
  }

  void _animateToProgress(double progress) {
    final target = progress.clamp(0.0, 1.0).toDouble();

    _controller.animateTo(
      target,
      duration: Duration(
        milliseconds: target >= 1.0 ? 1200 : 400,
      ),
      curve: Curves.easeInOut,
    ).then((_) {
      if (!mounted) return;

      if (target >= 1.0 && _controller.value >= 1.0) {
        widget.onCompleted?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final percentage = (_controller.value * 100).round();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 4,
                color: Colors.blue,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        );
      },
    );
  }
}