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
 # #   E n v i r o n m e n t   S e t u p 
 
 1 .   C o p y   t h e   t e m p l a t e   f i l e   t o   c r e a t e   y o u r   s e c u r e   p r o p e r t i e s   f i l e : 
       `  a s h 
       c p   s r c / m a i n / r e s o u r c e s / a p p l i c a t i o n - s e c u r e . p r o p e r t i e s . t e m p l a t e   s r c / m a i n / r e s o u r c e s / s e c u r e / a p p l i c a t i o n - s e c u r e . p r o p e r t i e s 
       ` 
 
 2 .   E d i t   t h e    p p l i c a t i o n - s e c u r e . p r o p e r t i e s   f i l e   a n d   f i l l   i n   y o u r   F i r e b a s e   c r e d e n t i a l s . 
 
 3 .   E n s u r e   t h e   f i l e   i s   i n   y o u r   . g i t i g n o r e   a n d   n e v e r   c o m m i t   i t   t o   v e r s i o n   c o n t r o l . 
 
 4 .   F o r   p r o d u c t i o n ,   s e t   t h e s e   a s   e n v i r o n m e n t   v a r i a b l e s   o r   u s e   a   s e c u r e   s e c r e t   m a n a g e m e n t   s o l u t i o n .  
 