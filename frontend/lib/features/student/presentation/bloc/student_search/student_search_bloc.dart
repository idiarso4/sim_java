import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/get_students.dart';

part 'student_search_event.dart';
part 'student_search_state.dart';

class StudentSearchBloc extends Bloc<StudentSearchEvent, StudentSearchState> {
  final GetStudents getStudents;
  
  // Debounce timer for search
  Timer? _debounce;
  
  StudentSearchBloc({
    required this.getStudents,
  }) : super(StudentSearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchCleared>(_onSearchCleared);
  }
  
  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<StudentSearchState> emit,
  ) async {
    // Cancel any existing debounce timer
    _debounce?.cancel();
    
    // If query is empty, clear results
    if (event.query.isEmpty) {
      emit(StudentSearchInitial());
      return;
    }
    
    // Set loading state
    emit(StudentSearchLoading(query: event.query));
    
    // Set up debounce (500ms)
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final result = await getStudents(
          GetStudentsParams(
            page: 1,
            limit: 10, // Limit results for search
            searchQuery: event.query,
          ),
        );
        
        result.fold(
          (failure) => emit(StudentSearchError(
            message: _mapFailureToMessage(failure),
            query: event.query,
          )),
          (students) => emit(students.isEmpty
              ? StudentSearchEmpty(query: event.query)
              : StudentSearchSuccess(
                  students: students,
                  query: event.query,
                ),
          ),
        );
      } catch (e) {
        emit(StudentSearchError(
          message: 'An unexpected error occurred',
          query: event.query,
        ));
      }
    });
  }
  
  void _onSearchCleared(
    SearchCleared event,
    Emitter<StudentSearchState> emit,
  ) {
    _debounce?.cancel();
    emit(StudentSearchInitial());
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
      default:
        return 'An error occurred while searching';
    }
  }
}
