# Development Guide - Student Management Feature

This document provides an overview of the Student Management feature's architecture and development guidelines.

## 🏗️ Architecture Overview

The Student Management feature follows Clean Architecture principles with BLoC for state management:

```
lib/features/student/
├── data/
│   ├── datasources/      # Data sources (remote, local)
│   ├── models/          # Data models (DTOs)
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic use cases
└── presentation/
    ├── bloc/           # BLoCs for state management
    ├── screens/         # Feature screens
    └── widgets/         # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for emulator/simulator)
- VS Code or Android Studio (recommended IDEs)

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd simjava/frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   
   For continuous code generation during development:
   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

## 🧪 Testing

### Unit Tests

Run all unit tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

### Widget Tests

Run widget tests:
```bash
flutter test test/widget_test.dart
```

### Integration Tests

Run integration tests:
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

## 🛠️ Development Workflow

### Branch Naming

Use the following format for branch names:
```
feature/<feature-name>    # New features
bugfix/<bug-description>  # Bug fixes
hotfix/<issue>           # Critical fixes
refactor/<description>    # Code refactoring
chore/<task>             # Maintenance tasks
```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Pull Requests

1. Create a feature branch from `main`
2. Make your changes
3. Write tests for your changes
4. Run tests and ensure they pass
5. Update documentation if needed
6. Create a pull request with a clear description
7. Request review from at least one team member

## 📱 Running the App

### Development

```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Get device list
flutter devices
```

### Release Build

```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle

# Build iOS
flutter build ios --release
```

## 📚 Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Dart Documentation](https://dart.dev/guides)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
