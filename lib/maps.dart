import 'package:flutter/material.dart';

import 'model_page.dart';


class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => MapsState();
}

class MapsState extends State<Maps> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ModelPage(),
      ),
    );
  }
}