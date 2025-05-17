import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../data/repository/user_repository.dart';
import '../models/user_model.dart';
import '../services/connectivity_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;
  final ConnectivityService connectivityService;

  int currentPage = 1;
  int totalPage = 1;
  List<User> allUsers = [];
  String searchQuery = '';

  UserBloc(this.repository, this.connectivityService) : super(UserInitial()) {
    on<UserFetched>((event, emit) async {
      if (allUsers.isEmpty) {
        emit(UserLoading());
      }
      try {
        currentPage = event.page;
        final cachedUsers = await repository.loadUsers();
        allUsers = cachedUsers;
        if (cachedUsers.isNotEmpty) {
          emit(UserLoaded(cachedUsers, event.page));
          return;
        }

        bool result = await connectivityService.hasConnection();
        if (!result) {
          emit(UserError('No internet connection'));
          return;
        }

        if (event.page == 1) {
          allUsers.clear();
          emit(UserLoading());
        }
        final userModel = await repository.getUserData(event.page);
        totalPage = userModel.totalPages ?? 0;
        allUsers.addAll(userModel.data ?? []);
        await repository.saveUsers(allUsers);
        emit(UserLoaded(allUsers, event.page));
      } catch (e) {
        emit(UserError('Failed to load user data. Please try again.'));
      }
    });

    on<UserRefresh>((event, emit) async {
      currentPage = event.page;
      allUsers.clear();
      emit(UserLoading());
      try {
        final userModel = await repository.getUserData(currentPage);
        totalPage = userModel.totalPages ?? 0;
        allUsers.addAll(userModel.data ?? []);
        await repository.saveUsers(allUsers);
        emit(UserLoaded(allUsers, currentPage));
      } catch (e) {
        emit(UserError('Failed to load user data. Please try again.'));
      }
    });

    on<UserLoadMore>((event, emit) async {
      currentPage = event.page;
      try {
        final userModel = await repository.getUserData(currentPage);
        totalPage = userModel.totalPages ?? 0;
        allUsers.addAll(userModel.data ?? []);
        await repository.saveUsers(allUsers);
        emit(UserLoaded(allUsers, event.page));
      } catch (e) {
        emit(UserError('Failed to load user data. Please try again.'));
      }
    });

    on<SearchUser>((event, emit) {
      searchQuery = event.query;
      if (state is UserLoaded) {
        emit(UserLoaded(allUsers, currentPage, query: searchQuery));
      }
    });
  }
}
