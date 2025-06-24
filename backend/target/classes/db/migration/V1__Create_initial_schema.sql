-- Migration: V1__Create_initial_schema.sql
-- Description: Create initial database schema for Sistem Manajemen Sekolah
-- Author: System
-- Date: 2024-01-15

-- Create departments table
CREATE TABLE departments (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    kode VARCHAR(255) NOT NULL UNIQUE,
    status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create school_years table
CREATE TABLE school_years (
    id BIGSERIAL PRIMARY KEY,
    tahun VARCHAR(255) NOT NULL,
    semester VARCHAR(255) NOT NULL CHECK (semester IN ('ganjil', 'genap')),
    status VARCHAR(255) NOT NULL DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP,
    password VARCHAR(255) NOT NULL,
    remember_token VARCHAR(100),
    image VARCHAR(255),
    user_type VARCHAR(20) NOT NULL DEFAULT 'siswa' CHECK (user_type IN ('admin', 'guru', 'siswa')),
    role VARCHAR(20) NOT NULL DEFAULT 'siswa' CHECK (role IN ('super_admin', 'admin', 'guru', 'siswa')),
    status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'tidak aktif', 'lulus', 'pindah')),
    class_room_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create class_rooms table
CREATE TABLE class_rooms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    level VARCHAR(255) NOT NULL,
    department_id BIGINT NOT NULL,
    school_year_id BIGINT NOT NULL,
    homeroom_teacher_id BIGINT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_class_rooms_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    CONSTRAINT fk_class_rooms_school_year FOREIGN KEY (school_year_id) REFERENCES school_years(id) ON DELETE CASCADE,
    CONSTRAINT fk_class_rooms_homeroom_teacher FOREIGN KEY (homeroom_teacher_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Add foreign key constraint for users.class_room_id
ALTER TABLE users 
ADD CONSTRAINT fk_users_class_room 
FOREIGN KEY (class_room_id) REFERENCES class_rooms(id) ON DELETE SET NULL;

-- Create students table
CREATE TABLE students (
    id BIGSERIAL PRIMARY KEY,
    nis VARCHAR(255) NOT NULL UNIQUE,
    nama_lengkap VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telp VARCHAR(255),
    jenis_kelamin CHAR(1) NOT NULL CHECK (jenis_kelamin IN ('L', 'P')),
    agama VARCHAR(255) NOT NULL,
    class_room_id BIGINT NOT NULL,
    user_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_students_class_room FOREIGN KEY (class_room_id) REFERENCES class_rooms(id) ON DELETE CASCADE,
    CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create student_details table
CREATE TABLE student_details (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    nipd VARCHAR(255),
    nisn VARCHAR(255),
    birth_place VARCHAR(255),
    birth_date DATE,
    nik VARCHAR(255),
    address TEXT,
    phone VARCHAR(255),
    father_name VARCHAR(255),
    mother_name VARCHAR(255),
    guardian_name VARCHAR(255),
    father_phone VARCHAR(255),
    mother_phone VARCHAR(255),
    guardian_phone VARCHAR(255),
    father_job VARCHAR(255),
    mother_job VARCHAR(255),
    guardian_job VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_details_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create subjects table
CREATE TABLE subjects (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create offices table (for school location and PKL companies)
CREATE TABLE offices (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    radius INTEGER DEFAULT 100,
    phone VARCHAR(255),
    email VARCHAR(255),
    description TEXT,
    type VARCHAR(50) DEFAULT 'school' CHECK (type IN ('school', 'company', 'other')),
    status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create shifts table
CREATE TABLE shifts (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create schedules table
CREATE TABLE schedules (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    shift_id BIGINT NOT NULL,
    office_id BIGINT NOT NULL,
    is_wfa BOOLEAN NOT NULL DEFAULT FALSE,
    is_banned BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_schedules_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_schedules_shift FOREIGN KEY (shift_id) REFERENCES shifts(id) ON DELETE CASCADE,
    CONSTRAINT fk_schedules_office FOREIGN KEY (office_id) REFERENCES offices(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_user_type ON users(user_type);
CREATE INDEX idx_students_nis ON students(nis);
CREATE INDEX idx_students_class_room ON students(class_room_id);
CREATE INDEX idx_class_rooms_department ON class_rooms(department_id);
CREATE INDEX idx_class_rooms_school_year ON class_rooms(school_year_id);
CREATE INDEX idx_offices_type ON offices(type);
CREATE INDEX idx_schedules_user ON schedules(user_id); 