import 'package:flutter/material.dart';
import 'package:gba_ivoirian/order.dart';

class LoadingPage extends StatefulWidget {
  final double price;
  final String destination;
  final String destinationAddress;

  const LoadingPage({
    super.key,
    required this.price,
    required this.destination,
    required this.destinationAddress,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final List<Map<String, String>> allPeople = [
    {"name": "Aminata", "destination": "Port-bouet"},
    {"name": "Koffi", "destination": "Cocody"},
    {"name": "Sophie", "destination": "Trechville"},
  ];

  List<Map<String, String>> displayedPeople = [];
  bool isLoading = true;
  bool showNextButton = false;

  @override
  void initState() {
    super.initState();
    startLoadingPeople();
  }

  void startLoadingPeople() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });

    for (var person in allPeople) {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        displayedPeople.add(person);
      });
    }

    setState(() {
      showNextButton = true;
    });
  }

  void onNextPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripScreen(
          price: widget.price,
          destination: widget.destination,
          destinationAddress: widget.destinationAddress,
          passengers: displayedPeople, // Transmettre la liste des passagers
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chargement des Passagers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Chargement en cours...",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : displayedPeople.isEmpty
                        ? const Text(
                            "Aucun passager pour le moment",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: displayedPeople.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Text(
                                      displayedPeople[index]["name"]![0],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    displayedPeople[index]["name"]!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Destination: ${displayedPeople[index]["destination"]}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: const Icon(
                                    Icons.directions,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
            if (showNextButton)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Suivant",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}