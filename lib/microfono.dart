import 'package:flutter/material.dart';

import 'model_page.dart';


class Microfono extends StatefulWidget {
const Microfono({super.key});

@override
State<Microfono> createState() => MicrofonoState();
}

class MicrofonoState extends State<Microfono> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ModelPage(),
      ),
    );
  }
}