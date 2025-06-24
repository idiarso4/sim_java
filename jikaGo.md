# Checklist Sistem Manajemen Sekolah
**Backend: Go (Golang)**  
**Frontend: Flutter**  
**Database: PostgreSQL**  
**Push Notification: Firebase Cloud Messaging (FCM)**

## ✅ Pre-Development Setup

### **Environment Setup**
- [ ] Install Go 1.21+ dan setup GOPATH
- [ ] Install Flutter SDK 3.16+ dan Dart
- [ ] Install PostgreSQL 15+ dan pgAdmin
- [ ] Setup IDE (VS Code/GoLand untuk Go, VS Code/Android Studio untuk Flutter)
- [ ] Install Git dan setup repository
- [ ] Setup Firebase project untuk FCM

### **Project Structure**
- [ ] Buat repository backend Go dengan struktur folder yang proper
- [ ] Buat repository frontend Flutter dengan clean architecture
- [ ] Setup environment variables (.env files)
- [ ] Konfigurasi Docker dan docker-compose untuk development
- [ ] Setup CI/CD pipeline (GitHub Actions/GitLab CI)

## ✅ Database Design & Migration

### **PostgreSQL Setup**
- [ ] Install dan konfigurasi PostgreSQL
- [ ] Buat database `sistem_manajemen_sekolah`
- [ ] Setup user dan permissions database
- [ ] Konfigurasi connection pooling
- [ ] Setup backup strategy otomatis

### **Schema Migration**
- [ ] Konversi schema MySQL ke PostgreSQL
- [ ] Implementasi migration scripts dengan golang-migrate
- [ ] Definisi semua foreign key constraints
- [ ] Setup indexes untuk performa optimal
- [ ] Validasi referential integrity

### **Data Migration**
- [ ] Export data dari MySQL dalam format CSV
- [ ] Buat script import data ke PostgreSQL
- [ ] Validasi data consistency post-migration
- [ ] Setup data seeding untuk development

## ✅ Backend Development (Go)

### **Core Setup**
- [ ] Initialize Go module dan dependencies
- [ ] Setup Gin/Echo framework untuk REST API
- [ ] Konfigurasi GORM untuk database ORM
- [ ] Implementasi middleware (CORS, logging, auth)
- [ ] Setup JWT authentication

### **Database Models**
- [ ] Model User, Student, Teacher dengan relasi
- [ ] Model Class, Subject, Department
- [ ] Model Attendance, StudentAttendance, PrayerAttendance
- [ ] Model TeachingActivity, TeacherJournal
- [ ] Model PKL (Internship), CareerGuidance (BK)
- [ ] Model Assessment, StudentScore
- [ ] Model Extracurricular, Leave, Mutation

### **API Endpoints**
#### Authentication & User Management
- [ ] POST `/api/auth/login` - Login user
- [ ] POST `/api/auth/logout` - Logout user
- [ ] GET `/api/users` - List users
- [ ] GET `/api/users/{id}` - User detail
- [ ] PUT `/api/users/{id}` - Update user

#### Student Management
- [ ] GET `/api/students` - List students
- [ ] POST `/api/students` - Create student
- [ ] GET `/api/students/{id}` - Student detail
- [ ] PUT `/api/students/{id}` - Update student
- [ ] DELETE `/api/students/{id}` - Delete student

#### Attendance Management
- [ ] POST `/api/attendance/main` - Main attendance (datang/pulang)
- [ ] POST `/api/attendance/class` - Class attendance
- [ ] POST `/api/attendance/prayer` - Prayer attendance
- [ ] GET `/api/attendance/report` - Attendance reports
- [ ] GET `/api/attendance/export` - Export attendance data

#### Teaching Activities (KBM)
- [ ] POST `/api/teaching/activities` - Create teaching activity
- [ ] GET `/api/teaching/activities` - List teaching activities
- [ ] POST `/api/teaching/attendance` - Student attendance in teaching
- [ ] POST `/api/teacher/journals` - Teacher daily journal
- [ ] GET `/api/teaching/reports` - Teaching reports

#### PKL Management
- [ ] POST `/api/pkl/internships` - Create PKL application
- [ ] GET `/api/pkl/internships` - List PKL applications
- [ ] PUT `/api/pkl/internships/{id}/approve` - Approve PKL
- [ ] POST `/api/pkl/attendance` - PKL attendance
- [ ] GET `/api/pkl/reports` - PKL reports

#### BK (Counseling) Management
- [ ] POST `/api/bk/guidance` - Create counseling session
- [ ] GET `/api/bk/guidance` - List counseling sessions
- [ ] PUT `/api/bk/guidance/{id}` - Update counseling record
- [ ] GET `/api/bk/reports` - BK reports

#### Assessment & Scoring
- [ ] POST `/api/assessments` - Create assessment
- [ ] GET `/api/assessments` - List assessments
- [ ] POST `/api/student-scores` - Record student scores
- [ ] GET `/api/student-scores/reports` - Score reports

#### Administrative
- [ ] POST `/api/leaves` - Leave application
- [ ] GET `/api/leaves` - List leave applications
- [ ] PUT `/api/leaves/{id}/approve` - Approve leave
- [ ] GET `/api/notifications` - List notifications
- [ ] GET `/api/reports/export` - Export various reports

### **Firebase Integration**
- [ ] Setup Firebase Admin SDK di Go backend
- [ ] Implementasi service untuk send push notification
- [ ] Endpoint untuk register/unregister FCM tokens
- [ ] Trigger notifikasi untuk events penting (absensi, izin, dll)

## ✅ Frontend Development (Flutter)

### **Core Setup**
- [ ] Initialize Flutter project dengan clean architecture
- [ ] Setup state management (Bloc/Riverpod/GetX)
- [ ] Konfigurasi HTTP client (Dio/http)
- [ ] Setup routing (GoRouter/AutoRoute)
- [ ] Implementasi theme dan design system

### **Firebase Setup**
- [ ] Add Firebase to Flutter project
- [ ] Configure Firebase Cloud Messaging
- [ ] Setup FCM token management
- [ ] Implementasi notification handling (foreground/background)
- [ ] Setup notification permissions

### **Authentication Screens**
- [ ] Login screen dengan validasi
- [ ] Logout functionality
- [ ] Token management dan auto-refresh
- [ ] Role-based navigation

### **Student Screens**
- [ ] Dashboard siswa dengan summary
- [ ] Presensi screen (QR scanner/manual)
- [ ] Riwayat kehadiran
- [ ] Profile dan edit data
- [ ] Notifikasi screen

### **Teacher Screens**
- [ ] Dashboard guru dengan summary
- [ ] Input absensi kelas
- [ ] Jurnal mengajar
- [ ] Jurnal harian guru
- [ ] Laporan mengajar

### **Admin Screens**
- [ ] Dashboard admin dengan analytics
- [ ] Manajemen data siswa (CRUD)
- [ ] Manajemen data guru
- [ ] Manajemen kelas dan mata pelajaran
- [ ] Laporan dan export data

### **PKL Screens**
- [ ] Pengajuan PKL
- [ ] Monitoring PKL (untuk pembimbing)
- [ ] Presensi PKL
- [ ] Laporan PKL

### **BK Screens**
- [ ] Pengajuan konseling
- [ ] Jadwal konseling
- [ ] Riwayat konseling
- [ ] Laporan BK

### **Common Features**
- [ ] QR Code scanner untuk presensi
- [ ] GPS location validation
- [ ] Offline capability untuk data penting
- [ ] Push notification handling
- [ ] Export dan share laporan

## ✅ Integration & Testing

### **API Integration**
- [ ] Implementasi HTTP client dengan error handling
- [ ] Setup interceptors untuk authentication
- [ ] Implementasi retry mechanism
- [ ] Cache management untuk offline support

### **Testing**
- [ ] Unit tests untuk backend services
- [ ] Integration tests untuk API endpoints
- [ ] Widget tests untuk Flutter screens
- [ ] End-to-end testing
- [ ] Performance testing

### **Firebase Testing**
- [ ] Test FCM token registration
- [ ] Test push notification delivery
- [ ] Test notification handling di berbagai state app
- [ ] Test notification payload parsing

## ✅ Security & Performance

### **Security**
- [ ] Implementasi rate limiting
- [ ] Input validation dan sanitization
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] HTTPS enforcement
- [ ] Secure JWT implementation

### **Performance**
- [ ] Database query optimization
- [ ] API response caching
- [ ] Image optimization dan lazy loading
- [ ] Background sync untuk offline data
- [ ] Memory leak prevention

## ✅ Deployment & DevOps

### **Backend Deployment**
- [ ] Setup Docker container untuk Go backend
- [ ] Configure reverse proxy (Nginx)
- [ ] Setup SSL certificates
- [ ] Configure environment variables
- [ ] Setup monitoring dan logging

### **Database Deployment**
- [ ] Setup PostgreSQL di production
- [ ] Configure backup dan restore
- [ ] Setup monitoring dan alerts
- [ ] Performance tuning

### **Flutter Deployment**
- [ ] Build APK/AAB untuk Android
- [ ] Build IPA untuk iOS (jika diperlukan)
- [ ] Setup app signing
- [ ] Configure app store metadata
- [ ] Setup crash reporting

### **Firebase Configuration**
- [ ] Setup production Firebase project
- [ ] Configure FCM untuk production
- [ ] Setup analytics dan crash reporting
- [ ] Configure security rules

## ✅ Documentation & Training

### **Technical Documentation**
- [ ] API documentation dengan Swagger/OpenAPI
- [ ] Database schema documentation
- [ ] Deployment guide
- [ ] Troubleshooting guide

### **User Documentation**
- [ ] User manual untuk admin
- [ ] User manual untuk guru
- [ ] User manual untuk siswa
- [ ] Video tutorial

### **Training**
- [ ] Training untuk admin sekolah
- [ ] Training untuk guru
- [ ] Training untuk IT support
- [ ] Dokumentasi maintenance

## ✅ Monitoring & Maintenance

### **Monitoring Setup**
- [ ] Setup application monitoring (Prometheus/Grafana)
- [ ] Setup error tracking (Sentry)
- [ ] Setup uptime monitoring
- [ ] Setup performance monitoring

### **Backup & Recovery**
- [ ] Automated database backup
- [ ] Backup verification
- [ ] Disaster recovery plan
- [ ] Data retention policy

### **Maintenance**
- [ ] Update schedule untuk dependencies
- [ ] Security patch management
- [ ] Performance optimization schedule
- [ ] Regular data cleanup

## ✅ Go-Live Checklist

### **Pre-Launch**
- [ ] Load testing dengan data production
- [ ] Security audit dan penetration testing
- [ ] Backup dan rollback plan
- [ ] User acceptance testing
- [ ] Staff training completion

### **Launch Day**
- [ ] Deploy ke production environment
- [ ] Verify all services running
- [ ] Test critical user flows
- [ ] Monitor system performance
- [ ] Standby support team

### **Post-Launch**
- [ ] Monitor system stability 24/7
- [ ] Collect user feedback
- [ ] Performance optimization
- [ ] Bug fixes dan improvements
- [ ] Regular system health checks

---

**Catatan:** Checklist ini dapat disesuaikan berdasarkan kebutuhan spesifik sekolah dan timeline project. Prioritaskan fitur-fitur core terlebih dahulu sebelum mengembangkan fitur advanced.