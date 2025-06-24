import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mock.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/domain/usecases/get_students.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_list/student_list_bloc.dart';

// Generate mocks for the use cases
@GenerateMocks([GetStudents])
import 'student_list_bloc_test.mocks.dart';

void main() {
  late MockGetStudents mockGetStudents;
  late StudentListBloc studentListBloc;

  // Sample test data
  final tStudent = Student(
    id: '1',
    name: 'Test Student',
    email: 'test@example.com',
    phone: '1234567890',
  );
  final tStudentList = [tStudent];
  
  // Test parameters
  const tPage = 1;
  const tLimit = 10;
  const tQuery = 'test';
  const tSortBy = 'name';
  const tAscending = true;
  
  // Failures
  final tServerFailure = ServerFailure('Server Error');
  final tNetworkFailure = NetworkFailure('No internet');

  setUp(() {
    mockGetStudents = MockGetStudents();
    studentListBloc = StudentListBloc(
      getStudents: mockGetStudents,
    );
  });

  tearDown(() {
    studentListBloc.close();
  });

  group('StudentListBloc', () {
    test('initial state should be StudentListInitial', () {
      // Assert
      expect(studentListBloc.state, const StudentListInitial());
    });

    group('FetchStudents', () {
      blocTest<StudentListBloc, StudentListState>(
        'should emit [StudentListLoading, StudentListLoaded] when data is loaded successfully',
        build: () {
          when(mockGetStudents(any)).thenAnswer(
            (_) async => Right(tStudentList),
          );
          return studentListBloc;
        },
        act: (bloc) => bloc.add(const FetchStudents()),
        expect: () => [
          const StudentListLoading(),
          StudentListLoaded(students: tStudentList, hasReachedMax: true),
        ],
        verify: (_) {
          verify(mockGetStudents(GetStudentsParams(
            page: 1,
            limit: 10,
            searchQuery: null,
            sortBy: null,
            ascending: true,
          )));
        },
      );

      blocTest<StudentListBloc, StudentListState>(
        'should emit [StudentListLoading, StudentListError] when getting data fails',
        build: () {
          when(mockGetStudents(any)).thenAnswer(
            (_) async => Left(tServerFailure),
          );
          return studentListBloc;
        },
        act: (bloc) => bloc.add(const FetchStudents()),
        expect: () => [
          const StudentListLoading(),
          StudentListError(message: 'Server error: Server Error'),
        ],
      );

      blocTest<StudentListBloc, StudentListState>(
        'should load more students when fetching next page',
        build: () {
          when(mockGetStudents(any)).thenAnswer((invocation) async {
            final params = invocation.positionalArguments.first as GetStudentsParams;
            if (params.page == 1) {
              return Right(tStudentList);
            } else {
              return Right([tStudent, tStudent]);
            }
          });
          return studentListBloc;
        },
        act: (bloc) {
          bloc.add(const FetchStudents());
          bloc.add(const FetchStudents());
        },
        expect: () => [
          const StudentListLoading(),
          StudentListLoaded(students: tStudentList, hasReachedMax: true),
          StudentListLoaded(students: [...tStudentList, ...tStudentList], hasReachedMax: true),
        ],
      );
    });

    group('RefreshStudents', () {
      blocTest<StudentListBloc, StudentListState>(
        'should reset pagination and fetch first page',
        build: () {
          when(mockGetStudents(any)).thenAnswer(
            (_) async => Right(tStudentList),
          );
          return studentListBloc;
        },
        act: (bloc) {
          // First load
          bloc.add(const FetchStudents());
          // Then refresh
          bloc.add(const RefreshStudents());
        },
        expect: () => [
          const StudentListLoading(),
          StudentListLoaded(students: tStudentList, hasReachedMax: true),
          // After refresh, should show loading and then loaded again
          const StudentListLoading(),
          StudentListLoaded(students: tStudentList, hasReachedMax: true),
        ],
        verify: (_) {
          // Should be called twice: once for initial load, once for refresh
          verify(mockGetStudents(any)).called(2);
        },
      );
    });

    group('SearchStudents', () {
      blocTest<StudentListBloc, StudentListState>(
        'should update search query and fetch students',
        build: () {
          when(mockGetStudents(any)).thenAnswer(
            (_) async => Right(tStudentList),
          );
          return studentListBloc;
        },
        act: (bloc) => bloc.add(const SearchStudents(tQuery)),
        expect: () => [
          const StudentListLoading(),
          StudentListLoaded(students: tStudentList, hasReachedMax: true),
        ],
        verify: (_) {
          verify(mockGetStudents(GetStudentsParams(
            page: 1,
            limit: 10,
            searchQuery: tQuery,
            sortBy: null,
            ascending: true,
          )));
        },
      );
    });

    group('SortStudents', () {
      blocTest<StudentListBloc, StudentListState>(
        'should update sort parameters and fetch students',
        build: () {
          when(mockGetStudents(any)).thenAnswer(
            (_) async => Right(tStudentList),
          );
          return studentListBloc;
        },
        act: (bloc) => bloc.add(const SortStudents(
          sortBy: tSortBy,
          ascending: tAscending,
        )),
        expect: () => [
          const StudentListLoading(),
          StudentListLoaded(students: tStudentList, hasReachedMax: true),
        ],
        verify: (_) {
          verify(mockGetStudents(GetStudentsParams(
            page: 1,
            limit: 10,
            searchQuery: null,
            sortBy: tSortBy,
            ascending: tAscending,
          )));
        },
      );
    });

    group('Error Handling', () {
      blocTest<StudentListBloc, StudentListState>(
        'should handle network failure',
        build: () {
          when(mockGetStudents(any)).thenAnswer(
            (_) async => Left(tNetworkFailure),
          );
          return studentListBloc;
        },
        act: (bloc) => bloc.add(const FetchStudents()),
        expect: () => [
          const StudentListLoading(),
          const StudentListError(message: 'No internet connection'),
        ],
      );

      blocTest<StudentListBloc, StudentListState>(
        'should preserve existing students on error after initial load',
        build: () {
          when(mockGetStudents(any)).thenAnswer((invocation) async {
            final params = invocation.positionalArguments.first as GetStudentsParams;
            if (params.page == 1) {
              return Right(tStudentList);
            } else {
              return Left(tServerFailure);
            }
          });
          return studentListBloc;
        },
        act: (bloc) {
          // First load succeeds
          bloc.add(const FetchStudents());
          // Second load fails
          bloc.add(const FetchStudents());
        },
        expect: () => [
          const StudentListLoading(),
          StudentListLoaded(students: tStudentList, hasReachedMax: true),
          StudentListError(
            message: 'Server error: Server Error',
            students: tStudentList,
          ),
        ],
      );
    });
  });
}
