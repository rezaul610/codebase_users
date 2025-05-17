import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class UserLocalProvider {
  String _userKey = 'cached_users';

  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final userListJson = users.map((u) => u.toJson()).toList();
    await prefs.setString(_userKey, jsonEncode(userListJson));
  }

  Future<List<User>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => User.fromJson(e)).toList();
  }
}
