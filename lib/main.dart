import 'package:codebase_users/bloc/bloc/user_bloc.dart';
import 'package:codebase_users/data/data_provider/user_data_provider.dart';
import 'package:codebase_users/data/data_provider/user_local_provider.dart';
import 'package:codebase_users/presentation/user_list/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repository/user_repository.dart';
import 'services/connectivity_service.dart';

void main() {
  final connectivityService = ConnectivityService();
  runApp(MyApp(
    connectivityService: connectivityService,
  ));
}

class MyApp extends StatelessWidget {
  final ConnectivityService connectivityService;
  const MyApp({super.key, required this.connectivityService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(
        userDataProvider: UserDataProvider(),
        userLocalProvider: UserLocalProvider(),
      ),
      child: BlocProvider(
        create: (context) => UserBloc(
          context.read<UserRepository>(),
          connectivityService,
        ),
        child: MaterialApp(
          title: 'Codebase User List',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.red,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              )),
          home: const UserListScreen(),
        ),
      ),
    );
  }
}
