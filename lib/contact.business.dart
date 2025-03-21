import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:my_app/home_page.dart';
import 'package:my_app/info.dart';
import 'package:my_app/maps.dart';
import 'package:my_app/microfono.dart';

class Contatti extends StatefulWidget {
  const Contatti({super.key});

  @override
  State<Contatti> createState() => ContattiState();
}

class ContattiState extends State<Contatti> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Contact>? _contacts;
  String? _permissionMessage;

  final List<Color> colors = [
    Color(0xFF680505),
    Color(0xFF45355e),
    Color(0xFF6b0a30),
    Color(0xFF314160),
    Color(0xFF2f4858),
  ];

  Color? lastColor; // Variabile per tenere traccia dell'ultimo colore utilizzato


  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await _requestPermission()) {
      var contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = contacts;
      });
    } else {
      setState(() {
        _permissionMessage =
        'SAFETOUCH ha bisogno dei permessi per accedere alla rubrica.';
      });
    }
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.contacts.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: SvgPicture.asset(
                    'assets/menu_icon.svg',
                    height: 30,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(top: 20, left: 50),
                child: Text(
                  "SAFETOUCH",
                  style: TextStyle(
                      color: PrimaryColor,
                      fontSize: 30,
                      fontFamily: 'inter',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: BackGroundColor,
          elevation: 0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: BackGroundColor,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: PrimaryColor,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/home.svg",
                  color: PrimaryColor,
                ),
                title: Text(
                  'HOME',
                  style: TextStyle(color: PrimaryColor),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/permission.svg",
                  color: PrimaryColor,
                ),
                title: Text(
                  'PERMESSI',
                  style: TextStyle(color: PrimaryColor),
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Info()));
                },
              ),
            ],
          ),
        ),

        /// BODY
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_permissionMessage != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _permissionMessage!,
                  style: TextStyle(color: PrimaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_contacts == null)
              Center(child: CircularProgressIndicator())
            else
              if (_contacts!.isEmpty)
                Center(
                  child: Text(
                    "Nessun contatto trovato.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _contacts!.length,
                    itemBuilder: (context, index) {
                      final contact = _contacts![index];

                      // Scegli un colore casualmente dall'elenco
                      Color randomColor;
                      do {
                        randomColor = colors[Random().nextInt(colors.length)];
                      } while (randomColor ==
                          lastColor); // Assicurati che non sia uguale all'ultimo colore

                      lastColor =
                          randomColor; // Aggiorna l'ultimo colore utilizzato

                      // Estrai la lettera iniziale del nome del contatto
                      String initial = contact.displayName.isNotEmpty ? contact
                          .displayName[0].toUpperCase() : '';

                      return Container(
                        margin: EdgeInsets.only(left: 35, top: 20),
                        child: Row(
                          children: [
                            // Cerchietto con la lettera iniziale
                            Container(
                              width: 50,
                              // Larghezza del cerchietto
                              height: 50,
                              // Altezza del cerchietto
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: randomColor, // Colore scelto
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initial,
                                style: TextStyle(
                                  color: Colors.white, // Colore del testo
                                  fontSize: 20, // Dimensione del testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Spazio tra il cerchietto e il ListTile
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  contact.displayName,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 30),
                                ),
                                subtitle: Text(
                                  contact.phones.isNotEmpty
                                      ? contact.phones.first.number
                                      : "Nessun numero disponibile",
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

            Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: BackGroundColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: PrimaryColor, width: 5),
                ),
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Microfono()));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                        // Margine complessivo
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                "assets/microfono.svg",
                                color: PrimaryColor,
                                height: 40,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "MICROFONO",
                                style: TextStyle(color: PrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Maps()));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                        // Margine complessivo
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                "assets/maps.svg",
                                color: PrimaryColor,
                                height: 40,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "MAPPA",
                                style: TextStyle(color: PrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                        // Margine complessivo
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                "assets/sos.svg",
                                height: 40,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "HOME",
                                style: TextStyle(color: PrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Contatti()));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                        // Margine complessivo
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                "assets/contatti.svg",
                                color: PrimaryColor,
                                height: 40,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "CONTATTI",
                                style: TextStyle(color: PrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Info()));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                        // Margine complessivo
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                "assets/info.svg",
                                color: PrimaryColor,
                                height: 40,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "INFO",
                                style: TextStyle(color: PrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
