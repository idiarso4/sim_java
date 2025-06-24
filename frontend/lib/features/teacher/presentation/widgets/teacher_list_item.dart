import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';

class TeacherListItem extends StatelessWidget {
  final Teacher teacher;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TeacherListItem({
    Key? key,
    required this.teacher,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              // Teacher Avatar
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  image: teacher.photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(teacher.photoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: teacher.photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 28.r,
                        color: theme.colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              SizedBox(width: 16.w),
              
              // Teacher Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'NIP: ${teacher.nip}',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (teacher.subjects?.isNotEmpty ?? false) ...[
                      SizedBox(height: 4.h),
                      Wrap(
                        spacing: 8.w,
                        children: teacher.subjects!
                            .take(2)
                            .map((subject) => _buildChip(context, subject))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Actions
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert,
                    size: 24.r,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20.r),
                          SizedBox(width: 8.w),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20.r, color: theme.colorScheme.error),
                          SizedBox(width: 8.w),
                          Text(
                            'Delete',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
