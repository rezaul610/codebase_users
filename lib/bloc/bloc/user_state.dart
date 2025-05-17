part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final List<User> users;
  final int page;
  final String query;

  UserLoaded(this.users, this.page, {this.query = ''});

  UserLoaded copyWith({List<User>? users, int? currentPage, String? query}) {
    return UserLoaded(
      users ?? this.users,
      currentPage ?? page,
      query: query ?? this.query,
    );
  }

  List<User> get filteredUsers {
    if (query.isEmpty) return users;
    return users.where((user) {
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
  }
}

final class UserError extends UserState {
  final String message;

  UserError(this.message);
}
