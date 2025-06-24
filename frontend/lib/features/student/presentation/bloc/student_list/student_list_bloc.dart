import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/get_students.dart';

part 'student_list_event.dart';
part 'student_list_state.dart';

class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  final GetStudents getStudents;
  
  // Pagination state
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasReachedMax = false;
  String? _searchQuery;
  String? _sortBy;
  bool _ascending = true;
  
  StudentListBloc({
    required this.getStudents,
  }) : super(StudentListInitial()) {
    on<FetchStudents>(_onFetchStudents);
    on<RefreshStudents>(_onRefreshStudents);
    on<SearchStudents>(_onSearchStudents);
    on<SortStudents>(_onSortStudents);
  }

  Future<void> _onFetchStudents(
    FetchStudents event,
    Emitter<StudentListState> emit,
  ) async {
    // If we're already at max, do nothing
    if (_hasReachedMax) return;
    
    // If this is the initial load, show loading
    if (_currentPage == 1) {
      emit(StudentListLoading());
    }
    
    // Get the current state
    final currentState = state;
    List<Student> currentStudents = [];
    
    // If we already have some students, use them
    if (currentState is StudentListLoaded) {
      currentStudents = currentState.students;
    }
    
    try {
      final result = await getStudents(GetStudentsParams(
        page: _currentPage,
        limit: _itemsPerPage,
        searchQuery: _searchQuery,
        sortBy: _sortBy,
        ascending: _ascending,
      ));
      
      await result.fold(
        (failure) {
          emit(StudentListError(
            message: _mapFailureToMessage(failure),
            students: currentStudents,
          ));
        },
        (newStudents) async {
          if (newStudents.isEmpty) {
            _hasReachedMax = true;
            if (_currentPage == 1) {
              emit(StudentListEmpty());
            } else {
              emit(StudentListLoaded(
                students: currentStudents,
                hasReachedMax: true,
              ));
            }
          } else {
            _currentPage++;
            final students = currentStudents + newStudents;
            emit(StudentListLoaded(
              students: students,
              hasReachedMax: newStudents.length < _itemsPerPage,
            ));
          }
        },
      );
    } catch (e) {
      emit(StudentListError(
        message: 'An unexpected error occurred',
        students: currentStudents,
      ));
    }
  }
  
  Future<void> _onRefreshStudents(
    RefreshStudents event,
    Emitter<StudentListState> emit,
  ) async {
    _currentPage = 1;
    _hasReachedMax = false;
    
    add(FetchStudents());
  }
  
  Future<void> _onSearchStudents(
    SearchStudents event,
    Emitter<StudentListState> emit,
  ) async {
    _currentPage = 1;
    _hasReachedMax = false;
    _searchQuery = event.query;
    
    add(FetchStudents());
  }
  
  Future<void> _onSortStudents(
    SortStudents event,
    Emitter<StudentListState> emit,
  ) async {
    _currentPage = 1;
    _hasReachedMax = false;
    _sortBy = event.sortBy;
    _ascending = event.ascending;
    
    add(FetchStudents());
  }
  
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'No internet connection';
      case UnauthorizedFailure:
        return 'Session expired. Please login again.';
      case ForbiddenFailure:
        return 'You do not have permission to perform this action';
      case NotFoundFailure:
        return 'Resource not found';
      default:
        return 'An unexpected error occurred';
    }
  }
}
