import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:perthle/widget/perthle_app.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const PerthleApp());
}
