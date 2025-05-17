part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserFetched extends UserEvent {
  final int page;
  UserFetched(this.page);
}

class UserRefresh extends UserEvent {
  final int page;
  UserRefresh(this.page);
}

class UserLoadMore extends UserEvent {
  final int page;
  UserLoadMore(this.page);
}

final class SearchUser extends UserEvent {
  final String query;
  SearchUser(this.query);
}
