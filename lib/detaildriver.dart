import 'package:flutter/material.dart';
import 'package:gba_ivoirian/order.dart';

class Detaildriver extends StatelessWidget {
  final double? price;
  final String? destination;
  final String? destinationAddress;

  const Detaildriver({
    super.key,
    this.price,
    this.destination,
    this.destinationAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blueAccent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blueAccent, Colors.blue.shade700],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 70, color: Colors.blue.shade700),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Georges",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(Icons.verified, "Chauffeur professionnel certifié", Colors.blue),
                    const SizedBox(height: 10),
                    _buildInfoRow(Icons.security, "Évaluation de sécurité rigoureuse", Colors.green),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem("2,014", "Courses", Icons.directions_car),
                        _buildStatItem("4.22", "Note", Icons.star),
                        _buildStatItem("4", "Années", Icons.timer),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      "Réalisations",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAchievementItem(Icons.emoji_events, "Partenaire de confiance"),
                        const SizedBox(width: 40),
                        _buildAchievementItem(Icons.map, "Expert navigation"),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (price != null && destination != null && destinationAddress != null) ...[
                      const Text(
                        "Détails du trajet",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 10),
                      _buildTripInfoTile(Icons.home, destination!, destinationAddress!),
                      const SizedBox(height: 10),
                      _buildTripInfoTile(Icons.attach_money, "${price!.toStringAsFixed(2)} FCFA", "Georges Pay"),
                      const SizedBox(height: 20),
                    ],
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailsScreen(
                            price: price ?? 2540.0,
                            destination: destination ?? "Vitib 3.5km",
                            destinationAddress: destinationAddress ?? "33 IIT, vitib, Gb bassam 32202", paymentMethod: '',
                          ),
                        ),
                      ),
                      child: const Text("Retour au trajet", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 30),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAchievementItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey[100],
          child: Icon(icon, size: 35, color: Colors.amber),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTripInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }
}