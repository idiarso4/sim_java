import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/get_teachers.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/search_teachers.dart';

part 'teacher_list_event.dart';
part 'teacher_list_state.dart';

const _teachersPerPage = 10;

class TeacherListBloc extends Bloc<TeacherListEvent, TeacherListState> {
  final GetTeachers getTeachers;
  final SearchTeachers searchTeachers;

  TeacherListBloc({
    required this.getTeachers,
    required this.searchTeachers,
  }) : super(TeacherListInitial()) {
    on<LoadTeachers>(_onLoadTeachers);
    on<RefreshTeachers>(_onRefreshTeachers);
    on<SearchTeachersEvent>(_onSearchTeachers);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadTeachers(
    LoadTeachers event,
    Emitter<TeacherListState> emit,
  ) async {
    try {
      final currentState = state;
      
      if (event.refresh) {
        // If refreshing, start with empty list
        emit(TeacherListLoading([], isFirstPage: true));
      } else if (currentState is TeacherListLoaded && currentState.hasReachedMax) {
        // If we've reached the max, don't load more
        return;
      } else if (currentState is! TeacherListLoading) {
        // Otherwise, show loading with current items
        emit(TeacherListLoading(
          currentState is TeacherListLoaded ? currentState.teachers : [],
          isFirstPage: currentState is! TeacherListLoaded,
        ));
      }

      final failureOrTeachers = await getTeachers(
        page: event.refresh ? 1 : (currentState is TeacherListLoaded ? currentState.page + 1 : 1),
        limit: _teachersPerPage,
        searchQuery: event.searchQuery,
      );

      await failureOrTeachers.fold(
        (failure) async* {
          yield TeacherListError(
            _mapFailureToMessage(failure),
            oldTeachers: currentState is TeacherListLoaded ? currentState.teachers : [],
          );
        },
        (teachers) async* {
          if (teachers.isEmpty) {
            yield currentState is TeacherListLoaded
                ? currentState.copyWith(hasReachedMax: true)
                : const TeacherListLoaded(teachers: [], hasReachedMax: true);
          } else {
            final hasReachedMax = teachers.length < _teachersPerPage;
            final updatedTeachers = event.refresh || currentState is! TeacherListLoaded
                ? teachers
                : (currentState as TeacherListLoaded).teachers + teachers;

            yield TeacherListLoaded(
              teachers: updatedTeachers,
              hasReachedMax: hasReachedMax,
              page: event.refresh ? 1 : (currentState is TeacherListLoaded ? currentState.page + 1 : 1),
              searchQuery: event.searchQuery,
            );
          }
        },
      );
    } catch (e) {
      emit(TeacherListError(
        'An unexpected error occurred',
        oldTeachers: state is TeacherListLoaded ? (state as TeacherListLoaded).teachers : [],
      ));
    }
  }

  Future<void> _onRefreshTeachers(
    RefreshTeachers event,
    Emitter<TeacherListState> emit,
  ) async {
    add(LoadTeachers(refresh: true, searchQuery: event.searchQuery));
  }

  Future<void> _onSearchTeachers(
    SearchTeachersEvent event,
    Emitter<TeacherListState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadTeachers(refresh: true));
      return;
    }

    try {
      emit(const TeacherListLoading([], isFirstPage: true));

      final failureOrTeachers = await searchTeachers(event.query);

      await failureOrTeachers.fold(
        (failure) async* {
          yield TeacherListError(_mapFailureToMessage(failure));
        },
        (teachers) async* {
          yield TeacherListLoaded(
            teachers: teachers,
            hasReachedMax: true,
            page: 1,
            searchQuery: event.query,
          );
        },
      );
    } catch (e) {
      emit(TeacherListError('An unexpected error occurred'));
    }
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<TeacherListState> emit,
  ) {
    add(const LoadTeachers(refresh: true));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return 'No internet connection';
      default:
        return 'Unexpected error';
    }
  }
}
