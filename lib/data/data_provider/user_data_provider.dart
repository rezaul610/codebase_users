import 'package:http/http.dart' as http;

class UserDataProvider {
  Future<String> getUserData(int page) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': 'reqres-free-v1',
    };
    try {
      final res = await http.get(
        Uri.parse('https://reqres.in/api/users?per_page=10&page=$page'),
        headers: headers,
      );

      return res.body;
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }
}
