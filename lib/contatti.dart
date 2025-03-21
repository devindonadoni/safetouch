import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:math';

import 'constant.dart';
import 'home_page.dart';
import 'info.dart';
import 'maps.dart';
import 'microfono.dart';

class Contatti extends StatefulWidget {
  const Contatti({super.key});

  @override
  State<Contatti> createState() => ContattiState();
}

class ContattiState extends State<Contatti> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, String>> _contacts = [
    {"name": "EMERGENZA", "number": "112"},
    {"name": "EMERGENZA", "number": "118"},
  ];

  final List<Color> colors = [
    Color(0xFF680505),
    Color(0xFF45355e),
    Color(0xFF6b0a30),
    Color(0xFF314160),
    Color(0xFF2f4858),
  ];

  Color? lastColor;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // Load contacts from shared preferences
  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedContacts = prefs.getString('contacts');
    if (savedContacts != null) {
      setState(() {
        _contacts = List<Map<String, String>>.from(jsonDecode(savedContacts));
      });
    }
  }

  // Save contacts to shared preferences
  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('contacts', jsonEncode(_contacts));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        // Imposta la chiave al Scaffold
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // Disattiva l'icona predefinita
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState
                      ?.openDrawer(); // Usa la chiave per aprire il drawer
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
          // Il Drawer, ovvero il menu hamburger
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
                  // Azione per Home
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage())); // Chiude il drawer
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
                  // Azione per Settings
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Info())); // Chiude il drawer
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  Color randomColor;

                  do {
                    randomColor = colors[Random().nextInt(colors.length)];
                  } while (randomColor == lastColor);

                  lastColor = randomColor;

                  String initial = contact["name"]!.isNotEmpty
                      ? contact["name"]![0].toUpperCase()
                      : '';

                  return Container(
                    margin: EdgeInsets.only(left: 35, top: 20, right: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: randomColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initial,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              contact["name"]!,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(contact["number"]!),
                            onTap: () {
                              _makePhoneCall(contact["number"]!);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10, right: 20),
                  child: FloatingActionButton(
                    onPressed: () async {
                      Map<String, String>? newContact = await _showAddContactDialog();
                      if (newContact != null) {
                        setState(() {
                          _contacts.add(newContact);
                        });
                        _saveContacts();
                      }
                    },
                    child: Text("+", style: TextStyle(color: BackGroundColor, fontSize: 35),),
                    backgroundColor: PrimaryColor,
                    tooltip: 'Aggiungi contatto',
                  ),
                ),
              ],
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

  Future<Map<String, String>?> _showAddContactDialog() async {
    String? name;
    String? number;
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aggiungi contatto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Nome'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Numero'),
                onChanged: (value) {
                  number = value;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                if (name != null && number != null) {
                  Navigator.of(context).pop({
                    "name": name!,
                    "number": number!,
                  });
                }
              },
              child: Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }
}
