import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

class ShakeController {
  ShakeController({required this.vsync}) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
  }

  double get offset => animation.value;

  double get progress => offset / maxOffset;

  static double maxOffset = 24.0;

  final TickerProvider vsync;

  late final AnimationController _controller;

  late final Animation<double> animation = Tween(begin: 0.0, end: maxOffset)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_controller)
    ..addStatusListener(
      (final status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      },
    );

  void shake() {
    _controller.forward(from: 0.0);
  }

  void dispose() {
    _controller.dispose();
  }
}
