import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sim_java_frontend/core/utils/theme_utils.dart';
import 'package:sim_java_frontend/core/widgets/app_bar/custom_app_bar.dart';
import 'package:sim_java_frontend/core/widgets/loading_indicator.dart';
import 'package:sim_java_frontend/core/widgets/primary_button.dart';
import 'package:sim_java_frontend/features/student/domain/entities/student.dart';
import 'package:sim_java_frontend/features/student/presentation/bloc/student_form/student_form_bloc.dart';
import 'package:sim_java_frontend/features/student/presentation/widgets/date_picker_field.dart';
import 'package:sim_java_frontend/features/student/presentation/widgets/photo_picker.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({
    Key? key,
    this.student,
  }) : super(key: key);

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisnController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _classNameController = TextEditingController();
  
  String? _selectedGender;
  DateTime? _selectedDate;
  XFile? _pickedImage;
  
  @override
  void initState() {
    super.initState();
    _initializeForm();
  }
  
  void _initializeForm() {
    if (widget.student != null) {
      final student = widget.student!;
      _nisnController.text = student.nisn;
      _nameController.text = student.name;
      _emailController.text = student.email;
      _phoneController.text = student.phone ?? '';
      _addressController.text = student.address ?? '';
      _classNameController.text = student.className;
      _selectedGender = student.gender;
      _selectedDate = student.birthDate;
      
      // Note: For existing photo, we'll handle it in the PhotoPicker widget
    }
  }
  
  @override
  void dispose() {
    _nisnController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _classNameController.dispose();
    super.dispose();
  }
  
  void _onImagePicked(XFile? image) {
    setState(() {
      _pickedImage = image;
    });
  }
  
  void _onDateSelected(DateTime? date) {
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }
  
  void _onGenderSelected(String? gender) {
    setState(() {
      _selectedGender = gender;
    });
  }
  
  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    
    context.read<StudentFormBloc>().add(FormSubmitted(
          nisn: _nisnController.text.trim(),
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          birthDate: _selectedDate,
          gender: _selectedGender ?? '',
          className: _classNameController.text.trim(),
        ));
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.student != null;
    
    return BlocListener<StudentFormBloc, StudentFormState>(
      listener: (context, state) {
        if (state is StudentFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode 
                  ? 'Student updated successfully' 
                  : 'Student added successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is StudentFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: isEditMode ? 'Edit Student' : 'Add New Student',
          showBackButton: true,
        ),
        body: _buildForm(),
      ),
    );
  }
  
  Widget _buildForm() {
    return BlocBuilder<StudentFormBloc, StudentFormState>(
      builder: (context, state) {
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Photo Picker
                    Center(
                      child: PhotoPicker(
                        initialImageUrl: widget.student?.photoUrl,
                        onImagePicked: _onImagePicked,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    
                    // NISN
                    TextFormField(
                      controller: _nisnController,
                      decoration: const InputDecoration(
                        labelText: 'NISN',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      enabled: !isEditMode, // Disable for edit mode
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter NISN';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    
                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter student name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    
                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone (Optional)',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    
                    // Birth Date
                    DatePickerField(
                      initialDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                      label: 'Birth Date (Optional)',
                    ),
                    SizedBox(height: 16.h),
                    
                    // Gender
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: _onGenderSelected,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select gender';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    
                    // Class
                    TextFormField(
                      controller: _classNameController,
                      decoration: const InputDecoration(
                        labelText: 'Class',
                        prefixIcon: Icon(Icons.class_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter class';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    
                    // Address
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address (Optional)',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 32.h),
                    
                    // Submit Button
                    PrimaryButton(
                      onPressed: _onSubmit,
                      child: Text(isEditMode ? 'UPDATE STUDENT' : 'ADD STUDENT'),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
                  ],
                ),
              ),
            ),
            
            // Loading Overlay
            if (state is StudentFormSubmitting)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: LoadingIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
