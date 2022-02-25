import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:perthle/controller/authenticator_controller.dart';

class Authenticator extends StatelessWidget {
  const Authenticator({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static AuthenticatorController of(BuildContext context) {
    // Retrieve the AuthenticatorController from the widget tree using
    // provider
    return Provider.of<AuthenticatorController>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Place a new AuthenticatorController in this place in the widget tree
    // using provider
    return Provider.value(
      value: AuthenticatorController(),
      child: child,
    );
  }
}
