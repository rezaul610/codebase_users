import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../bloc/bloc/user_bloc.dart';
import '../user_detail/user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  int currentPage = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(UserFetched(currentPage));
  }

  void _onRefresh() async {
    currentPage = 1;
    context.read<UserBloc>().add(UserRefresh(currentPage));
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.resetNoData();
    _refreshController.refreshCompleted();
  }

  void _onLoadMore() async {
    currentPage++;
    if (currentPage > context.read<UserBloc>().totalPage) {
      _refreshController.loadNoData();
      return;
    }
    context.read<UserBloc>().add(UserLoadMore(currentPage));
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<UserBloc>().add(SearchUser(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text('User List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserBloc>().add(UserFetched(1));
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            final users = state.filteredUsers;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        labelText: 'Search by Name',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffix: InkWell(
                          onTap: _clearSearch,
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Colors.red,
                          ),
                        )),
                    onChanged: (value) {
                      context.read<UserBloc>().add(SearchUser(value));
                    },
                  ),
                ),
                users.isEmpty
                    ? const Center(child: Text('No users found'))
                    : Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          enablePullUp: true,
                          onRefresh: _onRefresh,
                          onLoading: _onLoadMore,
                          header: const WaterDropMaterialHeader(),
                          footer: const ClassicFooter(
                            loadingText: 'Loading...',
                            noDataText: 'No more data',
                            idleText: 'Pull up to load more',
                          ),
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            UserDetailScreen(user: user),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.avatar!)),
                                  title: RichText(
                                    text: TextSpan(
                                        text: '${user.firstName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: ' ${user.lastName}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black),
                                          ),
                                        ]),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.red.shade400,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ],
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
