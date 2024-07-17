import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatBotPanel extends StatelessWidget {
  const ChatBotPanel({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chatbot',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white, // Set the color to white
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(17, 0, 158, 1)),
        ),
      ),
      body: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  String _response = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    _handleSubmitted(_textController.text);
                  }
                },
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // void _handleSubmitted(String userMessage) {
  //   // User message
  //   _addMessage(ChatMessage(userMessage, true));
  //
  //   // Bot response
  //   _addMessage(ChatMessage(_getBotResponse(userMessage) as String, false));
  //
  //   _textController.clear();
  // }
  void _handleSubmitted(String userMessage) {
    // User message
    _addMessage(ChatMessage(userMessage, true));

    // Bot response
    _getBotResponse(userMessage).then((botResponse) {
      _addMessage(ChatMessage(botResponse, false));
    });

    _textController.clear();
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<String> _getBotResponse(String userMessage) async {
    final String url = "http://192.168.56.224:5000/chatbot_resAndroid";

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'msg': userMessage}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['response']; // Return the bot's response
    } else {
      return 'Failed to connect to the server';
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage(this.text, this.isUser) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) // Display user icon for bot messages
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[200],
              child: Image.asset(
                'assets/image/logo.png',
                width: 50, // Sesuaikan dengan ukuran yang diinginkan
                height: 50,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.blueAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
