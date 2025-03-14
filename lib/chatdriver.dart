import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  
  // Predefined driver data
  final Map<String, String> driverData = {
    'name': 'Georges',
    'rating': '4.22',
    'vehicle': '2201 JS 01 - KPANDJI cavali',
    'eta': '2 minutes',
    'price': '2.540 fcfa',
  };

  // Predefined responses
  final Map<String, String> predefinedResponses = {
    'bonjour': 'Hello! How can I assist you with your ride today?',
    'assistant': 'Hi there! How can I help you?',
    'chauffeur': 'Your driver is Georges ',
    'statut': 'J\'arrive suis vers la boulangerie Mirmont .',
    'prix': 'The trip cost is 2.547 fcfa.',
    'merci': 'You\'re welcome! Safe travels!',
    'Annuler': 'To cancel your ride, please use the Cancel button on the trip screen.',
    
  };

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      // Add user's message
      _messages.add({'sender': 'user', 'text': text});
      
      // Generate automated response
      String response = _generateResponse(text.toLowerCase());
      _messages.add({'sender': 'driver', 'text': response});
    });
    
    _controller.clear();
  }

  String _generateResponse(String input) {
    // Check for keywords in the input
    for (String key in predefinedResponses.keys) {
      if (input.contains(key)) {
        return predefinedResponses[key]!;
      }
    }
    // Default response if no keyword matches
    return 'I\'m here to help! Could you please specify what you need assistance with?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF25D366), // WhatsApp green
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.blue.shade700),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverData['name']!,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Driver',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Color(0xFF25D366),
                  onPressed: () => _sendMessage(_controller.text),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}