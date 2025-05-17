import 'dart:convert';

import 'package:codebase_users/data/data_provider/user_data_provider.dart';
import 'package:codebase_users/models/user_model.dart';

import '../data_provider/user_local_provider.dart';

class UserRepository {
  final UserDataProvider userDataProvider;
  final UserLocalProvider userLocalProvider;
  UserRepository(
      {required this.userDataProvider, required this.userLocalProvider});

  Future<UserModel> getUserData(int page) async {
    try {
      final res = await userDataProvider.getUserData(page);
      final data = jsonDecode(res);

      final userModel = UserModel.fromJson(data);
      return userModel;
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  Future<void> saveUsers(List<User> users) async {
    userLocalProvider.saveUsers(users);
  }

  Future<List<User>> loadUsers() async {
    return userLocalProvider.loadUsers();
  }
}
