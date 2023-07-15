import 'package:flutter/material.dart';
import 'package:todo_app_shithaa/tudopage.dart';
void main()
{
  runApp(Tudo());
}
class Tudo extends StatelessWidget {
  const Tudo({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: TUDOPAGE(),
    );
  }
}
