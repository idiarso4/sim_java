import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/users/domain/entities/user.dart';
import 'package:frontend/features/users/domain/usecases/delete_user.dart';
import 'package:frontend/features/users/domain/usecases/get_users.dart';
import 'package:frontend/features/users/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for the use cases
@GenerateMocks([GetUsers, DeleteUser])
import 'user_list_bloc_test.mocks.dart';

void main() {
  late MockGetUsers mockGetUsers;
  late MockDeleteUser mockDeleteUser;
  late UserListBloc userListBloc;

  // Sample test data
  final tUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    role: 'admin',
  );
  final tUserList = [tUser];
  final tUserId = '1';
  final tServerFailure = ServerFailure('Server Error');

  setUp(() {
    mockGetUsers = MockGetUsers();
    mockDeleteUser = MockDeleteUser();
    userListBloc = UserListBloc(
      getUsers: mockGetUsers,
      deleteUser: mockDeleteUser,
    );
  });

  tearDown(() {
    userListBloc.close();
  });

  group('UserListBloc', () {
    test('initial state should be UserListInitial', () {
      // Assert
      expect(
        userListBloc.state,
        const UserListState(
          status: UserListStatus.initial,
          users: [],
          errorMessage: null,
        ),
      );
    });

    group('LoadUsers', () {
      blocTest<UserListBloc, UserListState>(
        'should emit [loading, success] when data is loaded successfully',
        build: () {
          when(mockGetUsers())
              .thenAnswer((_) async => Right(tUserList));
          return userListBloc;
        },
        act: (bloc) => bloc.add(LoadUsers()),
        expect: () => [
          const UserListState(
            status: UserListStatus.loading,
            users: [],
            errorMessage: null,
          ),
          UserListState(
            status: UserListStatus.success,
            users: tUserList,
            errorMessage: null,
          ),
        ],
        verify: (_) {
          verify(mockGetUsers());
        },
      );

      blocTest<UserListBloc, UserListState>(
        'should emit [loading, failure] when getting data fails',
        build: () {
          when(mockGetUsers())
              .thenAnswer((_) async => Left(tServerFailure));
          return userListBloc;
        },
        act: (bloc) => bloc.add(LoadUsers()),
        expect: () => [
          const UserListState(
            status: UserListStatus.loading,
            users: [],
            errorMessage: null,
          ),
          UserListState(
            status: UserListStatus.failure,
            users: const [],
            errorMessage: tServerFailure.message,
          ),
        ],
      );
    });

    group('DeleteUser', () {
      blocTest<UserListBloc, UserListState>(
        'should call delete use case and reload users on success',
        build: () {
          when(mockDeleteUser(any))
              .thenAnswer((_) async => const Right(null));
          when(mockGetUsers())
              .thenAnswer((_) async => Right(tUserList));
          return userListBloc;
        },
        act: (bloc) => bloc.add(DeleteUser(tUserId)),
        verify: (_) {
          verify(mockDeleteUser(Params(id: tUserId))).called(1);
          verify(mockGetUsers()).called(1);
        },
      );

      blocTest<UserListBloc, UserListState>(
        'should emit [failure] when delete fails',
        build: () {
          when(mockDeleteUser(any))
              .thenAnswer((_) async => Left(tServerFailure));
          return userListBloc;
        },
        act: (bloc) => bloc.add(DeleteUser(tUserId)),
        expect: () => [
          UserListState(
            status: UserListStatus.failure,
            users: const [],
            errorMessage: tServerFailure.message,
          ),
        ],
      );
    });
  });
}
