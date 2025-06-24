# API Documentation - Sistem Manajemen Sekolah

**Base URL:** `http://localhost:8080/api`  
**Content-Type:** `application/json`  
**Authentication:** Bearer Token (JWT)

---

## Table of Contents
1. [Authentication](#authentication)
2. [User Management](#user-management)
3. [Student Management](#student-management)
4. [Attendance Management](#attendance-management)
5. [Teaching Activities (KBM)](#teaching-activities-kbm)
6. [PKL Management](#pkl-management)
7. [BK (Counseling) Management](#bk-counseling-management)
8. [Assessment & Scoring](#assessment--scoring)
9. [Administrative](#administrative)
10. [Error Responses](#error-responses)

---

## Authentication

### Login
```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "admin@sekolah.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "user": {
      "id": 1,
      "name": "Admin Sekolah",
      "email": "admin@sekolah.com",
      "user_type": "admin",
      "role": "admin",
      "status": "aktif"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "refresh_token_here"
  }
}
```

### Refresh Token
```http
POST /auth/refresh
```

**Request Body:**
```json
{
  "refresh_token": "refresh_token_here"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Token berhasil diperbarui",
  "data": {
    "token": "new_jwt_token_here",
    "refresh_token": "new_refresh_token_here"
  }
}
```

### Logout
```http
POST /auth/logout
```

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Logout berhasil"
}
```

---

## User Management

### Get Users List
```http
GET /users?page=1&size=10&search=admin&user_type=admin
```

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "name": "Admin Sekolah",
        "email": "admin@sekolah.com",
        "user_type": "admin",
        "role": "admin",
        "status": "aktif",
        "created_at": "2024-01-15T08:00:00Z"
      }
    ],
    "totalElements": 1,
    "totalPages": 1,
    "currentPage": 1,
    "size": 10
  }
}
```

### Get User Detail
```http
GET /users/{id}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Admin Sekolah",
    "email": "admin@sekolah.com",
    "user_type": "admin",
    "role": "admin",
    "status": "aktif",
    "class_room_id": null,
    "created_at": "2024-01-15T08:00:00Z",
    "updated_at": "2024-01-15T08:00:00Z"
  }
}
```

### Update User
```http
PUT /users/{id}
```

**Request Body:**
```json
{
  "name": "Admin Sekolah Updated",
  "email": "admin.updated@sekolah.com",
  "status": "aktif"
}
```

### Change Password
```http
POST /users/change-password
```

**Request Body:**
```json
{
  "current_password": "oldpassword123",
  "new_password": "newpassword123",
  "confirm_password": "newpassword123"
}
```

---

## Student Management

### Get Students List
```http
GET /students?page=1&size=10&class_room_id=1&search=john
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "nis": "2024001",
        "nama_lengkap": "John Doe",
        "email": "john.doe@student.com",
        "jenis_kelamin": "L",
        "agama": "Islam",
        "class_room": {
          "id": 1,
          "name": "XII RPL 1",
          "department": {
            "id": 1,
            "name": "Rekayasa Perangkat Lunak"
          }
        },
        "user": {
          "id": 2,
          "name": "John Doe",
          "email": "john.doe@student.com",
          "user_type": "siswa"
        }
      }
    ],
    "totalElements": 1,
    "totalPages": 1,
    "currentPage": 1,
    "size": 10
  }
}
```

### Create Student
```http
POST /students
```

**Request Body:**
```json
{
  "nis": "2024002",
  "nama_lengkap": "Jane Smith",
  "email": "jane.smith@student.com",
  "telp": "081234567890",
  "jenis_kelamin": "P",
  "agama": "Islam",
  "class_room_id": 1,
  "user": {
    "password": "password123",
    "user_type": "siswa",
    "role": "siswa"
  },
  "student_details": {
    "birth_place": "Jakarta",
    "birth_date": "2006-05-15",
    "nik": "1234567890123456",
    "address": "Jl. Contoh No. 123",
    "phone": "081234567890",
    "father_name": "Mr. Smith",
    "mother_name": "Mrs. Smith"
  }
}
```

### Get Student Detail
```http
GET /students/{id}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "nis": "2024001",
    "nama_lengkap": "John Doe",
    "email": "john.doe@student.com",
    "telp": "081234567890",
    "jenis_kelamin": "L",
    "agama": "Islam",
    "class_room": {
      "id": 1,
      "name": "XII RPL 1",
      "department": {
        "id": 1,
        "name": "Rekayasa Perangkat Lunak"
      }
    },
    "user": {
      "id": 2,
      "name": "John Doe",
      "email": "john.doe@student.com",
      "user_type": "siswa",
      "status": "aktif"
    },
    "student_details": {
      "id": 1,
      "birth_place": "Jakarta",
      "birth_date": "2006-05-15",
      "nik": "1234567890123456",
      "address": "Jl. Contoh No. 123",
      "phone": "081234567890",
      "father_name": "Mr. Doe",
      "mother_name": "Mrs. Doe"
    }
  }
}
```

---

## Attendance Management

### Main Attendance (Check-in/Check-out)
```http
POST /attendance/main
```

**Request Body:**
```json
{
  "type": "check_in", // or "check_out"
  "latitude": -6.2088,
  "longitude": 106.8456,
  "time": "07:30:00"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Presensi berhasil dicatat",
  "data": {
    "id": 1,
    "user_id": 2,
    "start_time": "07:30:00",
    "start_latitude": -6.2088,
    "start_longitude": 106.8456,
    "created_at": "2024-01-15T07:30:00Z"
  }
}
```

### Class Attendance
```http
POST /attendance/class
```

**Request Body:**
```json
{
  "class_room_id": 1,
  "subject_id": 1,
  "date": "2024-01-15",
  "attendances": [
    {
      "student_id": 1,
      "status": "hadir"
    },
    {
      "student_id": 2,
      "status": "sakit",
      "notes": "Sakit flu"
    }
  ]
}
```

### Prayer Attendance
```http
POST /attendance/prayer
```

**Request Body:**
```json
{
  "date": "2024-01-15",
  "attendances": [
    {
      "user_id": 1,
      "status": "hadir",
      "check_in": "12:30:00"
    },
    {
      "user_id": 2,
      "status": "izin",
      "notes": "Izin ke dokter"
    }
  ]
}
```

### Get Attendance Report
```http
GET /attendance/report?start_date=2024-01-01&end_date=2024-01-31&class_room_id=1&user_id=1
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "summary": {
      "total_days": 22,
      "present": 20,
      "absent": 1,
      "sick": 1,
      "attendance_rate": 90.91
    },
    "details": [
      {
        "date": "2024-01-15",
        "check_in": "07:30:00",
        "check_out": "15:30:00",
        "status": "hadir",
        "location": {
          "latitude": -6.2088,
          "longitude": 106.8456
        }
      }
    ]
  }
}
```

---

## Teaching Activities (KBM)

### Create Teaching Activity
```http
POST /teaching/activities
```

**Request Body:**
```json
{
  "mata_pelajaran": "Matematika",
  "tanggal": "2024-01-15",
  "jam_mulai": "08:00:00",
  "jam_selesai": "09:30:00",
  "materi": "Persamaan Kuadrat",
  "media_dan_alat": "Papan tulis, proyektor",
  "important_notes": "Siswa perlu latihan lebih banyak"
}
```

### Get Teaching Activities
```http
GET /teaching/activities?page=1&size=10&tanggal=2024-01-15&guru_id=1
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "guru": {
          "id": 1,
          "name": "Pak Guru"
        },
        "mata_pelajaran": "Matematika",
        "tanggal": "2024-01-15",
        "jam_mulai": "08:00:00",
        "jam_selesai": "09:30:00",
        "materi": "Persamaan Kuadrat",
        "media_dan_alat": "Papan tulis, proyektor",
        "important_notes": "Siswa perlu latihan lebih banyak",
        "created_at": "2024-01-15T08:00:00Z"
      }
    ],
    "totalElements": 1,
    "totalPages": 1,
    "currentPage": 1,
    "size": 10
  }
}
```

### Student Attendance in Teaching
```http
POST /teaching/attendance
```

**Request Body:**
```json
{
  "teaching_activity_id": 1,
  "attendances": [
    {
      "student_id": 1,
      "status": "Hadir"
    },
    {
      "student_id": 2,
      "status": "Sakit",
      "keterangan": "Sakit flu"
    }
  ]
}
```

### Teacher Daily Journal
```http
POST /teacher/journals
```

**Request Body:**
```json
{
  "tanggal": "2024-01-15",
  "pencapaian": "Siswa memahami konsep persamaan kuadrat",
  "kendala": "Beberapa siswa masih kesulitan dengan faktorisasi",
  "solusi": "Memberikan latihan tambahan dan penjelasan individual",
  "rencana_tindak_lanjut": "Review ulang materi di pertemuan berikutnya"
}
```

---

## PKL Management

### Create PKL Application
```http
POST /pkl/internships
```

**Request Body:**
```json
{
  "office_id": 1,
  "company_leader": "Pak Manager",
  "company_type": "Software Development",
  "company_phone": "021-1234567",
  "company_description": "Perusahaan pengembangan software",
  "start_date": "2024-02-01",
  "end_date": "2024-05-31",
  "position": "Junior Developer",
  "phone": "081234567890",
  "description": "PKL sebagai junior developer"
}
```

### Get PKL List
```http
GET /pkl/internships?page=1&size=10&status=active&student_id=1
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "student": {
          "id": 1,
          "nama_lengkap": "John Doe",
          "nis": "2024001"
        },
        "guru_pembimbing": {
          "id": 1,
          "name": "Pak Pembimbing"
        },
        "office": {
          "id": 1,
          "name": "PT. Tech Solutions",
          "address": "Jl. Tech No. 123"
        },
        "company_leader": "Pak Manager",
        "company_type": "Software Development",
        "start_date": "2024-02-01",
        "end_date": "2024-05-31",
        "position": "Junior Developer",
        "status": "active",
        "created_at": "2024-01-15T08:00:00Z"
      }
    ],
    "totalElements": 1,
    "totalPages": 1,
    "currentPage": 1,
    "size": 10
  }
}
```

### Approve PKL
```http
PUT /pkl/internships/{id}/approve
```

**Request Body:**
```json
{
  "notes": "PKL disetujui, silakan mulai pada tanggal yang ditentukan"
}
```

### PKL Attendance
```http
POST /pkl/attendance
```

**Request Body:**
```json
{
  "pkl_internship_id": 1,
  "date": "2024-02-01",
  "check_in": "08:00:00",
  "check_out": "17:00:00",
  "latitude": -6.2088,
  "longitude": 106.8456,
  "activities": "Mempelajari framework React",
  "notes": "Hari pertama PKL berjalan lancar"
}
```

---

## BK (Counseling) Management

### Create Counseling Session
```http
POST /bk/guidance
```

**Request Body:**
```json
{
  "student_id": 1,
  "type": "personal",
  "subject": "Masalah akademik",
  "description": "Siswa mengalami kesulitan dalam mata pelajaran matematika",
  "scheduled_date": "2024-01-20",
  "scheduled_time": "10:00:00"
}
```

### Get Counseling Sessions
```http
GET /bk/guidance?page=1&size=10&student_id=1&status=scheduled
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "student": {
          "id": 1,
          "nama_lengkap": "John Doe",
          "nis": "2024001"
        },
        "type": "personal",
        "subject": "Masalah akademik",
        "description": "Siswa mengalami kesulitan dalam mata pelajaran matematika",
        "scheduled_date": "2024-01-20",
        "scheduled_time": "10:00:00",
        "status": "scheduled",
        "created_at": "2024-01-15T08:00:00Z"
      }
    ],
    "totalElements": 1,
    "totalPages": 1,
    "currentPage": 1,
    "size": 10
  }
}
```

### Update Counseling Record
```http
PUT /bk/guidance/{id}
```

**Request Body:**
```json
{
  "status": "completed",
  "result": "Siswa akan mengikuti remedial dan bimbingan tambahan",
  "follow_up": "Monitoring progress selama 2 minggu ke depan",
  "notes": "Siswa menunjukkan motivasi yang baik"
}
```

---

## Assessment & Scoring

### Create Assessment
```http
POST /assessments
```

**Request Body:**
```json
{
  "class_room_id": 1,
  "type": "sumatif",
  "subject": "Matematika",
  "assessment_name": "UTS Semester 1",
  "date": "2024-01-20",
  "description": "Ujian Tengah Semester mata pelajaran Matematika"
}
```

### Record Student Scores
```http
POST /student-scores
```

**Request Body:**
```json
{
  "assessment_id": 1,
  "scores": [
    {
      "student_id": 1,
      "score": 85.5,
      "status": "hadir"
    },
    {
      "student_id": 2,
      "score": 78.0,
      "status": "hadir"
    }
  ]
}
```

### Get Score Reports
```http
GET /student-scores/reports?assessment_id=1&class_room_id=1
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "assessment": {
      "id": 1,
      "name": "UTS Semester 1",
      "subject": "Matematika",
      "date": "2024-01-20"
    },
    "statistics": {
      "total_students": 30,
      "average_score": 82.5,
      "highest_score": 95.0,
      "lowest_score": 65.0
    },
    "scores": [
      {
        "student": {
          "id": 1,
          "nama_lengkap": "John Doe",
          "nis": "2024001"
        },
        "score": 85.5,
        "status": "hadir",
        "rank": 5
      }
    ]
  }
}
```

---

## Administrative

### Leave Application
```http
POST /leaves
```

**Request Body:**
```json
{
  "start_date": "2024-01-20",
  "end_date": "2024-01-22",
  "reason": "Sakit",
  "description": "Sakit flu berat, perlu istirahat"
}
```

### Get Leave Applications
```http
GET /leaves?page=1&size=10&status=pending&user_id=1
```

### Approve/Reject Leave
```http
PUT /leaves/{id}/approve
```

**Request Body:**
```json
{
  "status": "approved",
  "notes": "Izin disetujui, jangan lupa siapkan tugas yang tertinggal"
}
```

### Get Notifications
```http
GET /notifications?page=1&size=10&is_read=false
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "title": "Presensi Berhasil",
        "message": "Presensi pagi Anda telah berhasil dicatat",
        "type": "attendance",
        "is_read": false,
        "created_at": "2024-01-15T07:30:00Z"
      }
    ],
    "totalElements": 1,
    "totalPages": 1,
    "currentPage": 1,
    "size": 10
  }
}
```

### Mark Notification as Read
```http
POST /notifications/mark-read
```

**Request Body:**
```json
{
  "notification_ids": [1, 2, 3]
}
```

### Dashboard Analytics
```http
GET /reports/dashboard
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "attendance": {
      "today_present": 150,
      "today_absent": 10,
      "attendance_rate": 93.75
    },
    "pkl": {
      "active_internships": 25,
      "pending_approvals": 5
    },
    "academic": {
      "total_students": 200,
      "total_teachers": 15,
      "total_classes": 8
    }
  }
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Data tidak valid",
  "errors": {
    "email": ["Email harus valid"],
    "password": ["Password minimal 6 karakter"]
  }
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "message": "Token tidak valid atau expired"
}
```

### 403 Forbidden
```json
{
  "success": false,
  "message": "Anda tidak memiliki akses ke resource ini"
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Data tidak ditemukan"
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "message": "Terjadi kesalahan internal server"
}
```

---

## Authentication Headers

Untuk semua request yang memerlukan authentication, tambahkan header:

```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

## Rate Limiting

API memiliki rate limiting:
- 100 requests per minute untuk user biasa
- 1000 requests per minute untuk admin

## Pagination

Untuk endpoint yang mendukung pagination, gunakan query parameters:
- `page`: Nomor halaman (default: 1)
- `size`: Jumlah item per halaman (default: 10, max: 100)
- `sort`: Field untuk sorting (default: id)
- `direction`: ASC atau DESC (default: DESC) 