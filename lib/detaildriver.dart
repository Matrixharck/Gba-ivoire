import 'package:flutter/material.dart';
import 'package:gba_ivoirian/order.dart';
class Detaildriver extends StatelessWidget {
  const Detaildriver({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header gris avec l'icône de fermeture
            Container(
              height: 150,
              color: Colors.grey[400],
              child: Stack(
                children: [
                 Align(
  alignment: Alignment.topLeft,
  child: IconButton(
    icon: const Icon(Icons.close, color: Colors.black),
    onPressed: () {
      // Naviguer vers la page souhaitée
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TripDetailsScreen()),
      );
    },
  ),
),

                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[600],
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            // Profil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Georges",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.verified, size: 18),
                      SizedBox(width: 4),
                      Text("certifié chauffeur professionel"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.groups, size: 18),
                      SizedBox(width: 4),
                      Text("Passed a rigorous safety evaluation"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Statistiques
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("2,014", "courses"),
                      _buildStatItem("4.22", "note"),
                      _buildStatItem("4", "annee Exp."),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Divider(),

            // Achievements
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Achievements",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAchievementItem(Icons.emoji_events, "partenaire de confiance"),
                      const SizedBox(width: 40),
                      _buildAchievementItem(Icons.map, "navigation"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAchievementItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 93, 93, 92),
          child: Icon(icon, size: 30, color: const Color.fromARGB(255, 255, 233, 70)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
