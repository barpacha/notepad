import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'EditScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return MainScreen();},
        '/textEdit': (BuildContext context) {
          return EditScreen(ModalRoute.of(context)?.settings.arguments as String);
        }
        },
    );
    }
}

