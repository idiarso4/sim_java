-- Migration: V3__Create_teaching_activities_tables.sql
-- Description: Create teaching activities and KBM related tables
-- Author: System
-- Date: 2024-01-15

-- Create teaching_activities table
CREATE TABLE teaching_activities (
    id BIGSERIAL PRIMARY KEY,
    guru_id BIGINT NOT NULL,
    mata_pelajaran VARCHAR(255) NOT NULL,
    tanggal DATE NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    materi TEXT NOT NULL,
    media_dan_alat VARCHAR(255),
    important_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_teaching_activities_guru FOREIGN KEY (guru_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_teaching_unique UNIQUE (guru_id, tanggal)
);

-- Create teaching_activity_attendances table
CREATE TABLE teaching_activity_attendances (
    id BIGSERIAL PRIMARY KEY,
    teaching_activity_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Hadir' CHECK (status IN ('Hadir', 'Sakit', 'Izin', 'Alpha')),
    keterangan VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_teaching_activity_attendances_activity FOREIGN KEY (teaching_activity_id) REFERENCES teaching_activities(id) ON DELETE CASCADE,
    CONSTRAINT fk_teaching_activity_attendances_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Create teacher_journals table
CREATE TABLE teacher_journals (
    id BIGSERIAL PRIMARY KEY,
    guru_id BIGINT NOT NULL,
    tanggal DATE NOT NULL,
    pencapaian TEXT NOT NULL,
    kendala TEXT NOT NULL,
    solusi TEXT NOT NULL,
    rencana_tindak_lanjut TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_teacher_journals_guru FOREIGN KEY (guru_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_teacher_journals_guru_tanggal UNIQUE (guru_id, tanggal)
);

-- Create journals table (for other teacher activities)
CREATE TABLE journals (
    id BIGSERIAL PRIMARY KEY,
    guru_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'general' CHECK (type IN ('general', 'meeting', 'workshop', 'training')),
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_journals_guru FOREIGN KEY (guru_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create indexes for teaching activities
CREATE INDEX idx_teaching_activities_guru_tanggal ON teaching_activities(guru_id, tanggal);
CREATE INDEX idx_teaching_activity_attendances_activity ON teaching_activity_attendances(teaching_activity_id);
CREATE INDEX idx_teacher_journals_guru_tanggal ON teacher_journals(guru_id, tanggal);
CREATE INDEX idx_journals_guru_type ON journals(guru_id, type); 