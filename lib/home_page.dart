import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/constant.dart';
import 'package:my_app/contatti.dart';
import 'package:my_app/info.dart';
import 'package:my_app/maps.dart';
import 'package:my_app/microfono.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                leading: Icon(
                  Icons.home,
                  color: PrimaryColor,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(color: PrimaryColor),
                ),
                onTap: () {
                  // Azione per Home
                  Navigator.pop(context); // Chiude il drawer
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: PrimaryColor,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(color: PrimaryColor),
                ),
                onTap: () {
                  // Azione per Settings
                  Navigator.pop(context); // Chiude il drawer
                },
              ),
            ],
          ),
        ),

        ///BODY
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Spazio tra gli elementi
          children: <Widget>[
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    width: 300, // Larghezza del cerchio
                    height: 300, // Altezza del cerchio (uguale per farlo circolare)
                    decoration: BoxDecoration(
                      color: PrimaryColor, // Colore del pulsante
                      shape: BoxShape.circle, // Fa il container circolare
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          color: BackGroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 86,
                        ),
                      ),
                    ),
                  ),
                ),
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
