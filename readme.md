# SIM Java - School Information Management System

A comprehensive school management system with a Spring Boot backend and Flutter frontend.

## Project Overview

SIM Java is a school information management system designed to help educational institutions manage their administrative tasks efficiently. The system includes features for managing students, teachers, classes, attendance, and teaching activities.

## Architecture

The project follows a modern, microservices-oriented architecture:

- **Backend**: Spring Boot application with RESTful APIs
- **Frontend**: Flutter application for cross-platform support
- **Database**: PostgreSQL for data persistence
- **Authentication**: JWT-based authentication and authorization

## Features

- User Management (Admin, Teacher, Student roles)
- Student Management
- Teacher Management
- Class Management
- Attendance Tracking
- Teaching Activities Management
- Dashboard with Statistics
- Role-Based Access Control

## Tech Stack

### Backend
- Java 17
- Spring Boot 3.x
- Spring Security with JWT
- Spring Data JPA
- PostgreSQL
- Flyway for database migrations
- OpenAPI/Swagger for API documentation
- JUnit 5 for testing

### Frontend
- Flutter
- Dart
- Bloc pattern for state management
- Clean Architecture principles

## Getting Started

### Prerequisites
- Java 17 or higher
- Maven 3.8+
- PostgreSQL 14+
- Flutter SDK 3.x
- Docker and Docker Compose (optional)

### Running the Backend

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/simjava.git
   cd simjava
   ```

2. Configure the database in `backend/src/main/resources/application.yml`

3. Run the Spring Boot application:
   ```
   cd backend
   mvn spring-boot:run
   ```

4. The backend will be available at `http://localhost:8081/api/v1`

### Running the Frontend

1. Install dependencies:
   ```
   cd frontend
   flutter pub get
   ```

2. Run the application:
   ```
   flutter run
   ```

### Using Docker

You can also run the entire application using Docker:

```
docker-compose up -d
```

This will start the PostgreSQL database and the backend service. The frontend can be added to the docker-compose configuration once its Dockerfile is ready.

## API Documentation

API documentation is available via Swagger UI at:
```
http://localhost:8081/api/v1/swagger-ui.html
```

## Testing

The project includes various tests:

- Unit Tests
- Controller Tests
- Repository Tests
- Integration Tests
- Security Tests

Run tests with:
```
cd backend
mvn test
```

## Project Structure

```
simjava/
├── backend/                # Spring Boot application
│   ├── src/                # Source code
│   │   ├── main/
│   │   │   ├── java/       # Java code
│   │   │   └── resources/  # Configuration files
│   │   └── test/           # Test code
│   └── pom.xml             # Maven configuration
├── frontend/               # Flutter application
│   ├── lib/                # Dart code
│   │   ├── core/           # Core functionality
│   │   ├── data/           # Data layer
│   │   ├── domain/         # Domain layer
│   │   └── features/       # Feature modules
│   └── pubspec.yaml        # Flutter dependencies
├── docker-compose.yml      # Docker Compose configuration
└── README.md               # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Spring Boot team for the excellent framework
- Flutter team for the cross-platform UI toolkit
- All contributors who have helped shape this project