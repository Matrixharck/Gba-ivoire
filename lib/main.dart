import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gba_ivoirian/lauch.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GBA-IVOIRE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Lauch(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo ou icône
            Image.asset(
              'assets/images/GBA-IVOIRE.png', // Remplacez par le chemin correct
              height: 120,
            ),
            SizedBox(height: 20),

            Text(
              "Connexion à GBA-IVOIRE",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),

            // Champ Email
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Champ Mot de passe
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Bouton de connexion
            ElevatedButton(
              onPressed: () {
                // Action de connexion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Option "Créer un compte"
            TextButton(
              onPressed: () {
                // Navigation vers la page d'inscription
              },
              child: Text(
                "Créer un compte",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
            ),

            SizedBox(height: 30),
            Text(
              "Ou connectez-vous avec",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 15),

            // Boutons de connexion sociale
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                  iconSize: 35,
                  onPressed: () {
                    // Connexion avec Google
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                  iconSize: 35,
                  onPressed: () {
                    // Connexion avec Facebook
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                  iconSize: 35,
                  onPressed: () {
                    // Connexion avec Apple
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}