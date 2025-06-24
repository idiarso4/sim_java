# Troubleshooting Guide - Sistem Manajemen Sekolah

Panduan untuk mengatasi masalah umum yang terjadi saat development dan deployment sistem.

---

## Table of Contents
1. [Backend Issues](#backend-issues)
2. [Frontend Issues](#frontend-issues)
3. [Database Issues](#database-issues)
4. [Authentication Issues](#authentication-issues)
5. [API Issues](#api-issues)
6. [Deployment Issues](#deployment-issues)
7. [Performance Issues](#performance-issues)
8. [Common Error Messages](#common-error-messages)

---

## Backend Issues

### 1. Spring Boot Application Won't Start

**Problem:** Aplikasi Spring Boot tidak bisa start atau crash saat startup.

**Possible Causes:**
- Port 8080 sudah digunakan
- Database connection failed
- Missing environment variables
- JVM memory issues

**Solutions:**

**A. Port Already in Use**
```bash
# Check what's using port 8080
netstat -ano | findstr :8080  # Windows
lsof -i :8080                 # Linux/Mac

# Kill the process
taskkill /PID <process_id>    # Windows
kill -9 <process_id>          # Linux/Mac

# Or change port in application.properties
server.port=8081
```

**B. Database Connection Failed**
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql  # Linux
brew services list | grep postgresql  # Mac

# Test connection
psql -h localhost -U username -d database_name

# Check application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/sistem_manajemen_sekolah
spring.datasource.username=your_username
spring.datasource.password=your_password
```

**C. Missing Environment Variables**
```bash
# Create .env file
cp .env.example .env

# Edit .env with correct values
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sistem_manajemen_sekolah
DB_USERNAME=your_username
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret
```

### 2. JPA/Hibernate Issues

**Problem:** Entity mapping errors atau database schema issues.

**Solutions:**

**A. Enable SQL Logging**
```properties
# application.properties
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=TRACE
```

**B. Validate Schema**
```properties
# application.properties
spring.jpa.hibernate.ddl-auto=validate
```

**C. Reset Database**
```properties
# application.properties
spring.jpa.hibernate.ddl-auto=create-drop
```

### 3. JWT Token Issues

**Problem:** Token expired, invalid, atau tidak bisa di-refresh.

**Solutions:**

**A. Check JWT Configuration**
```properties
# application.properties
jwt.secret=your_very_long_secret_key_here
jwt.expiration=86400000  # 24 hours in milliseconds
jwt.refresh-expiration=604800000  # 7 days
```

**B. Token Validation**
```java
// Check if token is valid
try {
    Claims claims = Jwts.parser()
        .setSigningKey(jwtSecret)
        .parseClaimsJws(token)
        .getBody();
} catch (Exception e) {
    // Token is invalid
}
```

---

## Frontend Issues

### 1. Flutter App Won't Build

**Problem:** Flutter app gagal build atau ada dependency issues.

**Solutions:**

**A. Clean and Rebuild**
```bash
flutter clean
flutter pub get
flutter run
```

**B. Check Flutter Version**
```bash
flutter --version
flutter doctor
```

**C. Update Dependencies**
```bash
flutter pub upgrade
flutter pub outdated
```

### 2. API Connection Issues

**Problem:** Flutter app tidak bisa connect ke backend API.

**Solutions:**

**A. Check Base URL**
```dart
// lib/config/environment.dart
class Environment {
  static const String baseUrl = 'http://10.0.2.2:8080/api';  // Android Emulator
  // static const String baseUrl = 'http://localhost:8080/api';  // iOS Simulator
  // static const String baseUrl = 'http://192.168.1.100:8080/api';  // Physical Device
}
```

**B. Add Network Security Config (Android)**
```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">10.0.2.2</domain>
        <domain includeSubdomains="true">localhost</domain>
    </domain-config>
</network-security-config>
```

**C. Check HTTP Client Configuration**
```dart
// lib/services/api_service.dart
final dio = Dio(BaseOptions(
  baseUrl: Environment.baseUrl,
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
));
```

### 3. State Management Issues

**Problem:** State tidak ter-update atau UI tidak reactive.

**Solutions:**

**A. Check Provider/Bloc Setup**
```dart
// Make sure provider is properly set up
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => StudentProvider()),
  ],
  child: MyApp(),
)
```

**B. Debug State Changes**
```dart
// Add debug prints
class StudentProvider extends ChangeNotifier {
  void updateStudents(List<Student> students) {
    print('Updating students: ${students.length}');
    _students = students;
    notifyListeners();
  }
}
```

---

## Database Issues

### 1. PostgreSQL Connection Issues

**Problem:** Tidak bisa connect ke PostgreSQL database.

**Solutions:**

**A. Check PostgreSQL Service**
```bash
# Linux
sudo systemctl status postgresql
sudo systemctl start postgresql

# Mac
brew services start postgresql

# Windows
# Check Services app
```

**B. Check PostgreSQL Configuration**
```bash
# Edit postgresql.conf
sudo nano /etc/postgresql/14/main/postgresql.conf

# Make sure these lines are uncommented:
listen_addresses = '*'
port = 5432

# Edit pg_hba.conf for authentication
sudo nano /etc/postgresql/14/main/pg_hba.conf

# Add this line for local connections:
host    all             all             127.0.0.1/32            md5
```

**C. Create Database and User**
```sql
-- Connect as postgres user
sudo -u postgres psql

-- Create database
CREATE DATABASE sistem_manajemen_sekolah;

-- Create user
CREATE USER your_username WITH PASSWORD 'your_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE sistem_manajemen_sekolah TO your_username;
```

### 2. Migration Issues

**Problem:** Database migration gagal atau schema tidak sesuai.

**Solutions:**

**A. Check Migration Files**
```bash
# Check migration status
mvn flyway:info

# Repair migration
mvn flyway:repair

# Clean and migrate
mvn flyway:clean
mvn flyway:migrate
```

**B. Manual Migration**
```sql
-- Check current schema
\dt

-- Check table structure
\d table_name

-- Fix specific issues
ALTER TABLE users ADD COLUMN IF NOT EXISTS user_type VARCHAR(20);
```

### 3. Performance Issues

**Problem:** Query lambat atau database overload.

**Solutions:**

**A. Add Indexes**
```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_students_nis ON students(nis);
CREATE INDEX idx_attendances_user_date ON attendances(user_id, created_at);
CREATE INDEX idx_teaching_activities_guru_date ON teaching_activities(guru_id, tanggal);
```

**B. Optimize Queries**
```sql
-- Use EXPLAIN to analyze query performance
EXPLAIN ANALYZE SELECT * FROM students s 
JOIN class_rooms c ON s.class_room_id = c.id 
WHERE c.department_id = 1;

-- Use LIMIT for pagination
SELECT * FROM students LIMIT 10 OFFSET 0;
```

---

## Authentication Issues

### 1. Login Failed

**Problem:** User tidak bisa login atau credential salah.

**Debug Steps:**
1. Check if user exists in database
2. Verify password hashing
3. Check user status (aktif/tidak aktif)
4. Verify email format

**Solutions:**

**A. Check User in Database**
```sql
SELECT id, name, email, user_type, status, password 
FROM users 
WHERE email = 'user@example.com';
```

**B. Reset Password**
```sql
-- Update password (use BCrypt hash)
UPDATE users 
SET password = '$2a$10$...' 
WHERE email = 'user@example.com';
```

**C. Enable User**
```sql
UPDATE users 
SET status = 'aktif' 
WHERE email = 'user@example.com';
```

### 2. JWT Token Expired

**Problem:** Token expired dan tidak bisa di-refresh.

**Solutions:**

**A. Check Token Expiration**
```java
// In JWT service
public boolean isTokenExpired(String token) {
    try {
        Claims claims = Jwts.parser()
            .setSigningKey(jwtSecret)
            .parseClaimsJws(token)
            .getBody();
        
        return claims.getExpiration().before(new Date());
    } catch (Exception e) {
        return true;
    }
}
```

**B. Implement Token Refresh**
```java
@PostMapping("/auth/refresh")
public ResponseEntity<?> refreshToken(@RequestBody RefreshTokenRequest request) {
    // Validate refresh token
    // Generate new access token
    // Return new tokens
}
```

---

## API Issues

### 1. CORS Issues

**Problem:** Frontend tidak bisa access API karena CORS policy.

**Solutions:**

**A. Configure CORS in Spring Boot**
```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
            .allowedOrigins("http://localhost:3000", "http://localhost:8080")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true);
    }
}
```

**B. Add CORS Headers**
```java
@Component
public class CorsFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
        HttpServletResponse response = (HttpServletResponse) res;
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type,Authorization");
        chain.doFilter(req, res);
    }
}
```

### 2. API Rate Limiting

**Problem:** API requests blocked due to rate limiting.

**Solutions:**

**A. Configure Rate Limiting**
```java
@Configuration
public class RateLimitConfig {
    @Bean
    public Bucket rateLimitBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(100, Refill.intervally(100, Duration.ofMinutes(1))))
            .build();
    }
}
```

**B. Handle Rate Limit Exceeded**
```java
@ExceptionHandler(RateLimitExceededException.class)
public ResponseEntity<?> handleRateLimitExceeded(RateLimitExceededException e) {
    return ResponseEntity.status(429)
        .header("Retry-After", "60")
        .body(new ErrorResponse("Rate limit exceeded. Please try again later."));
}
```

---

## Deployment Issues

### 1. Production Build Issues

**Problem:** App tidak bisa build untuk production.

**Solutions:**

**A. Flutter Production Build**
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

**B. Spring Boot Production Build**
```bash
# Create JAR file
mvn clean package -DskipTests

# Run JAR
java -jar target/sistem-manajemen-sekolah-0.0.1-SNAPSHOT.jar
```

### 2. Environment Configuration

**Problem:** Environment variables tidak terbaca di production.

**Solutions:**

**A. Use Environment Variables**
```bash
# Set environment variables
export DB_HOST=production-db-host
export DB_PORT=5432
export DB_NAME=production_db
export DB_USERNAME=prod_user
export DB_PASSWORD=prod_password
export JWT_SECRET=production_jwt_secret

# Run application
java -jar app.jar
```

**B. Use Application Properties**
```properties
# application-prod.properties
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
jwt.secret=${JWT_SECRET}
```

---

## Performance Issues

### 1. Slow API Responses

**Problem:** API response time lambat.

**Solutions:**

**A. Add Caching**
```java
@Cacheable("students")
public List<Student> getAllStudents() {
    return studentRepository.findAll();
}
```

**B. Optimize Database Queries**
```java
// Use @Query for complex queries
@Query("SELECT s FROM Student s JOIN FETCH s.classRoom c WHERE c.department.id = :departmentId")
List<Student> findStudentsByDepartment(@Param("departmentId") Long departmentId);
```

**C. Add Pagination**
```java
@GetMapping("/students")
public Page<Student> getStudents(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size) {
    return studentService.getStudents(PageRequest.of(page, size));
}
```

### 2. Memory Issues

**Problem:** Application menggunakan memory berlebihan.

**Solutions:**

**A. Configure JVM Memory**
```bash
java -Xms512m -Xmx1024m -jar app.jar
```

**B. Monitor Memory Usage**
```java
// Add memory monitoring
@Scheduled(fixedRate = 60000)
public void logMemoryUsage() {
    Runtime runtime = Runtime.getRuntime();
    long usedMemory = runtime.totalMemory() - runtime.freeMemory();
    log.info("Memory usage: {} MB", usedMemory / 1024 / 1024);
}
```

---

## Common Error Messages

### 1. "Connection refused"
- **Cause:** Database atau service tidak running
- **Solution:** Start PostgreSQL service

### 2. "Invalid JWT token"
- **Cause:** Token expired atau format salah
- **Solution:** Login ulang atau refresh token

### 3. "Entity not found"
- **Cause:** Data tidak ada di database
- **Solution:** Check ID atau create data

### 4. "Validation failed"
- **Cause:** Input data tidak valid
- **Solution:** Check validation rules

### 5. "Permission denied"
- **Cause:** User tidak punya akses
- **Solution:** Check user role dan permissions

---

## Debug Tools

### 1. Logging
```properties
# application.properties
logging.level.com.yourpackage=DEBUG
logging.level.org.springframework.web=DEBUG
logging.level.org.hibernate.SQL=DEBUG
```

### 2. Database Monitoring
```sql
-- Check active connections
SELECT * FROM pg_stat_activity;

-- Check slow queries
SELECT query, mean_time, calls 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;
```

### 3. API Testing
```bash
# Use curl for API testing
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@sekolah.com","password":"password123"}'
```

---

## Getting Help

Jika masalah masih belum teratasi:

1. **Check Logs:** Lihat application logs untuk error details
2. **Search Issues:** Cek GitHub issues atau Stack Overflow
3. **Create Issue:** Buat issue baru dengan detail lengkap
4. **Contact Support:** Hubungi tim development

**Template untuk Report Issue:**
```
**Environment:**
- OS: Windows/Linux/Mac
- Java Version: 17
- Spring Boot Version: 3.x
- Flutter Version: 3.x
- Database: PostgreSQL 15

**Error:**
[Paste error message here]

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**Additional Context:**
[Any other relevant information]
``` 