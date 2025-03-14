import 'package:flutter/material.dart';
import 'package:gba_ivoirian/cancelTrip.dart';
import 'package:gba_ivoirian/chatdriver.dart';
import 'package:gba_ivoirian/detaildriver.dart';
import 'package:gba_ivoirian/rateDriver.dart';
import 'package:url_launcher/url_launcher.dart';

class TripScreen extends StatefulWidget {
  final double price;
  final String destination;
  final String destinationAddress;
  final List<Map<String, String>> passengers; // Ajout des passagers

  const TripScreen({
    super.key,
    required this.price,
    required this.destination,
    required this.destinationAddress,
    this.passengers = const [], // Valeur par défaut : liste vide
  });

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _paymentMethod = "Georges Pay";
  bool _isSearchingDriver = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _cancelTrip() {
    Navigator.pop(context);
  }

  void _changePaymentMethod() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choisir le moyen de paiement"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Georges Pay"),
                  onTap: () {
                    setState(() => _paymentMethod = "Georges Pay");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Moov"),
                  onTap: () {
                    setState(() => _paymentMethod = "Moov");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Orange"),
                  onTap: () {
                    setState(() => _paymentMethod = "Orange");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Wave"),
                  onTap: () {
                    setState(() => _paymentMethod = "Wave");
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _searchDriver() async {
    setState(() {
      _isSearchingDriver = true;
    });

    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailsScreen(
            price: widget.price,
            destination: widget.destination,
            destinationAddress: widget.destinationAddress,
            paymentMethod: _paymentMethod,
            passengers: widget.passengers, // Transmettre les passagers
          ),
        ),
      );
      setState(() {
        _isSearchingDriver = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade200, Colors.blue.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.location_pin, size: 50, color: Colors.white.withOpacity(0.9)),
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Détail du trajet",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                              ),
                              const SizedBox(height: 15),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : Icon(Icons.directions_car, size: 60, color: Colors.blueAccent),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.home, color: Colors.blueAccent),
                          title: Text(widget.destination),
                          subtitle: Text(widget.destinationAddress),
                          trailing: const Text("Modifier", style: TextStyle(color: Colors.blueAccent)),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.attach_money, color: Colors.blueAccent),
                          title: Text("${widget.price.toStringAsFixed(2)} FCFA"),
                          subtitle: Text(_paymentMethod),
                          trailing: GestureDetector(
                            onTap: _changePaymentMethod,
                            child: const Text("Modifier", style: TextStyle(color: Colors.blueAccent)),
                          ),
                        ),
                        const Divider(),
                        const Spacer(),
                        Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 5,
                              ),
                              onPressed: _isSearchingDriver ? null : _searchDriver,
                              child: const Text("Commander", style: TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                              onPressed: _cancelTrip,
                              child: const Text("Annuler", style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isSearchingDriver)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Recherche de chauffeur",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
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
}

class TripDetailsScreen extends StatelessWidget {
  final double price;
  final String destination;
  final String destinationAddress;
  final String paymentMethod;
  final List<Map<String, String>> passengers; // Ajout des passagers

  const TripDetailsScreen({
    super.key,
    required this.price,
    required this.destination,
    required this.destinationAddress,
    required this.paymentMethod,
    this.passengers = const [], // Valeur par défaut : liste vide
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade200, Colors.blue.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/map.png',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.1),
                        colorBlendMode: BlendMode.dstATop,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Le chauffeur arrive bientôt",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "2 mins",
                                    style: TextStyle(fontSize: 14, color: Colors.green.shade900),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Detaildriver())),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey[300],
                                      child: Icon(Icons.person, size: 35, color: Colors.blue.shade700),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: const [
                                            Text("Georges", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                            SizedBox(width: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.star, size: 16, color: Colors.amber),
                                                Text("4.22", style: TextStyle(fontSize: 14)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: const [
                                            Icon(Icons.directions_car, size: 20, color: Colors.grey),
                                            SizedBox(width: 5),
                                            Text("2201 JS 01", style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(width: 12),
                                            Text("KPANDJI balèse", style: TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.phone, color: Colors.green.shade700),
                                    onPressed: () => _callDriver(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen())),
                            icon: const Icon(Icons.chat),
                            label: const Text("Discuter avec le chauffeur", style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(height: 20),
                          _buildTripInfoTile(
                            icon: Icons.home,
                            title: destination,
                            subtitle: destinationAddress,
                            trailing: "",
                          ),
                          const Divider(),
                          _buildTripInfoTile(
                            icon: Icons.attach_money,
                            title: "${price.toStringAsFixed(2)} FCFA",
                            subtitle: paymentMethod,
                            trailing: "",
                          ),
                          const Divider(),
                          _buildTripInfoTile(
                            icon: Icons.share,
                            title: "Partager mon trajet",
                            trailing: "partager",
                          ),
                          const SizedBox(height: 20),
                          // Ajout de la liste des passagers
                          if (passengers.isNotEmpty) ...[
                            const Text(
                              "Passagers",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true, // Important pour éviter les débordements dans SingleChildScrollView
                              physics: const NeverScrollableScrollPhysics(), // Désactiver le scroll interne
                              itemCount: passengers.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: Text(
                                        passengers[index]["name"]![0],
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      passengers[index]["name"]!,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Destination: ${passengers[index]["destination"]}",
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CancelRideScreen())),
                                  child: const Text("Annuler", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RateDriverScreen())),
                                  child: const Text("Course terminée", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfoTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required String trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Text(trailing, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500)),
    );
  }

  void _callDriver(BuildContext context) async {
    final Uri phoneUrl = Uri.parse('tel:+22523456789');
    try {
      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible d\'effectuer l\'appel')));
      }
    } catch (e) {
      print('Erreur lors de l\'appel téléphonique: $e');
    }
  }
}