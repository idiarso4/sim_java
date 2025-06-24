# SIM Java Frontend

Frontend application for the School Information Management (SIM) Java system built with Flutter, following Clean Architecture principles and feature-first organization.

## 🏗️ Project Structure

```
lib/
├── core/                    # Core functionality and utilities
│   ├── constants/           # App-wide constants
│   ├── errors/              # Error handling and exceptions
│   ├── network/             # Network layer and API clients
│   ├── theme/               # App theming and styling
│   └── utils/               # Shared utility classes
│
├── features/               # Feature modules (self-contained)
│   ├── auth/                # Authentication feature
│   ├── users/               # User management
│   ├── students/            # Student management
│   └── teachers/            # Teacher management
│
└── presentation/           # App-wide UI components
    ├── widgets/             # Reusable widgets
    └── routes/              # App navigation
```

## 🚀 Features

### Core Features
- **Authentication**
  - User login/logout
  - Role-based access control
  - Session management
  - Secure token handling

### Feature Modules
- **User Management**
  - User profiles and permissions
  - Role-based access control
  - Account settings

- **Student Management**
  - Student profiles
  - Attendance tracking
  - Academic records
  - Parent/guardian information

- **Teacher Management**
  - Teacher profiles
  - Class and subject assignments
  - Schedule management

- **Academic**
  - Class scheduling
  - Grade management
  - Report generation

### Shared Utilities
- **UI Components**
  - Custom form fields
  - Loading indicators
  - Dialogs and alerts

- **Services**
  - Network utilities
  - Local storage
  - Image handling
  - Permission management

## 🧩 Feature Module Structure

Each feature is self-contained and follows Clean Architecture principles:

```
feature_name/
├── data/                    # Data layer (implementation)
│   ├── datasources/         # Data sources (local/remote)
│   │   ├── local/          # Local data sources (e.g., Hive, SharedPreferences)
│   │   └── remote/         # Remote data sources (e.g., API clients)
│   ├── models/              # Data models (DTOs)
│   └── repositories/        # Repository implementations
│
├── domain/                  # Domain layer (business logic)
│   ├── entities/            # Business entities (domain models)
│   ├── repositories/        # Repository interfaces (contracts)
│   └── usecases/            # Business logic (use cases)
│
└── presentation/            # Presentation layer (UI)
    ├── bloc/                # BLoCs for state management
    │   └── feature_name/     # Feature-specific BLoCs
    │       ├── bloc.dart    # BLoC class
    │       ├── event.dart   # Events
    │       └── state.dart   # States
    │
    ├── pages/               # Feature screens
    │   └── feature_page.dart
    │
    └── widgets/             # Feature-specific widgets
        ├── widget_a.dart
        └── form_fields/     # Custom form fields (if needed)
```
## 🚦 Development Guidelines

### Adding a New Feature
1. **Create Feature Structure**
   ```bash
   lib/features/
   └── new_feature/
       ├── data/
       │   ├── datasources/
       │   ├── models/
       │   └── repositories/
       ├── domain/
       │   ├── entities/
       │   ├── repositories/
       │   └── usecases/
       └── presentation/
           ├── bloc/
           ├── pages/
           └── widgets/
   ```

2. **Register Dependencies**
   - Add feature dependencies in `lib/core/di/injection_container.dart`
   - Register BLoCs, repositories, and use cases

3. **Add Navigation**
   - Define routes in `lib/core/routes/app_router.dart`
   - Use auto_route for type-safe navigation

### Best Practices
- **Separation of Concerns**
  - Keep UI separate from business logic
  - Use BLoC for state management
  - Follow Clean Architecture layers

- **Code Organization**
  - Place shared components in `core/widgets/`
  - Keep feature-specific code within the feature directory
  - Use meaningful, consistent naming

- **Testing**
  - Write unit tests for use cases
  - Write widget tests for UI components
  - Write integration tests for features

- **Documentation**
  - Document public APIs
  - Add README.md in each feature directory
  - Use meaningful commit messages

## 📦 Core Components

### Form Fields
```dart
// Example of a reusable dropdown field
CustomDropdown<Gender>(
  items: Gender.values,
  label: 'Gender',
  onChanged: (value) {
    // Handle selection
  },
  itemAsString: (gender) => gender.toString().split('.').last,
)
```

### State Management
```dart
// BLoC pattern implementation
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(ExampleInitial()) {
    on<ExampleEvent>((event, emit) {
      // Handle events
    });
  }
}
```

## 📚 Documentation

For more detailed information, see:
- [Development Guide](./docs/development_guide.md)
- [API Documentation](./docs/api/)
- [Testing Guidelines](./docs/testing.md)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
└── presentation/            # UI layer
    ├── bloc/                # Business logic components
    ├── pages/               # App screens
    ├── widgets/             # Reusable widgets
    └── routes/              # App navigation
    ├── widgets/             # Reusable form fields
    │   ├── form_fields/
        │   ├── teacher_text_form_field.dart
        │   ├── teacher_date_picker_field.dart
        │   ├── teacher_dropdown_field.dart
        │   └── photo_picker_field.dart
```

## 📱 Screenshots

*Screenshots will be added here*

## 🛠️ Installation

1. **Prerequisites**
   - Flutter SDK (latest stable version)
   - Dart SDK (comes with Flutter)
   - Android Studio / Xcode (for mobile development)
   - VS Code (recommended)

2. **Setup**
   ```bash
   # Clone the repository
   git clone https://github.com/yourusername/sim-java-frontend.git
   
   # Navigate to project directory
   cd sim-java-frontend
   
   # Install dependencies
   flutter pub get
   
   # Run the app
   flutter run
   ```

## 🧪 Testing

Run tests using the following commands:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/example_test.dart

# Run tests with coverage
flutter test --coverage
```

## 🛠️ Build

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

iOS
```bash
flutter build ios --release
```

## 📝 Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
BASE_URL=https://api.sim-java.com
API_KEY=your_api_key
ENV=development
```

## ✨ Form Field Widgets

The application includes a set of reusable form field widgets designed for the Teacher Management feature. These widgets provide consistent styling, validation, and user experience across the application.

### Available Widgets

1. **TeacherTextFormField**
   - Customizable text input field with validation
   - Supports labels, hints, icons, and error messages
   - Consistent theming with the app's design system

   ```dart
   TeacherTextFormField(
     label: 'Full Name',
     hintText: 'Enter full name',
     prefixIcon: Icons.person_outline,
     validator: (value) {
       if (value == null || value.isEmpty) {
         return 'Please enter a name';
       }
       return null;
     },
     onChanged: (value) {
       // Handle text changes
     },
   )
   ```

2. **TeacherDatePickerField**
   - Date selection with a calendar picker
   - Custom date formatting
   - Validation and error handling

   ```dart
   TeacherDatePickerField(
     label: 'Date of Birth',
     initialDate: DateTime.now(),
     firstDate: DateTime(1900),
     lastDate: DateTime.now(),
     onDateChanged: (date) {
       // Handle date selection
     },
   )
   ```

## 🧩 Feature Module Structure

Each feature follows a consistent structure following Clean Architecture principles:

```
feature_name/
├── data/                    # Data layer (implementation)
│   ├── datasources/         # Data sources (local/remote)
│   ├── models/              # Data models (DTOs)
│   └── repositories/        # Repository implementations
├── domain/                  # Domain layer (abstractions)
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Business logic
└── presentation/            # UI layer
    ├── bloc/                # Business logic components
    ├── pages/               # Feature screens
    └── widgets/             # Reusable widgets
        └── form_fields/     # Custom form fields (if needed)
```

## 🚦 Getting Started

1. **Adding a New Feature**
   - Create a new directory under `lib/features/`
   - Follow the feature module structure above
   - Register dependencies in the DI container
   - Add routes in the app router

2. **Development Guidelines**
   - Keep features self-contained
   - Use BLoC for state management
   - Follow SOLID principles
   - Write unit and widget tests
   - Document public APIs

3. **Code Organization**
   - Place shared components in `core/widgets/`
   - Keep feature-specific widgets in their respective feature directory
   - Use meaningful names for files and directories
   - Follow Dart style guide for naming conventions

   ```dart
   TeacherDropdownField<Gender>(
     label: 'Gender',
     hint: 'Select gender',
     items: Gender.values,
     itemAsString: (gender) => gender.toString().split('.').last,
     onChanged: (value) {
       // Handle selection
     },
   )
   ```

4. **PhotoPickerField**
   - Image capture from camera or gallery
   - Image preview and cropping
   - Loading states and error handling

   ```dart
   PhotoPickerField(
     label: 'Profile Photo',
     initialImageUrl: teacher.photoUrl,
     onPhotoChanged: (image) {
       // Handle image selection
     },
     size: 120,
   )
   ```

### Features

- **Consistent Styling**: All widgets follow the app's design system
- **Responsive**: Adapts to different screen sizes
- **Accessible**: Built with accessibility in mind
- **Customizable**: Extensive theming and styling options
- **Validation**: Built-in and custom validation support
- **Error Handling**: Clear error messages and states

## 📚 Libraries & Packages

- **State Management**: flutter_bloc, bloc
- **Networking**: dio, retrofit, http
- **Local Storage**: shared_preferences, hive
- **Image Handling**: cached_network_image, image_picker, image_cropper
- **Form Validation**: formz, equatable, validators2
- **Dependency Injection**: get_it, injectable, injectable_generator
- **Internationalization**: intl, easy_localization, flutter_localizations
- **UI Components**: flutter_screenutil, flutter_svg, google_fonts
- **Testing**: mockito, bloc_test, flutter_test
- **Logging**: logger, logging
- **Utilities**: intl_utils, build_runner, json_serializable

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Flutter Community](https://flutter.dev/community)
