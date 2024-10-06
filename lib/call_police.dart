import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPolice extends StatefulWidget {
  @override
  CallPoliceState createState() => CallPoliceState();
}

class CallPoliceState extends State<CallPolice> {
  @override
  void initState() {
    super.initState();
    _callPolice();
  }

  Future<void> _callPolice() async {
    // Richiedi il permesso di chiamata
    var status = await Permission.phone.status;

    if (!status.isGranted) {
      // Se il permesso non è stato concesso, richiedilo
      await Permission.phone.request();
      status = await Permission.phone.status;
    }

    if (status.isGranted) {
      // Effettua la chiamata
      final String phoneNumber = 'tel:3343654068';

      // Utilizza la nuova sintassi
      if (await canLaunch(phoneNumber)) {
        await launch(phoneNumber);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } else {
      // Gestisci il caso in cui il permesso non è concesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permesso per chiamare non concesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Cambia il colore di sfondo se necessario
          ),
          child: Image.asset('assets/callthepolice.png'),
        ),
      ),
    );
  }
}
