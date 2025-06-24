# Checklist Sistem Manajemen Sekolah
**Backend: Spring Boot (Java)**  
**Frontend: Flutter**  
**Database: PostgreSQL**  
**Push Notification: Firebase Cloud Messaging (FCM)**

## ✅ Pre-Development Setup

### **Environment Setup**
- [ ] Install JDK 17+ (LTS) dan setup JAVA_HOME
- [ ] Install Maven 3.8+ atau Gradle 7+
- [ ] Install Flutter SDK 3.16+ dan Dart
- [ ] Install PostgreSQL 15+ dan pgAdmin
- [ ] Setup IDE (IntelliJ IDEA/Eclipse untuk Spring, VS Code/Android Studio untuk Flutter)
- [ ] Install Git dan setup repository
- [ ] Setup Firebase project untuk FCM

### **Project Structure**
- [ ] Generate Spring Boot project dengan Spring Initializr
- [ ] Setup multi-module Maven/Gradle project structure
- [ ] Buat repository frontend Flutter dengan clean architecture
- [ ] Setup application.properties/application.yml
- [ ] Konfigurasi Docker dan docker-compose untuk development
- [ ] Setup CI/CD pipeline (GitHub Actions/GitLab CI)

## ✅ Database Design & Migration

### **PostgreSQL Setup**
- [ ] Install dan konfigurasi PostgreSQL
- [ ] Buat database `sistem_manajemen_sekolah`
- [ ] Setup user dan permissions database
- [ ] Konfigurasi HikariCP connection pool
- [ ] Setup backup strategy otomatis

### **Schema Migration**
- [ ] Konversi schema MySQL ke PostgreSQL
- [ ] Setup Flyway/Liquibase untuk database migration
- [ ] Definisi semua foreign key constraints
- [ ] Setup indexes untuk performa optimal
- [ ] Validasi referential integrity

### **Data Migration**
- [ ] Export data dari MySQL dalam format CSV
- [ ] Buat script import data ke PostgreSQL dengan Spring Batch
- [ ] Validasi data consistency post-migration
- [ ] Setup data seeding dengan @DataJpaTest

## ✅ Backend Development (Spring Boot)

### **Core Dependencies & Configuration**
- [ ] Spring Boot Starter Web
- [ ] Spring Boot Starter Data JPA
- [ ] Spring Boot Starter Security
- [ ] Spring Boot Starter Validation
- [ ] PostgreSQL Driver
- [ ] Firebase Admin SDK
- [ ] JWT dependencies (jjwt)
- [ ] MapStruct untuk mapping
- [ ] SpringDoc OpenAPI untuk dokumentasi

### **Security Configuration**
- [ ] Configure Spring Security dengan JWT
- [ ] Implementasi UserDetailsService
- [ ] Setup CORS configuration
- [ ] Configure method-level security
- [ ] Implementasi rate limiting dengan Bucket4j

### **Database Models (JPA Entities)**
- [ ] Entity User dengan @Entity dan relasi
- [ ] Entity Student dengan @OneToOne ke User
- [ ] Entity StudentDetail dengan detail lengkap
- [ ] Entity ClassRoom dengan @ManyToOne ke Department
- [ ] Entity Subject, Department, SchoolYear
- [ ] Entity Attendance dengan @ManyToOne ke User
- [ ] Entity StudentAttendance dengan composite key
- [ ] Entity PrayerAttendance
- [ ] Entity TeachingActivity dengan @ManyToOne ke User
- [ ] Entity TeachingActivityAttendance
- [ ] Entity TeacherJournal
- [ ] Entity PKLInternship dengan relasi ke Office
- [ ] Entity CareerGuidance untuk BK
- [ ] Entity Assessment, StudentScore
- [ ] Entity Extracurricular, ExtracurricularMember
- [ ] Entity Leave, Mutation, Notification

### **Repository Layer (Spring Data JPA)**
- [ ] UserRepository extends JpaRepository
- [ ] StudentRepository dengan custom queries
- [ ] AttendanceRepository dengan @Query
- [ ] TeachingActivityRepository
- [ ] PKLInternshipRepository
- [ ] CareerGuidanceRepository
- [ ] AssessmentRepository
- [ ] ExtracurricularRepository
- [ ] Custom repository methods dengan Criteria API

### **Service Layer**
- [ ] UserService dengan business logic
- [ ] StudentService dengan validation
- [ ] AttendanceService dengan location validation
- [ ] TeachingActivityService
- [ ] PKLService dengan workflow management
- [ ] BKService (CareerGuidanceService)
- [ ] AssessmentService
- [ ] NotificationService dengan FCM integration
- [ ] ReportService untuk export data
- [ ] EmailService untuk notifikasi

### **Controller Layer (REST API)**
#### Authentication & User Management
- [ ] POST `/api/auth/login` - Login dengan JWT
- [ ] POST `/api/auth/refresh` - Refresh token
- [ ] POST `/api/auth/logout` - Logout user
- [ ] GET `/api/users` - List users dengan pagination
- [ ] GET `/api/users/{id}` - User detail
- [ ] PUT `/api/users/{id}` - Update user
- [ ] POST `/api/users/change-password` - Change password

#### Student Management
- [ ] GET `/api/students` - List students dengan filter
- [ ] POST `/api/students` - Create student dengan validation
- [ ] GET `/api/students/{id}` - Student detail
- [ ] PUT `/api/students/{id}` - Update student
- [ ] DELETE `/api/students/{id}` - Soft delete student
- [ ] GET `/api/students/export` - Export student data

#### Attendance Management
- [ ] POST `/api/attendance/main` - Main attendance dengan GPS validation
- [ ] POST `/api/attendance/class` - Class attendance
- [ ] POST `/api/attendance/prayer` - Prayer attendance
- [ ] GET `/api/attendance/report` - Attendance reports dengan filter
- [ ] GET `/api/attendance/export` - Export attendance data
- [ ] GET `/api/attendance/summary` - Attendance summary

#### Teaching Activities (KBM)
- [ ] POST `/api/teaching/activities` - Create teaching activity
- [ ] GET `/api/teaching/activities` - List dengan pagination
- [ ] PUT `/api/teaching/activities/{id}` - Update activity
- [ ] POST `/api/teaching/attendance` - Student attendance in teaching
- [ ] POST `/api/teacher/journals` - Teacher daily journal
- [ ] GET `/api/teaching/reports` - Teaching reports
- [ ] GET `/api/teaching/export` - Export teaching data

#### PKL Management
- [ ] POST `/api/pkl/internships` - Create PKL application
- [ ] GET `/api/pkl/internships` - List dengan status filter
- [ ] PUT `/api/pkl/internships/{id}/approve` - Approve PKL
- [ ] PUT `/api/pkl/internships/{id}/reject` - Reject PKL
- [ ] POST `/api/pkl/attendance` - PKL attendance dengan GPS
- [ ] GET `/api/pkl/reports` - PKL reports
- [ ] GET `/api/pkl/export` - Export PKL data

#### BK (Counseling) Management
- [ ] POST `/api/bk/guidance` - Create counseling session
- [ ] GET `/api/bk/guidance` - List counseling sessions
- [ ] PUT `/api/bk/guidance/{id}` - Update counseling record
- [ ] GET `/api/bk/reports` - BK reports dengan analytics
- [ ] GET `/api/bk/export` - Export BK data

#### Assessment & Scoring
- [ ] POST `/api/assessments` - Create assessment
- [ ] GET `/api/assessments` - List assessments
- [ ] PUT `/api/assessments/{id}` - Update assessment
- [ ] POST `/api/student-scores` - Record student scores
- [ ] GET `/api/student-scores/reports` - Score reports
- [ ] GET `/api/student-scores/export` - Export scores

#### Administrative
- [ ] POST `/api/leaves` - Leave application dengan workflow
- [ ] GET `/api/leaves` - List leave applications
- [ ] PUT `/api/leaves/{id}/approve` - Approve leave
- [ ] PUT `/api/leaves/{id}/reject` - Reject leave
- [ ] GET `/api/notifications` - List notifications
- [ ] POST `/api/notifications/mark-read` - Mark as read
- [ ] GET `/api/reports/dashboard` - Dashboard analytics
- [ ] GET `/api/reports/export` - Export various reports

### **Firebase Integration**
- [ ] Setup Firebase Admin SDK configuration
- [ ] FCMService untuk send push notification
- [ ] POST `/api/fcm/register-token` - Register FCM token
- [ ] DELETE `/api/fcm/unregister-token` - Unregister token
- [ ] Trigger notifikasi untuk events (attendance, leave approval, dll)
- [ ] Batch notification service

### **Exception Handling**
- [ ] Global exception handler dengan @ControllerAdvice
- [ ] Custom exceptions (UserNotFoundException, etc.)
- [ ] Validation error handling
- [ ] API error response standardization

### **Validation & DTOs**
- [ ] Request DTOs dengan Bean Validation
- [ ] Response DTOs dengan MapStruct
- [ ] Custom validators untuk business rules
- [ ] Input sanitization

## ✅ Frontend Development (Flutter)

### **Core Setup**
- [ ] Initialize Flutter project dengan clean architecture
- [ ] Setup state management (Bloc/Riverpod/GetX)
- [ ] Konfigurasi HTTP client (Dio) dengan interceptors
- [ ] Setup routing (GoRouter/AutoRoute)
- [ ] Implementasi theme dan design system

### **Firebase Setup**
- [ ] Add Firebase to Flutter project
- [ ] Configure Firebase Cloud Messaging
- [ ] Setup FCM token management
- [ ] Implementasi notification handling (foreground/background)
- [ ] Setup notification permissions

### **Authentication Screens**
- [ ] Login screen dengan form validation
- [ ] JWT token storage dengan secure storage
- [ ] Auto-login dengan token refresh
- [ ] Logout functionality
- [ ] Role-based navigation

### **Student Screens**
- [ ] Dashboard siswa dengan summary cards
- [ ] Presensi screen (QR scanner/manual check-in)
- [ ] Riwayat kehadiran dengan filter
- [ ] Profile dan edit data pribadi
- [ ] Notifikasi screen dengan mark as read

### **Teacher Screens**
- [ ] Dashboard guru dengan teaching summary
- [ ] Input absensi kelas dengan student list
- [ ] Form jurnal mengajar
- [ ] Jurnal harian guru
- [ ] Laporan mengajar dengan export

### **Admin Screens**
- [ ] Dashboard admin dengan analytics charts
- [ ] Manajemen data siswa (CRUD) dengan search
- [ ] Manajemen data guru
- [ ] Manajemen kelas dan mata pelajaran
- [ ] Laporan dan export data (Excel/PDF)

### **PKL Screens**
- [ ] Form pengajuan PKL dengan file upload
- [ ] List PKL applications dengan status
- [ ] Monitoring PKL untuk pembimbing
- [ ] Presensi PKL dengan GPS validation
- [ ] Laporan PKL dengan progress tracking

### **BK Screens**
- [ ] Form pengajuan konseling
- [ ] Kalender jadwal konseling
- [ ] Riwayat konseling dengan notes
- [ ] Laporan BK dengan analytics

### **Common Features**
- [ ] QR Code scanner untuk presensi
- [ ] GPS location validation
- [ ] Offline capability dengan local database
- [ ] Push notification handling
- [ ] Export dan share laporan
- [ ] Dark/Light theme support

## ✅ Integration & Testing

### **API Integration**
- [ ] HTTP client dengan JWT interceptor
- [ ] Error handling dan retry mechanism
- [ ] Response caching dengan Dio
- [ ] Offline sync mechanism

### **Testing**
- [ ] Unit tests untuk Service layer (@MockBean)
- [ ] Integration tests untuk Repository (@DataJpaTest)
- [ ] Web layer tests (@WebMvcTest)
- [ ] Security tests (@WithMockUser)
- [ ] Widget tests untuk Flutter screens
- [ ] End-to-end testing dengan TestContainers

### **Firebase Testing**
- [ ] Test FCM token registration
- [ ] Test push notification delivery
- [ ] Test notification handling di berbagai state app
- [ ] Test notification payload parsing

## ✅ Security & Performance

### **Security**
- [ ] Spring Security dengan JWT
- [ ] Method-level security dengan @PreAuthorize
- [ ] Rate limiting dengan Bucket4j
- [ ] Input validation dengan Bean Validation
- [ ] SQL injection prevention dengan JPA
- [ ] XSS protection
- [ ] HTTPS enforcement

### **Performance**
- [ ] Database query optimization dengan @Query
- [ ] JPA performance tuning (lazy loading, fetch joins)
- [ ] Redis caching dengan @Cacheable
- [ ] Connection pooling dengan HikariCP
- [ ] API response pagination
- [ ] Async processing dengan @Async

## ✅ Deployment & DevOps

### **Backend Deployment**
- [ ] Dockerfile untuk Spring Boot application
- [ ] Docker Compose dengan PostgreSQL dan Redis
- [ ] Configure application profiles (dev, staging, prod)
- [ ] Setup reverse proxy (Nginx)
- [ ] SSL certificates configuration
- [ ] Environment variables management

### **Database Deployment**
- [ ] PostgreSQL di production dengan replication
- [ ] Flyway migration di production
- [ ] Database backup dan restore strategy
- [ ] Connection pooling configuration
- [ ] Performance monitoring

### **Flutter Deployment**
- [ ] Build APK/AAB untuk Android
- [ ] Build IPA untuk iOS (jika diperlukan)
- [ ] Setup app signing dengan keystore
- [ ] Configure app store metadata
- [ ] Setup crash reporting dengan Firebase Crashlytics

### **Firebase Configuration**
- [ ] Setup production Firebase project
- [ ] Configure FCM untuk production
- [ ] Setup Firebase Analytics
- [ ] Configure security rules
- [ ] Setup Firebase Performance Monitoring

## ✅ Documentation & Training

### **Technical Documentation**
- [ ] API documentation dengan SpringDoc OpenAPI
- [ ] Database schema documentation
- [ ] Architecture documentation
- [ ] Deployment guide
- [ ] Troubleshooting guide

### **User Documentation**
- [ ] User manual untuk admin
- [ ] User manual untuk guru
- [ ] User manual untuk siswa
- [ ] Video tutorial untuk setiap role

### **Training**
- [ ] Training untuk admin sekolah
- [ ] Training untuk guru dan staff
- [ ] Training untuk IT support
- [ ] Dokumentasi maintenance dan troubleshooting

## ✅ Monitoring & Maintenance

### **Monitoring Setup**
- [ ] Spring Boot Actuator untuk health checks
- [ ] Micrometer dengan Prometheus
- [ ] Grafana dashboard untuk metrics
- [ ] Logback configuration untuk structured logging
- [ ] ELK stack untuk log aggregation

### **Error Tracking**
- [ ] Sentry integration untuk error tracking
- [ ] Custom metrics untuk business events
- [ ] Performance monitoring
- [ ] Database performance monitoring

### **Backup & Recovery**
- [ ] Automated PostgreSQL backup dengan pg_dump
- [ ] Backup verification dan testing
- [ ] Disaster recovery plan
- [ ] Data retention policy

### **Maintenance**
- [ ] Spring Boot dan dependencies update schedule
- [ ] Security patch management
- [ ] Database maintenance (VACUUM, ANALYZE)
- [ ] Regular performance optimization
- [ ] Log rotation dan cleanup

## ✅ Go-Live Checklist

### **Pre-Launch**
- [ ] Load testing dengan JMeter/Gatling
- [ ] Security audit dan penetration testing
- [ ] Database performance tuning
- [ ] Backup dan rollback plan
- [ ] User acceptance testing
- [ ] Staff training completion

### **Launch Day**
- [ ] Deploy ke production environment
- [ ] Verify all Spring Boot services running
- [ ] Test critical user flows
- [ ] Monitor application metrics
- [ ] Verify database connections
- [ ] Test FCM notifications
- [ ] Standby support team

### **Post-Launch**
- [ ] Monitor system stability dengan Actuator
- [ ] Monitor application logs
- [ ] Collect user feedback
- [ ] Performance optimization berdasarkan metrics
- [ ] Bug fixes dan improvements
- [ ] Regular health checks

---

**Catatan:** Checklist ini disesuaikan untuk Spring Boot ecosystem dengan best practices Java development. Prioritaskan core features seperti authentication, basic CRUD, dan attendance management sebelum mengembangkan fitur advanced seperti analytics dan reporting.