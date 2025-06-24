# Installation Instructions

## Prerequisites

1. Java Development Kit (JDK) 17 or higher
   - Download from: https://www.oracle.com/java/technologies/downloads/#jdk17-windows
   - Set JAVA_HOME environment variable

2. PostgreSQL 15
   - Download from: https://www.postgresql.org/download/windows/
   - During installation:
     - Set a password for the postgres user (remember this password)
     - Note the default port (5432)
     - Choose a directory for data files

## Setup Process

1. Run the setup script:
   ```bash
   cd C:\Users\User\Documents\CODE\simjava
   .\setup.bat
   ```

2. After running the setup script:
   - Maven will be downloaded and installed
   - The database will be created
   - You'll need to update the database password in `backend\src\main\resources\application.yml`

3. Update database credentials:
   Edit `backend\src\main\resources\application.yml`:
   ```yaml
   spring:
     datasource:
       url: jdbc:postgresql://localhost:5432/sistem_manajemen_sekolah
       username: postgres
       password: YOUR_POSTGRES_PASSWORD  # Replace with your actual password
   ```

## Running the Application

1. Open a command prompt
2. Navigate to the backend directory:
   ```bash
   cd C:\Users\User\Documents\CODE\simjava\backend
   ```
3. Build and run the application:
   ```bash
   mvn clean install
   mvn spring-boot:run
   ```

## Accessing the Application

The application will be available at:
- API: http://localhost:8080
- Swagger UI: http://localhost:8080/swagger-ui.html

## Default Endpoints

Authentication:
- POST /api/auth/login - Login endpoint
- POST /api/auth/refresh - Token refresh endpoint

Students:
- POST /api/students - Create student
- GET /api/students/{id} - Get student by ID
- GET /api/students - Get all students

Attendance:
- POST /api/attendance - Create attendance
- GET /api/attendance/{id} - Get attendance by ID
- GET /api/attendance/student/{studentId} - Get attendances by student
- GET /api/attendance/date-range - Get attendances by date range
- GET /api/attendance/status - Get attendances by status
