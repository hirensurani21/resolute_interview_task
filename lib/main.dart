import 'package:flutter/material.dart';
import 'package:resolute_interview_task_one/home_screen.dart';

void main() {
  runApp( resoluteTaskApp());
}
class resoluteTaskApp extends StatefulWidget {
  const resoluteTaskApp({super.key});

  @override
  State<resoluteTaskApp> createState() => _resoluteTaskAppState();
}

class _resoluteTaskAppState extends State<resoluteTaskApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoHomePage(),
    );
  }
}

