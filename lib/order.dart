import 'package:flutter/material.dart';
import 'package:gba_ivoirian/cancelTrip.dart';
import 'package:gba_ivoirian/detaildriver.dart';
import 'package:gba_ivoirian/rateDriver.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green), // Remplacer accentColor
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),  // Remplacer bodyText1
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),  // Remplacer bodyText2
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
        ),
      ),
      home: TripScreen(),
    );
  }
}

class TripScreen extends StatefulWidget {
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  bool _isLoading = false;
  bool _isLoadingNewPage = false;

  void _startLoadingNextScreen() {
    setState(() {
      _isLoadingNewPage = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoadingNewPage = false;
      });
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripDetailsScreen()),
        );
      });
    });
  }

  void _cancelTrip() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 250,
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.location_pin, size: 40, color: Colors.black),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Detail du trajet",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        _isLoading
                            ? CircularProgressIndicator()
                            : Icon(Icons.directions_car, size: 50),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Vitib 3.5km"),
                    subtitle: Text("33 IIT, vitib, Gb bassam 32202"),
                    trailing: Text("Change or Add",
                        style: TextStyle(color: Colors.blue)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text("2.540 fcfa"),
                    subtitle: Text("Georges pay"),
                    trailing:
                        Text("Change", style: TextStyle(color: Colors.blue)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text("partager ma course"),
                    trailing:
                        Text("Share", style: TextStyle(color: Colors.blue)),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed:
                            _isLoadingNewPage ? null : _startLoadingNextScreen,
                        child: _isLoadingNewPage
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Commander"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _cancelTrip,
                        child: Text("Annuler"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TripDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Carte grise en haut
          Container(
            height: 210,
            color: Colors.grey[300],
            child: Center(
              child: Image.asset(
                'assets/images/map.png', // Remplace par le chemin correct
                width: 480,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Détails du chauffeur et trajet
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "le chauffeur arrive bientot",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("2 mins",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Naviguer vers la page souhaitée
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detaildriver()),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 25,
                          child:
                              Icon(Icons.person, size: 30, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Georges  •  4.22 ⭐",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.directions_car, size: 20),
                              SizedBox(width: 5),
                              Text("2201 JS 01",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              Text("KPANDJI cavali",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.phone, color: const Color.fromARGB(255, 58, 122, 1)),
                        onPressed: _callDriver,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 199, 251, 182),
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _whatsapp,
                    icon: Icon(Icons.messenger_outline_rounded),
                    label: Text("Discuter sur WhatsApp"),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 15),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Vitib 3.5km"),
                    subtitle: Text("33 IIT, vitib, Gb bassam 32202"),
                    trailing: Text("Change or Add",
                        style: TextStyle(color: Colors.blue)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text("2.540 fcfa"),
                    subtitle: Text("Georges pay"),
                    trailing:
                        Text("Change", style: TextStyle(color: Colors.blue)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text("partager ma course"),
                    trailing:
                        Text("Share", style: TextStyle(color: Colors.blue)),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CancelRideScreen()),
                            );
                          },
                          child: Text("Annuler"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RateDriverScreen()),
                            );

                          },
                          child: Text("Terminer"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _callDriver() async {
    const url = 'tel:+22523456789'; // Remplacez par le numéro du chauffeur
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _whatsapp() async {
    const url = 'https://wa.me/+22523456789'; // Remplacez par le numéro WhatsApp du chauffeur
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
