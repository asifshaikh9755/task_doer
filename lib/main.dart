import 'package:flutter/material.dart';
import 'package:task_doer/screens/NoteList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Doer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0Xff055a8c),
      ),
      home: NoteList(),
    );
  }
}
