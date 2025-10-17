import 'package:shared_preferences/shared_preferences.dart';

Future<void> initData() async {
  final prefs = await SharedPreferences.getInstance();

  //await prefs.setInt('counter', counter);
}
