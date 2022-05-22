import 'package:flutter/material.dart';

/// Displays a page's body and appbar
class PerthleScaffold extends StatelessWidget {
  const PerthleScaffold({
    final Key? key,
    required this.appBar,
    required this.body,
  }) : super(key: key);

  final Widget appBar;
  final Widget body;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        Expanded(child: appBar),
        Expanded(flex: 11, child: body),
      ],
    );
  }
}
