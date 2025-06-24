import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/users/domain/entities/user.dart';
import 'package:frontend/features/users/domain/usecases/search_users.dart';

part of 'user_search_bloc.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final SearchUsers searchUsers;
  Timer? _debounce;

  UserSearchBloc({required this.searchUsers}) : super(const UserSearchState()) {
    on<SearchUsers>(_onSearch);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearch(
    SearchUsers event,
    Emitter<UserSearchState> emit,
  ) async {
    final query = event.query.trim();
    
    if (query.isEmpty) {
      emit(const UserSearchState());
      return;
    }

    // Cancel previous debounce timer
    _debounce?.cancel();

    // Set loading state immediately for better UX
    if (state.query != query) {
      emit(state.copyWith(
        status: UserSearchStatus.loading,
        query: query,
      ));
    }

    // Add a delay before performing the search
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final result = await searchUsers(SearchParams(query: query));
      
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: UserSearchStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (users) => emit(
          state.copyWith(
            status: UserSearchStatus.success,
            searchResults: users,
          ),
        ),
      );
    });
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<UserSearchState> emit,
  ) {
    _debounce?.cancel();
    emit(const UserSearchState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
