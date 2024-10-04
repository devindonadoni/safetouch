import 'package:flutter/material.dart';

import 'home_page.dart';
import 'model_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SAFETOUCH",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'inter'),
      home: HomePage(),
    );
  }
}