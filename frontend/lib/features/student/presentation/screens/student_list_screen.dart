import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sim_java_frontend/core/utils/navigation_utils.dart';
import 'package:sim_java_frontend/core/widgets/app_bar/custom_app_bar.dart';
import 'package:sim_java_frontend/core/widgets/empty_state.dart';
import 'package:sim_java_frontend/core/widgets/error_state.dart';
import 'package:sim_java_frontend/core/widgets/loading_indicator.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_list/student_list_bloc.dart';
import 'package:sim_java_frontend/features/student/presentation/widgets/student_list_item.dart';
import 'package:sim_java_frontend/features/student/presentation/widgets/search_bar.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  late StudentListBloc _studentListBloc;

  @override
  void initState() {
    super.initState();
    _studentListBloc = context.read<StudentListBloc>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _studentListBloc.add(FetchStudents());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    _studentListBloc.add(SearchStudents(query));
  }

  void _onRefresh() {
    _studentListBloc.add(RefreshStudents());
  }

  void _onStudentTapped(Student student) {
    // Navigate to student detail
    // NavigationUtils.pushNamed(
    //   context,
    //   Routes.studentDetail,
    //   arguments: {'studentId': student.id},
    // );
  }


  void _onEditStudent(Student student) {
    // Navigate to edit student
    // NavigationUtils.pushNamed(
    //   context,
    //   Routes.editStudent,
    //   arguments: {'student': student},
    // );
  }


  void _onDeleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // context.read<StudentDetailBloc>().add(DeleteStudentEvent());
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _onAddStudent() {
    // Navigate to add student
    // NavigationUtils.pushNamed(context, Routes.addStudent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Students',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAddStudent,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _onRefresh(),
        child: Column(
          children: [
            // Search Bar
            SearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                _studentListBloc.add(const SearchStudents(''));
              },
            ),
            // Student List
            Expanded(
              child: BlocConsumer<StudentListBloc, StudentListState>(
                listener: (context, state) {
                  if (state is StudentListError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is StudentListInitial) {
                    return const Center(child: Text('Search for students...'));
                  } else if (state is StudentListLoading && state.students.isEmpty) {
                    return const Center(child: LoadingIndicator());
                  } else if (state is StudentListEmpty) {
                    return EmptyState(
                      message: 'No students found',
                      onRetry: _onRefresh,
                    );
                  } else if (state is StudentListError) {
                    return ErrorState(
                      message: state.message,
                      onRetry: _onRefresh,
                    );
                  } else if (state is StudentListLoaded) {
                    if (state.students.isEmpty) {
                      return const EmptyState(message: 'No students found');
                    }
                    return _buildStudentList(state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList(StudentListLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
      itemCount: state.hasReachedMax
          ? state.students.length
          : state.students.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.students.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: LoadingIndicator()),
          );
        }
        final student = state.students[index];
        return StudentListItem(
          student: student,
          onTap: () => _onStudentTapped(student),
          onEdit: () => _onEditStudent(student),
          onDelete: () => _onDeleteStudent(student),
        );
      },
    );
  }
}
