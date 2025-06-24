import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sim_java_frontend/core/utils/theme_utils.dart';
import 'package:sim_java_frontend/core/widgets/app_bar/custom_app_bar.dart';
import 'package:sim_java_frontend/core/widgets/error_state.dart';
import 'package:sim_java_frontend/core/widgets/loading_indicator.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_detail/student_detail_bloc.dart';
import 'package:sim_java_frontend/features/student/presentation/widgets/student_info_card.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;

  const StudentDetailScreen({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load student data when screen initializes
    context.read<StudentDetailBloc>().add(LoadStudent(widget.studentId));
  }

  void _onRefresh() {
    context.read<StudentDetailBloc>().add(RefreshStudent());
  }

  void _onEdit() {
    // Navigate to edit screen
    // final student = (context.read<StudentDetailBloc>().state as StudentDetailLoaded).student;
    // NavigationUtils.pushNamed(
    //   context,
    //   Routes.editStudent,
    //   arguments: {'student': student},
    // );
  }


  void _onDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text('Are you sure you want to delete this student? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              context.read<StudentDetailBloc>().add(DeleteStudentEvent());
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentDetailBloc, StudentDetailState>(
      listener: (context, state) {
        if (state is StudentDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is StudentDetailDeleted) {
          Navigator.pop(context, true); // Return true to indicate deletion
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Student Details',
          showBackButton: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _onDelete,
            ),
          ],
        ),
        body: BlocBuilder<StudentDetailBloc, StudentDetailState>(
          builder: (context, state) {
            if (state is StudentDetailLoading) {
              return const Center(child: LoadingIndicator());
            } else if (state is StudentDetailError) {
              return ErrorState(
                message: state.message,
                onRetry: _onRefresh,
              );
            } else if (state is StudentDetailLoaded) {
              return _buildStudentDetail(state.student);
            } else if (state is StudentDetailDeleted) {
              return const Center(child: Text('Student deleted successfully'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStudentDetail(Student student) {
    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 120.r,
                    height: 120.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      image: student.photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(student.photoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: student.photoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 60.r,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  // Name
                  Text(
                    student.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  // NISN
                  Text(
                    'NISN: ${student.nisn}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
            
            // Student Info Cards
            StudentInfoCard(
              icon: Icons.email_outlined,
              title: 'Email',
              value: student.email,
            ),
            StudentInfoCard(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: student.phone ?? 'Not provided',
            ),
            StudentInfoCard(
              icon: Icons.calendar_today_outlined,
              title: 'Date of Birth',
              value: student.birthDate != null
                  ? '${student.birthDate!.day}/${student.birthDate!.month}/${student.birthDate!.year}'
                  : 'Not provided',
            ),
            StudentInfoCard(
              icon: Icons.person_outline,
              title: 'Gender',
              value: student.gender.isNotEmpty
                  ? '${student.gender[0].toUpperCase()}${student.gender.substring(1)}'
                  : 'Not provided',
            ),
            StudentInfoCard(
              icon: Icons.class_outlined,
              title: 'Class',
              value: student.className,
            ),
            if (student.address?.isNotEmpty ?? false) ...[
              StudentInfoCard(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: student.address!,
                showDivider: false,
              ),
            ],
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
          ],
        ),
      ),
    );
  }
}
