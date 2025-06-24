# Users Feature

This directory contains all the code related to the Users feature, following Clean Architecture principles.

## Directory Structure

```
users/
├── data/                    # Data layer (implementation)
│   ├── datasources/         # Data sources (local/remote)
│   ├── models/              # Data models (DTOs)
│   └── repositories/        # Repository implementations
├── domain/                  # Domain layer (abstraction)
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Business logic
└── presentation/            # UI layer
    ├── bloc/                # Business logic components
    │   ├── user_list/       # User list BLoC
    │   ├── user_detail/     # User detail BLoC
    │   ├── user_form/       # User form BLoC
    │   └── user_search/     # User search BLoC
    ├── pages/               # Feature screens
    └── widgets/             # Reusable widgets
        └── form_fields/     # Custom form fields
```

## Feature Description

This feature handles all user-related functionality including:
- Listing users
- Viewing user details
- Creating/editing users
- Searching users

## Dependencies

- `equatable`: For value equality
- `bloc`: For state management
- `dio`: For API calls (if using remote data source)
- `shared_preferences`: For local storage (if needed)

## Getting Started

1. Register the feature's dependencies in the dependency injection container
2. Add the necessary routes in the app router
3. Use the provided BLoCs in your UI components

## Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables and methods: `camelCase`
- Constants: `UPPER_SNAKE_CASE`

## Testing

Unit tests should be placed in the `test/features/users` directory with a similar structure to the source code.
