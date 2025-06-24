import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/widgets/loading_indicator.dart';
import 'package:frontend/features/users/domain/entities/user.dart';
import 'package:frontend/features/users/presentation/bloc/user_list/user_list_bloc.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserListBloc(
        getUsers: context.read(),
        deleteUser: context.read(),
      )..add(LoadUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Navigate to add user
              },
            ),
          ],
        ),
        body: const _UserListView(),
      ),
    );
  }
}

class _UserListView extends StatelessWidget {
  const _UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        if (state.status == UserListStatus.loading) {
          return const Center(child: LoadingIndicator());
        }

        if (state.status == UserListStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load users'),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Unknown error',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<UserListBloc>().add(LoadUsers()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.users.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return ListView.builder(
          itemCount: state.users.length,
          itemBuilder: (context, index) {
            final user = state.users[index];
            return _UserListTile(user: user);
          },
        );
      },
    );
  }
}

class _UserListTile extends StatelessWidget {
  final User user;

  const _UserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.name[0].toUpperCase()),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (value) {
          if (value == 'edit') {
            // TODO: Navigate to edit user
          } else if (value == 'delete') {
            _showDeleteConfirmation(context, user.id);
          }
        },
      ),
      onTap: () {
        // TODO: Navigate to user details
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserListBloc>().add(DeleteUser(userId));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
