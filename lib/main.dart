import 'package:flutter/material.dart';
import 'package:my_simple_notes/screens/note_list.dart';
import 'package:my_simple_notes/screens/note_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySimpleNote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: NoteList(),
    );
  }
}
