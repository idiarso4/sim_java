import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';
import 'package:sim_java_frontend/core/widgets/custom_app_bar.dart';
import 'package:sim_java_frontend/core/widgets/empty_state.dart';
import 'package:sim_java_frontend/core/widgets/error_state.dart';
import 'package:sim_java_frontend/core/widgets/loading_indicator.dart';
import 'package:sim_java_frontend/core/widgets/primary_button.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_list/teacher_list_bloc.dart';
import 'package:sim_java_frontend/features/teacher/presentation/widgets/teacher_list_item.dart';
import 'package:sim_java_frontend/generated/l10n.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({Key? key}) : super(key: key);

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    context.read<TeacherListBloc>().add(const LoadTeachers());
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TeacherListBloc>().add(
            LoadTeachers(
              searchQuery: _searchController.text.isNotEmpty
                  ? _searchController.text
                  : null,
            ),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: S.of(context).searchTeachers,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<TeacherListBloc>().add(const LoadTeachers(refresh: true));
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            context.read<TeacherListBloc>().add(const LoadTeachers(refresh: true));
          } else {
            context.read<TeacherListBloc>().add(LoadTeachers(
                  refresh: true,
                  searchQuery: value,
                ));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: _showSearch ? null : Text(s.teachers),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  context.read<TeacherListBloc>().add(const LoadTeachers(refresh: true));
                }
              });
            },
          ),
          if (!_showSearch)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<TeacherListBloc>().add(const LoadTeachers(refresh: true));
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (_showSearch) _buildSearchBar(),
          Expanded(
            child: BlocBuilder<TeacherListBloc, TeacherListState>(
              builder: (context, state) {
                if (state is TeacherListInitial) {
                  return const Center(child: LoadingIndicator());
                } else if (state is TeacherListLoading && state.isFirstPage) {
                  return const Center(child: LoadingIndicator());
                } else if (state is TeacherListError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: () => _loadInitialData(),
                  );
                } else if (state is TeacherListLoaded && state.teachers.isEmpty) {
                  return EmptyState(
                    message: s.noTeachersFound,
                    onRetry: _loadInitialData,
                  );
                } else if (state is TeacherListLoaded) {
                  return _buildTeacherList(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/teachers/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTeacherList(TeacherListLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TeacherListBloc>().add(
              LoadTeachers(
                refresh: true,
                searchQuery: _searchController.text.isNotEmpty
                    ? _searchController.text
                    : null,
              ),
            );
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 80.h),
        itemCount: state.hasReachedMax
            ? state.teachers.length
            : state.teachers.length + 1,
        itemBuilder: (context, index) {
          if (index >= state.teachers.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final teacher = state.teachers[index];
          return TeacherListItem(
            teacher: teacher,
            onTap: () {
              context.push('/teachers/${teacher.id}');
            },
            onEdit: () {
              context.push('/teachers/${teacher.id}/edit');
            },
            onDelete: () {
              _showDeleteConfirmation(context, teacher);
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, Teacher teacher) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteTeacher),
        content: Text(
            S.of(context).areYouSureYouWantToDeleteTeacher(teacher.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement delete functionality
      // context.read<TeacherBloc>().add(DeleteTeacher(teacher.id));
    }
  }
}
