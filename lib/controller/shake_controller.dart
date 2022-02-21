import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

class ShakeController {
  ShakeController({required this.vsync}) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: vsync,
    );
  }

  double get offset => animation.value;

  final TickerProvider vsync;

  late final AnimationController _controller;

  late final Animation<double> animation = Tween(begin: 0.0, end: 24.0)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_controller)
    ..addStatusListener(
      (status) {
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
