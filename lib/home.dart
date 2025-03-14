import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gba_ivoirian/login.dart';
import 'package:gba_ivoirian/profile.dart';
import 'package:gba_ivoirian/seach.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class YangoHome extends StatefulWidget {
  const YangoHome({super.key});

  @override
  _YangoHomeState createState() => _YangoHomeState();
}

class _YangoHomeState extends State<YangoHome> {
  String _selectedRide = "Standard";
  String _searchQuery = "";
  LatLng? _mapCenter;
  LatLng? _currentLocation;
  LatLng? _destination;
  final MapController _mapController = MapController();
  bool _isSearching = false;
  bool _isLoadingLocation = true;
  bool _mapReady = false;
  double _ridePrice = 0.0;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Added for Drawer

  final Map<String, double> _ridePrices = {
    "Standard": 1.0,
    "Premium": 1.2,
    "VIP": 1.5,
  };

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez activer les services de localisation")),
        );
        _setFallbackLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permission de localisation refusée")),
          );
          _setFallbackLocation();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission refusée définitivement. Activez-la dans les paramètres")),
        );
        _setFallbackLocation();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapCenter = _currentLocation;
        if (_mapReady) {
          _mapController.move(_mapCenter!, 13.0);
        }
        _isLoadingLocation = false;
      });
    } catch (e) {
      print("Erreur lors de l'obtention de la position : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de localisation : $e")),
      );
      _setFallbackLocation();
    }
  }

  void _setFallbackLocation() {
    setState(() {
      _mapCenter = LatLng(5.2119, -3.7388); // Grand-Bassam, Côte d'Ivoire
      if (_mapReady) {
        _mapController.move(_mapCenter!, 13.0);
      }
      _isLoadingLocation = false;
    });
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
          if (_mapReady) {
            _mapController.move(_destination!, 20.0);
          }
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

  void _calculatePrice() {
    if (_currentLocation != null && _destination != null) {
      double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _destination!.latitude,
        _destination!.longitude,
      ) / 1000;

      double basePrice = distance * 198;
      double rideMultiplier = _ridePrices[_selectedRide] ?? 1.0;

      setState(() {
        _ridePrice = basePrice * rideMultiplier;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _getCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Added scaffold key
      drawer: Drawer( // Added Drawer widget
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Emmanuella",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    "Emmanuella@gmail.com",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Historique des courses"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => histo()),
                  );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Paramètres"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => para ()),
                  );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Déconnexion"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage ()),
                  );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _mapCenter == null || _isLoadingLocation
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _mapCenter!,
                    initialZoom: 13.0,
                    onMapReady: () {
                      setState(() {
                        _mapReady = true;
                      });
                      if (_mapCenter != null) {
                        _mapController.move(_mapCenter!, 13.0);
                      }
                    },
                    onTap: (tapPosition, point) {
                      setState(() {
                        _destination = point;
                        _calculatePrice();
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (_currentLocation != null && _destination != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [_currentLocation!, _destination!],
                            strokeWidth: 4.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    if (_currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation!,
                            width: 40,
                            height: 40,
                            child: const Icon(
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
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.account_circle, size: 36, color: Colors.black),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer(); // Open the drawer
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    onSubmitted: (value) => _searchLocation(),
                    decoration: InputDecoration(
                      hintText: "Où allez-vous ?",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      suffixIcon: _isSearching
                          ? const CircularProgressIndicator()
                          : IconButton(
                              icon: const Icon(Icons.search, color: Colors.black),
                              onPressed: _searchLocation,
                            ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 180,
            left: 20,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.green,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
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
                  const SizedBox(height: 10),
                  Text(
                    "Prix estimé : ${_ridePrice.toStringAsFixed(2)} FCFA",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _destination != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoadingPage(
                                  price: _ridePrice,
                                  destination: _searchQuery.isNotEmpty
                                      ? _searchQuery
                                      : "Destination inconnue",
                                  destinationAddress: _searchQuery.isNotEmpty
                                      ? _searchQuery
                                      : "Adresse non spécifiée",
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Center(
                      child: Text("Commander une course", style: TextStyle(fontSize: 18)),
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
          _calculatePrice();
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
            child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}