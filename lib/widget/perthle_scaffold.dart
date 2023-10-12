import 'package:flutter/material.dart';

/// Displays a page's body and appbar
class PerthleScaffold extends StatelessWidget {
  const PerthleScaffold({
    super.key,
    required this.appBar,
    required this.body,
  });

  final PreferredSizeWidget appBar;
  final Widget body;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
