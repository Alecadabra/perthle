import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:perthle/widget/perthle_appbar.dart';
import 'package:perthle/widget/perthle_scaffold.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({final Key? key}) : super(key: key);

  static const LightSource _lightSource = LightSource.topRight;

  @override
  Widget build(final BuildContext context) {
    return PerthleScaffold(
      appBar: const PerthleAppbar(
        title: 'Welcome',
        lightSource: _lightSource,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            _Heading('Welcome to Perthle'),
            Text(
              'It\'s like Wordle, but it\'s very graphically intensive, '
              'and the answers are all words relevant to Perthgang',
            ),
            _Heading('How to Play'),
            Text(
              'Swipe over to go to the game screen and start playing',
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {final Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
