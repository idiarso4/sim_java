-- Migration: V2__Create_attendance_tables.sql
-- Description: Create attendance and presence tracking tables
-- Author: System
-- Date: 2024-01-15

-- Create attendances table (main attendance - check in/out)
CREATE TABLE attendances (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    schedule_latitude DOUBLE PRECISION NOT NULL,
    schedule_longitude DOUBLE PRECISION NOT NULL,
    schedule_start_time TIME NOT NULL,
    schedule_end_time TIME NOT NULL,
    start_latitude DOUBLE PRECISION NOT NULL,
    start_longitude DOUBLE PRECISION NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME,
    end_latitude DOUBLE PRECISION,
    end_longitude DOUBLE PRECISION,
    is_leave BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_attendances_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create student_attendances table (class attendance per subject)
CREATE TABLE student_attendances (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'hadir' CHECK (status IN ('hadir', 'sakit', 'izin', 'alpha', 'dispensasi')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_attendances_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    CONSTRAINT fk_student_attendances_class FOREIGN KEY (class_id) REFERENCES class_rooms(id) ON DELETE CASCADE,
    CONSTRAINT fk_student_attendances_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Create prayer_attendances table
CREATE TABLE prayer_attendances (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    date DATE NOT NULL,
    check_in TIME,
    status VARCHAR(20) NOT NULL DEFAULT 'alpha' CHECK (status IN ('hadir', 'izin', 'alpha')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prayer_attendances_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create indexes for attendance tables
CREATE INDEX idx_attendances_user_created ON attendances(user_id, created_at);
CREATE INDEX idx_attendances_created_at ON attendances(created_at);
CREATE INDEX idx_student_attendances_student_date ON student_attendances(student_id, date);
CREATE INDEX idx_student_attendances_class_subject_date ON student_attendances(class_id, subject_id, date);
CREATE INDEX idx_prayer_attendances_user_date ON prayer_attendances(user_id, date); 