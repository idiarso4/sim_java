import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/domain/usecases/search_teachers.dart';

part 'teacher_search_event.dart';
part 'teacher_search_state.dart';

const _searchDelay = Duration(milliseconds: 300);
const _minQueryLength = 1;

class TeacherSearchBloc extends Bloc<TeacherSearchEvent, TeacherSearchState> {
  final SearchTeachers searchTeachers;
  final int maxResults;

  TeacherSearchBloc({
    required this.searchTeachers,
    this.maxResults = 10,
  }) : super(const TeacherSearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(_searchDelay)
          .distinct()
          .switchMap(mapper),
    );
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<TeacherSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const TeacherSearchInitial());
      return;
    }

    if (query.length < _minQueryLength) {
      return;
    }

    emit(TeacherSearchLoading(
      query: query,
      teachers: state.teachers,
    ));

    await _performSearch(query, emit);
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<TeacherSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const TeacherSearchInitial());
      return;
    }

    if (query.length < _minQueryLength) {
      return;
    }

    emit(TeacherSearchLoading(
      query: query,
      teachers: state.teachers,
    ));

    await _performSearch(query, emit);
  }

  Future<void> _performSearch(
    String query,
    Emitter<TeacherSearchState> emit,
  ) async {
    try {
      final failureOrTeachers = await searchTeachers(query);

      await failureOrTeachers.fold(
        (failure) async* {
          yield TeacherSearchError(
            message: _mapFailureToMessage(failure),
            query: query,
            teachers: state.teachers,
          );
        },
        (teachers) async* {
          if (teachers.isEmpty) {
            yield TeacherSearchEmpty(
              message: 'No teachers found for "$query"',
              query: query,
            );
          } else {
            final limitedTeachers = teachers.take(maxResults).toList();
            yield TeacherSearchSuccess(
              query: query,
              teachers: limitedTeachers,
              hasReachedMax: limitedTeachers.length < maxResults,
            );
          }
        },
      );
    } catch (e) {
      emit(TeacherSearchError(
        message: 'An unexpected error occurred',
        query: query,
        teachers: state.teachers,
      ));
    }
  }

  void _onSearchCleared(
    SearchCleared event,
    Emitter<TeacherSearchState> emit,
  ) {
    emit(const TeacherSearchInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case NetworkFailure:
        return 'No internet connection';
      default:
        return 'An unexpected error occurred';
    }
  }
}
