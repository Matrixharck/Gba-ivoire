import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gba_ivoirian/order.dart';
import 'package:gba_ivoirian/user.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class YangoHome extends StatefulWidget {
  @override
  _YangoHomeState createState() => _YangoHomeState();
}

class _YangoHomeState extends State<YangoHome> {
  String _selectedRide = "Standard";
  String _searchQuery = "";
  LatLng _mapCenter = LatLng(48.8566, 2.3522); // Initial map center
  LatLng? _currentLocation;
  LatLng? _destination;
  final MapController _mapController = MapController();
  bool _isSearching = false;
  double _ridePrice = 0.0;

  // Tarifs par type de voiture
  final Map<String, double> _ridePrices = {
    "Standard": 1.0,  // Prix de base
    "Premium": 1.2,   // Premium à 20% plus cher
    "VIP": 1.5,       // VIP à 50% plus cher
  };

  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("La permission est refusée de manière permanente.");
        return;
      }
      if (permission == LocationPermission.denied) {
        print("La permission de localisation a été refusée.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapCenter = _currentLocation!;
        _mapController.move(_mapCenter, 10.0);
      });
    } catch (e) {
      print("Erreur lors de l'obtention de la position : $e");
    }
  }

  void _searchLocation() async {
    if (_searchQuery.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      List<Location> locations = await locationFromAddress(_searchQuery);
      if (locations.isNotEmpty) {
        setState(() {
          _destination = LatLng(locations[0].latitude, locations[0].longitude);
          _mapController.move(_destination!, 20.0);
          _calculatePrice();
        });
      }
    } catch (e) {
      print("Erreur lors de la recherche de l'adresse : $e");
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // Calcul du prix basé sur la distance et le type de voiture
  void _calculatePrice() {
    if (_currentLocation != null && _destination != null) {
      double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _destination!.latitude,
        _destination!.longitude,
      ) / 1000; // Distance en kilomètres

      double basePrice = distance * 250; // Prix de base par km (198)
      double rideMultiplier = _ridePrices[_selectedRide] ?? 1.0;

      setState(() {
        _ridePrice = basePrice * rideMultiplier;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _mapCenter, // Changer 'center' par 'initialCenter'
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _destination = point;
                  _calculatePrice();
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              // Affichage des marqueurs : position actuelle et destination
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              if (_destination != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _destination!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Barre de recherche avec icône de profil
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon:
                      Icon(Icons.account_circle, size: 36, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          user: User(
                            name: 'Kodjo',
                            email: 'kodjoandre56@example.com',
                            bio: 'KONAN OUMAR \nKOUAKOU\nTRAORE HUSSENI\n test pour GBA-IVOIRE',
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: "Où allez-vous ?",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      suffixIcon: _isSearching
                          ? CircularProgressIndicator()
                          : IconButton(
                              icon: Icon(Icons.search, color: Colors.black),
                              onPressed: _searchLocation,
                            ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bouton pour obtenir la position actuelle
          Positioned(
            bottom: 180,
            left: 20,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.green,
              child: Icon(Icons.my_location, color: Colors.white),
            ),
          ),
          // Options de course
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRideOption(Icons.directions_car, "Standard"),
                      _buildRideOption(Icons.local_taxi, "Premium"),
                      _buildRideOption(Icons.airport_shuttle, "VIP"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Prix estimé : ${_ridePrice.toStringAsFixed(2)} FCFA",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _destination != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TripScreen()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue,
                    ),
                    child: Center(
                      child: Text("Commander une course",
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideOption(IconData icon, String label) {
    bool isSelected = _selectedRide == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRide = label;
          _calculatePrice(); // Recalculer le prix lorsque le type de voiture est changé
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
            child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
          ),
          SizedBox(height: 5),
          Text(label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
