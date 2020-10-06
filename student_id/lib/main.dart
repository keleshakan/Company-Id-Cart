import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xamp_connection/register.dart';
import 'datatabledemo.dart';
import 'database.dart';
import 'studentidcard.dart';
import 'register.dart';
import 'studentInfo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => DataTableDemo(),
        '/register': (context) => Register(),
        '/database': (context) => Database(),
        '/studentInfo': (context) => StudentInfo(),
        '/studentID': (context) => StudentID(),
      },
    );
  }
}