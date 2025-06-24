import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sim_java_frontend/core/utils/theme_utils.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';

class StudentListItem extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StudentListItem({
    Key? key,
    required this.student,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              // Student Avatar
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.1),
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
                        size: 24.r,
                        color: colorScheme.primary,
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      student.nisn,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.class_,
                          size: 12.r,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          student.className,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20.r,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20.r),
                            SizedBox(width: 8.w),
                            const Text('Edit'),
                          ],
                        ),
                        onTap: () => Future.delayed(
                          Duration.zero,
                          onEdit!,
                        ),
                      ),
                    if (onDelete != null)
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20.r, color: Colors.red),
                            SizedBox(width: 8.w),
                            const Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: () => Future.delayed(
                          Duration.zero,
                          onDelete!,
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
}
