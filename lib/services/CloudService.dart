import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudService {
  final String serverUrl = "https://<your-cloud-function-url>"; // Укажите URL вашего API

  Future<void> sendUserProfile(String email, String name, String bio) async {
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userEmail": email,
        "name": name,
        "bio": bio,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update profile: ${response.body}");
    }
  }
}
