import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';
import 'package:sim_java_frontend/core/widgets/custom_app_bar.dart';
import 'package:sim_java_frontend/core/widgets/error_state.dart';
import 'package:sim_java_frontend/core/widgets/loading_indicator.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_detail/teacher_detail_bloc.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_detail/teacher_detail_event.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_detail/teacher_detail_state.dart';
import 'package:sim_java_frontend/generated/l10n.dart';

class TeacherDetailScreen extends StatefulWidget {
  final String teacherId;

  const TeacherDetailScreen({
    Key? key,
    required this.teacherId,
  }) : super(key: key);

  @override
  State<TeacherDetailScreen> createState() => _TeacherDetailScreenState();
}

class _TeacherDetailScreenState extends State<TeacherDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadTeacher();
  }

  void _loadTeacher() {
    context.read<TeacherDetailBloc>().add(LoadTeacher(widget.teacherId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(s.teacherDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/teachers/${widget.teacherId}/edit');
            },
          ),
        ],
      ),
      body: BlocConsumer<TeacherDetailBloc, TeacherDetailState>(
        listener: (context, state) {
          if (state is TeacherDeletionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          } else if (state is TeacherDeletionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TeacherDetailLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is TeacherDetailLoadFailure) {
            return ErrorState(
              message: state.message,
              onRetry: _loadTeacher,
            );
          } else if (state is TeacherDetailLoadSuccess) {
            return _buildTeacherDetails(state.teacher, theme, s);
          } else if (state is TeacherDeletionInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTeacherDetails(Teacher teacher, ThemeData theme, S s) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                // Profile Image
                Container(
                  width: 120.r,
                  height: 120.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2.w,
                    ),
                  ),
                  child: ClipOval(
                    child: teacher.photoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: teacher.photoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 60.r,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60.r,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Name
                Text(
                  teacher.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                // NIP
                Text(
                  'NIP: ${teacher.nip}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),

          // Personal Information
          _buildSectionTitle(s.personalInformation, theme),
          _buildInfoRow(Icons.email, s.email, teacher.email ?? '-', theme),
          _buildInfoRow(Icons.phone, s.phone, teacher.phone ?? '-', theme),
          _buildInfoRow(Icons.cake, s.birthDate, 
              teacher.birthDate?.toIso8601String().split('T').first ?? '-', theme),
          _buildInfoRow(Icons.transgender, s.gender, teacher.gender ?? '-', theme),
          _buildInfoRow(Icons.calendar_today, s.joinDate, 
              teacher.joinDate?.toIso8601String().split('T').first ?? '-', theme),
          _buildInfoRow(Icons.badge, s.status, teacher.status ?? '-', theme),
          
          if (teacher.address?.isNotEmpty ?? false) ...[
            _buildInfoRow(
              Icons.location_on,
              s.address,
              teacher.address!,
              theme,
              maxLines: 3,
            ),
          ],

          // Subjects
          if (teacher.subjects?.isNotEmpty ?? false) ...[
            _buildSectionTitle(s.subjects, theme),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: teacher.subjects!
                  .map((subject) => _buildChip(subject, theme))
                  .toList(),
            ),
          ],

          // Classes
          if (teacher.classes?.isNotEmpty ?? false) ...[
            _buildSectionTitle(s.classes, theme),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: teacher.classes!
                  .map((cls) => _buildChip(cls, theme))
                  .toList(),
            ),
          ],

          // Action Buttons
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement contact functionality
                  },
                  icon: const Icon(Icons.message),
                  label: Text(s.message),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement call functionality
                  },
                  icon: const Icon(Icons.call),
                  label: Text(s.call),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {
              _showDeleteConfirmation(context, teacher);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
            ),
            icon: const Icon(Icons.delete),
            label: Text(s.deleteTeacher),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, ThemeData theme,
      {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.r,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
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
      // Trigger delete event
      context.read<TeacherDetailBloc>().add(DeleteTeacherEvent(teacher.id));
    }
  }
}
