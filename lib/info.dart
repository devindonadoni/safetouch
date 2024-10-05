import 'package:flutter/material.dart';

import 'model_page.dart';


class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => InfoState();
}

class InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        ),
        body: ModelPage(),
      ),
    );
  }
}