import 'package:flutter/material.dart';
import 'package:gba_ivoirian/home.dart';

class CancelRideScreen extends StatefulWidget {
  const CancelRideScreen({super.key});

  @override
  State<CancelRideScreen> createState() => _CancelRideScreenState();
}

class _CancelRideScreenState extends State<CancelRideScreen> {
  final List<Map<String, dynamic>> reasons = [
    {"text": "Le chauffeur ne répond pas", "icon": Icons.phone_disabled},
    {"text": "Le chauffeur n'est pas présent", "icon": Icons.person_off},
    {"text": "Le chauffeur m'a dit d'annuler", "icon": Icons.message},
    {"text": "Le chauffeur est à la mauvaise rue", "icon": Icons.wrong_location},
    {"text": "Le chauffeur est arrivé trop tôt", "icon": Icons.timer},
    {"text": "Autre", "icon": Icons.help_outline},
  ];

  String? selectedReason;
  bool _isSubmitting = false;

  void _submitCancellation() async {
    if (selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner une raison"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Course annulée: $selectedReason"),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  YangoHome()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Annuler la course"),
        backgroundColor: Colors.red[700],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: const Text(
                "Pourquoi voulez-vous annuler?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: RadioListTile<String>(
                      value: reasons[index]["text"],
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() => selectedReason = value);
                      },
                      title: Text(reasons[index]["text"]),
                      secondary: Icon(reasons[index]["icon"], color: Colors.blue),
                      activeColor: Colors.red[700],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submitCancellation,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Confirmer l'annulation",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.black),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Revenir",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}