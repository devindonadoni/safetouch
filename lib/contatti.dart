import 'package:flutter/material.dart';
import 'package:my_app/model_page.dart';


class Contatti extends StatefulWidget {
  const Contatti({super.key});

  @override
  State<Contatti> createState() => ContattiState();
}

class ContattiState extends State<Contatti> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ModelPage(),
      ),
    );
  }
}