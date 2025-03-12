import 'package:flutter/material.dart';
import 'package:gba_ivoirian/home.dart';
import 'package:gba_ivoirian/order.dart';

class CancelRideScreen extends StatefulWidget {
  const CancelRideScreen({super.key});

  @override
  State<CancelRideScreen> createState() => _CancelRideScreenState();
}

class _CancelRideScreenState extends State<CancelRideScreen> {
  final List<String> reasons = [
    "Le chauffeur ne repond pas !",
    "Le chauffeur n'est pas present !",
    "Le chauffeur m'a dit d'annuler",
    "Le chauffeur est a la mauvaise rue",
    "Le chauffeur est arrive tot",
    "Autre",
  ];

  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Pourquoi voulez-vous annuler?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reasons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    selectedReason == reasons[index]
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: Colors.blue,
                  ),
                  title: Text(reasons[index]),
                  onTap: () {
                    setState(() {
                      selectedReason = reasons[index];
                    });
                  },
                );
              },
            ),
          ),
          if (selectedReason != null) // Affiche le bouton "Confirmer" si une option est sélectionnée
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YangoHome()),
                );
                },
                child: const Text("Confirmer l'annulation"),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TripDetailsScreen()),
                );
              },
              child: const Text("Revenir"),
            ),
          ),
        ],
      ),
    );
  }
}
