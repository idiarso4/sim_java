-- Migration: V5__Create_assessment_and_extracurricular_tables.sql
-- Description: Create assessment, scoring, and extracurricular tables
-- Author: System
-- Date: 2024-01-15

-- Create assessments table
CREATE TABLE assessments (
    id BIGSERIAL PRIMARY KEY,
    class_room_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('sumatif', 'non_sumatif')),
    subject VARCHAR(255) NOT NULL,
    assessment_name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    description TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_assessments_class_room FOREIGN KEY (class_room_id) REFERENCES class_rooms(id) ON DELETE CASCADE,
    CONSTRAINT fk_assessments_teacher FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create student_scores table
CREATE TABLE student_scores (
    id BIGSERIAL PRIMARY KEY,
    assessment_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    score DECIMAL(5,2),
    status VARCHAR(20) NOT NULL DEFAULT 'hadir' CHECK (status IN ('hadir', 'sakit', 'izin', 'alpha')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_scores_assessment FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE,
    CONSTRAINT fk_student_scores_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    CONSTRAINT uk_student_scores_assessment_student UNIQUE (assessment_id, student_id)
);

-- Create extracurriculars table
CREATE TABLE extracurriculars (
    id BIGSERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    deskripsi TEXT NOT NULL,
    hari VARCHAR(255) NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    tempat VARCHAR(255) NOT NULL,
    status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create extracurricular_members table
CREATE TABLE extracurricular_members (
    id BIGSERIAL PRIMARY KEY,
    extracurricular_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_extracurricular_members_extracurricular FOREIGN KEY (extracurricular_id) REFERENCES extracurriculars(id) ON DELETE CASCADE,
    CONSTRAINT fk_extracurricular_members_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    CONSTRAINT uk_extracurricular_members_extracurricular_student UNIQUE (extracurricular_id, student_id)
);

-- Create extracurricular_supervisors table
CREATE TABLE extracurricular_supervisors (
    id BIGSERIAL PRIMARY KEY,
    extracurricular_id BIGINT NOT NULL,
    guru_id BIGINT NOT NULL,
    is_main_supervisor BOOLEAN NOT NULL DEFAULT FALSE,
    notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_extracurricular_supervisors_extracurricular FOREIGN KEY (extracurricular_id) REFERENCES extracurriculars(id) ON DELETE CASCADE,
    CONSTRAINT fk_extracurricular_supervisors_guru FOREIGN KEY (guru_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_extracurricular_supervisors_extracurricular_guru UNIQUE (extracurricular_id, guru_id)
);

-- Create indexes for assessment and extracurricular tables
CREATE INDEX idx_assessments_class_room ON assessments(class_room_id);
CREATE INDEX idx_assessments_teacher ON assessments(teacher_id);
CREATE INDEX idx_student_scores_assessment ON student_scores(assessment_id);
CREATE INDEX idx_student_scores_student ON student_scores(student_id);
CREATE INDEX idx_extracurricular_members_extracurricular ON extracurricular_members(extracurricular_id);
CREATE INDEX idx_extracurricular_members_student ON extracurricular_members(student_id);
CREATE INDEX idx_extracurricular_supervisors_extracurricular ON extracurricular_supervisors(extracurricular_id);
CREATE INDEX idx_extracurricular_supervisors_guru ON extracurricular_supervisors(guru_id); 