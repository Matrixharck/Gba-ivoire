import 'package:flutter/material.dart';
import 'package:gba_ivoirian/login.dart';


class Lauch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 143, 186, 236),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Espace en haut
            // Logo
            Image.asset(
              'assets/images/logo01.png', // Remplacez par le bon chemin de votre logo
              height: 280,
            ),
            SizedBox(height: 15),
            // Image principale
            Image.asset(
              'assets/images/GBA-IVOIRE.png', // Remplacez par le bon chemin de votre image
              height: 310,
            ),
            SizedBox(height: 20),
            // Texte de bienvenue
            Text(
              "Bienvenue dans GBA IVOIRE.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(), // Espace avant le bouton
            // Bouton Get Started
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage ()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Commencer",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_right_alt, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80), // Espace en bas
          ],
        ),
      ),
    );
  }
}