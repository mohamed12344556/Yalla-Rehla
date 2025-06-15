// models/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://your-api-base-url.com/api/Messages';

  static Future<Map<String, dynamic>> createChat(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/CreateChat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create chat');
    }
  }

  static Future<void> sendMessage(String chatId, String content, bool isMe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/SendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'chatId': chatId,
        'content': content,
        'isMe': isMe,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  static Future<List<Map<String, dynamic>>> getChats() async {
    final response = await http.get(Uri.parse('$baseUrl/GetChats'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<void> deleteChat(String chatId) async {
    final response = await http.delete(Uri.parse('$baseUrl/DeleteChatWithMessages/$chatId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete chat');
    }
  }

  static Future<void> deleteMessage(String messageId) async {
    final response = await http.delete(Uri.parse('$baseUrl/DeleteMessage/$messageId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }
}