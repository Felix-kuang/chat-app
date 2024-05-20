import 'dart:convert';
import 'package:front_end/models/chat_message.dart';
import 'package:http/http.dart' as http;

class MessageController {
  final String baseUrl;

  MessageController({required this.baseUrl});

  Future<List<ChatMessage>> getMessages() async {
    final response = await http.get(Uri.parse('$baseUrl/getmessages'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load messages!");
    }
  }

  Future<void> sendMessages(String username, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendmessages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'text': message}),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to send message");
    }
  }
}
