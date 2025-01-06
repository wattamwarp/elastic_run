import 'package:elastic_run/db/db_helper.dart';
import 'package:elastic_run/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

/// don't have app instance or getIt implementation for time being keeping here
Database? database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elastic Run Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
