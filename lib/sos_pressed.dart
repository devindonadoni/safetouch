import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/constant.dart';
import 'package:my_app/home_page.dart';
import 'help_screen.dart';
import 'microfono.dart';

class SosPressed extends StatefulWidget {
  @override
  _SosPressedScreenState createState() => _SosPressedScreenState();
}

class _SosPressedScreenState extends State<SosPressed> with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _start = 10; // Timer countdown value
  double _circleSize = 200; // Dimensione iniziale del cerchio pulsante
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Inizia il timer non appena viene visualizzata l'activity
    startTimer();

    // Inizializza l'AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Durata di un ciclo di pulsazione
    )..repeat(reverse: true); // Ripete l'animazione

    // Aggiungi listener per aggiornare la dimensione del cerchio
    _controller.addListener(() {
      setState(() {
        _circleSize = 200 + 10 * _controller.value; // Pulsazione
      });
    });
  }

  // Funzione per avviare il timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--; // Riduci il timer di 1 ogni secondo
        });
      } else {
        timer.cancel();
        // Naviga alla nuova schermata quando il timer raggiunge 0
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  void stopTimer() {
    setState(() {
      _timer?.cancel(); // Cancella il timer
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annulla il timer se l'activity viene chiusa
    _controller.dispose(); // Annulla l'AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text(
            '${_start.toString().padLeft(2, '0')}', // Formatta il timer con zero a sinistra
            style: GoogleFonts.orbitron(
              textStyle: TextStyle(
                fontSize: 48, // Grande per un effetto tabellone
                fontWeight: FontWeight.bold,
                color: BackGroundColor,
              ),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: SosColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            color: SosColor, // Sfondo principale
          ),
          // Pulsante grande al centro
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: SosColor,
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: SosButtonColor, // Colore del pulsante
                    shape: BoxShape.circle, // Fa il container circolare
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  width: 300, // Larghezza del cerchio
                  height: 300,
                  child: Center(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500), // Durata della pulsazione
                      width: _circleSize, // Dimensione del cerchio pulsante
                      height: _circleSize,
                      decoration: BoxDecoration(
                        color: Colors.orange, // Colore arancione
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Pulsante X circolare in basso
          Positioned(
            bottom: 20, // Posizionamento in basso
            left: MediaQuery.of(context).size.width / 2 - 25, // Centrato orizzontalmente
            child: GestureDetector(
              onTap: () {
                stopTimer(); // Annulla il timer quando viene premuto
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey, // Sfondo grigio
                  shape: BoxShape.circle, // Forma circolare
                ),
                width: 50, // Larghezza del piccolo cerchio
                height: 50, // Altezza del piccolo cerchio
                child: Center(
                  child: Text(
                    "X",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white, // Colore del testo
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
