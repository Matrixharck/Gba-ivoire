import 'package:flutter/material.dart';
import 'package:gba_ivoirian/home.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Fonction pour enregistrer les changements
  // ignore: unused_element
  void _saveProfile() {
    // Mettez ici la logique pour enregistrer ou envoyer les informations mises à jour
    setState(() {
      widget.user.name = _nameController.text;
      widget.user.email = _emailController.text;
      widget.user.bio = _bioController.text;
    });

    // Vous pouvez également appeler une API pour sauvegarder les données sur un serveur
    print(
        "Profile updated: ${widget.user.name}, ${widget.user.email}, ${widget.user.bio}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de ${widget.user.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Bio'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YangoHome(),
                  ),
                );
              },
              child: Text('Sauvegarder le profil'),
            ),

            Spacer(), // Cela pousse le bouton de déconnexion en bas
             ElevatedButton(
  onPressed: () async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Déconnexion'),
        content: Text('Voulez-vous vraiment quitter l\'application ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Non
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Oui
            child: Text('Oui'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      SystemNavigator.pop(); // Ferme l'application si confirmé
    }
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text(
    'Se déconnecter',
    style: TextStyle(fontSize: 16),
  ),
),
          ],
        ),
      ),
    );
  }
}

class User {
  String name;
  String email;
  String bio;

  User({
    required this.name,
    required this.email,
    required this.bio,
  });

  // Méthode pour créer un utilisateur à partir d'un map (utile pour récupérer les données d'une API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
    );
  }

  // Méthode pour convertir l'utilisateur en map (utile pour envoyer les données à une API)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
    };
  }
}
