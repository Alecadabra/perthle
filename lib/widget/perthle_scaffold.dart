import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: appBar),
          Expanded(flex: 10, child: body),
        ],
      ),
    );
  }
}
