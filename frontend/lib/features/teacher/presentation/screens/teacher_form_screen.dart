import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';
import 'package:sim_java_frontend/core/utils/date_utils.dart';
import 'package:sim_java_frontend/core/widgets/custom_app_bar.dart';
import 'package:sim_java_frontend/core/widgets/loading_indicator.dart';
import 'package:sim_java_frontend/core/widgets/primary_button.dart';
import 'package:sim_java_frontend/features/teacher/domain/entities/teacher.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_form/teacher_form_bloc.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_form/teacher_form_event.dart';
import 'package:sim_java_frontend/features/teacher/presentation/bloc/teacher_form/teacher_form_state.dart';
import 'package:sim_java_frontend/features/teacher/presentation/widgets/teacher_form_fields.dart';
import 'package:sim_java_frontend/generated/l10n.dart';

class TeacherFormScreen extends StatefulWidget {
  final Teacher? teacher;

  const TeacherFormScreen({
    Key? key,
    this.teacher,
  }) : super(key: key);

  @override
  State<TeacherFormScreen> createState() => _TeacherFormScreenState();
}

class _TeacherFormScreenState extends State<TeacherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nipController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _joinDateController = TextEditingController();
  String? _selectedGender;
  String? _selectedStatus;
  final List<String> _selectedSubjects = [];
  final List<String> _selectedClasses = [];
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    if (widget.teacher != null) {
      _initializeForm(widget.teacher!);
    } else {
      _joinDateController.text = AppDateUtils.formatDate(DateTime.now());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _joinDateController.dispose();
    super.dispose();
  }

  void _initializeForm(Teacher teacher) {
    _nameController.text = teacher.name;
    _nipController.text = teacher.nip;
    _emailController.text = teacher.email ?? '';
    _phoneController.text = teacher.phone ?? '';
    _addressController.text = teacher.address ?? '';
    _birthDateController.text = teacher.birthDate != null
        ? AppDateUtils.formatDate(teacher.birthDate!)
        : '';
    _joinDateController.text = teacher.joinDate != null
        ? AppDateUtils.formatDate(teacher.joinDate!)
        : AppDateUtils.formatDate(DateTime.now());
    _selectedGender = teacher.gender;
    _selectedStatus = teacher.status;
    if (teacher.subjects != null) {
      _selectedSubjects.addAll(teacher.subjects!);
    }
    if (teacher.classes != null) {
      _selectedClasses.addAll(teacher.classes!);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
      context.read<TeacherFormBloc>().add(TeacherPhotoChanged(_photoPath));
    }
  }

  void _removeImage() {
    setState(() {
      _photoPath = null;
    });
    context.read<TeacherFormBloc>().add(const TeacherPhotoRemoved());
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? AppDateUtils.parseDate(controller.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = AppDateUtils.formatDate(picked);
    }
  }

  void _onGenderChanged(String? value) {
    setState(() {
      _selectedGender = value;
    });
  }

  void _onStatusChanged(String? value) {
    setState(() {
      _selectedStatus = value;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final teacher = Teacher(
        id: widget.teacher?.id ?? '',
        nip: _nipController.text.trim(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        birthDate: _birthDateController.text.isNotEmpty
            ? AppDateUtils.parseDate(_birthDateController.text)
            : null,
        gender: _selectedGender,
        photoUrl: _photoPath,
        joinDate: _joinDateController.text.isNotEmpty
            ? AppDateUtils.parseDate(_joinDateController.text)
            : DateTime.now(),
        status: _selectedStatus,
        subjects: _selectedSubjects.isNotEmpty ? _selectedSubjects : null,
        classes: _selectedClasses.isNotEmpty ? _selectedClasses : null,
      );

      context.read<TeacherFormBloc>().add(
            TeacherFormSubmitted(
              teacher: teacher,
              isEditing: widget.teacher != null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final isEditMode = widget.teacher != null;

    return BlocListener<TeacherFormBloc, TeacherFormState>(
      listener: (context, state) {
        if (state.isSubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditMode ? s.teacherUpdated : s.teacherAdded),
              backgroundColor: theme.colorScheme.primary,
            ),
          );
          context.pop();
        } else if (state.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? s.somethingWentWrong),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(isEditMode ? s.editTeacher : s.addTeacher),
          actions: [
            if (isEditMode)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // TODO: Implement delete functionality
                },
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Photo Section
                _buildPhotoSection(theme, s),
                SizedBox(height: 24.h),

                // Personal Information
                Text(
                  s.personalInformation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Name
                TeacherTextFormField(
                  controller: _nameController,
                  label: s.fullName,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return s.pleaseEnterName;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // NIP
                TeacherTextFormField(
                  controller: _nipController,
                  label: 'NIP',
                  prefixIcon: Icons.badge_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter NIP';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Email
                TeacherTextFormField(
                  controller: _emailController,
                  label: s.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return s.pleaseEnterValidEmail;
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Phone
                TeacherTextFormField(
                  controller: _phoneController,
                  label: s.phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),
                SizedBox(height: 16.h),

                // Gender
                TeacherDropdownField<String>(
                  value: _selectedGender,
                  items: const ['Male', 'Female', 'Other'],
                  onChanged: _onGenderChanged,
                  label: s.gender,
                  prefixIcon: Icons.transgender,
                ),
                SizedBox(height: 16.h),

                // Birth Date
                TeacherTextFormField(
                  controller: _birthDateController,
                  label: s.birthDate,
                  readOnly: true,
                  onTap: () => _selectDate(_birthDateController),
                  prefixIcon: Icons.calendar_today_outlined,
                ),
                SizedBox(height: 16.h),

                // Join Date
                TeacherTextFormField(
                  controller: _joinDateController,
                  label: s.joinDate,
                  readOnly: true,
                  onTap: () => _selectDate(_joinDateController),
                  prefixIcon: Icons.date_range_outlined,
                ),
                SizedBox(height: 16.h),

                // Status
                TeacherDropdownField<String>(
                  value: _selectedStatus,
                  items: const ['Active', 'Inactive', 'On Leave'],
                  onChanged: _onStatusChanged,
                  label: s.status,
                  prefixIcon: Icons.work_outline,
                ),
                SizedBox(height: 16.h),

                // Address
                TeacherTextFormField(
                  controller: _addressController,
                  label: s.address,
                  maxLines: 3,
                  prefixIcon: Icons.location_on_outlined,
                ),
                SizedBox(height: 24.h),

                // Submit Button
                BlocBuilder<TeacherFormBloc, TeacherFormState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      onPressed: state.isSubmitting ? null : _onSubmit,
                      child: state.isSubmitting
                          ? const LoadingIndicator()
                          : Text(isEditMode ? s.update : s.save),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(ThemeData theme, S s) {
    return Center(
      child: Column(
        children: [
          Stack(
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
                  child: _photoPath != null
                      ? Image.file(
                          File(_photoPath!),
                          fit: BoxFit.cover,
                        )
                      : widget.teacher?.photoUrl != null
                          ? Image.network(
                              widget.teacher!.photoUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Icon(
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
              // Edit Button
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.camera_alt,
                      size: 20.r,
                      color: theme.colorScheme.onPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          if (_photoPath != null ||
              (widget.teacher?.photoUrl?.isNotEmpty ?? false))
            TextButton(
              onPressed: _removeImage,
              child: Text(
                s.removePhoto,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
