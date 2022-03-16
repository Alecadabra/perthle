import 'package:flutter/widgets.dart';

class PerthleNavigator {
  PerthleNavigator({required this.pageController});

  final PageController pageController;

  static const Duration _duration = Duration(milliseconds: 600);
  static const Curve _curve = Curves.easeOutBack;

  void toPerthle() {
    pageController.animateToPage(0, duration: _duration, curve: _curve);
  }

  void toSettings() {
    pageController.animateToPage(1, duration: _duration, curve: _curve);
  }
}
