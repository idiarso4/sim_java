-- Migration: V4__Create_pkl_and_bk_tables.sql
-- Description: Create PKL (internship) and BK (counseling) related tables
-- Author: System
-- Date: 2024-01-15

-- Create pkl_internships table
CREATE TABLE pkl_internships (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    guru_pembimbing_id BIGINT NOT NULL,
    office_id BIGINT NOT NULL,
    company_leader VARCHAR(255) NOT NULL,
    company_type VARCHAR(255) NOT NULL,
    company_phone VARCHAR(255) NOT NULL,
    company_description TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    position VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'inactive')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pkl_internships_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_pkl_internships_guru_pembimbing FOREIGN KEY (guru_pembimbing_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_pkl_internships_office FOREIGN KEY (office_id) REFERENCES offices(id) ON DELETE CASCADE
);

-- Create internships table (alternative internship data)
CREATE TABLE internships (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    guru_pembimbing_id BIGINT NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    company_address VARCHAR(255) NOT NULL,
    supervisor_name VARCHAR(255) NOT NULL,
    supervisor_contact VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'terminated')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_internships_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_internships_guru_pembimbing FOREIGN KEY (guru_pembimbing_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create career_guidances table (BK - Bimbingan Konseling)
CREATE TABLE career_guidances (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    class_room_id BIGINT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('sumatif', 'non_sumatif')),
    subject VARCHAR(255) NOT NULL,
    assessment_name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    score DOUBLE PRECISION NOT NULL,
    description TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_career_guidances_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_career_guidances_class_room FOREIGN KEY (class_room_id) REFERENCES class_rooms(id) ON DELETE CASCADE
);

-- Create counseling_sessions table (for BK sessions)
CREATE TABLE counseling_sessions (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL,
    counselor_id BIGINT NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'personal' CHECK (type IN ('personal', 'academic', 'career', 'social')),
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    scheduled_date DATE NOT NULL,
    scheduled_time TIME NOT NULL,
    actual_date DATE,
    actual_time TIME,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    result TEXT,
    follow_up TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_counseling_sessions_student FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_counseling_sessions_counselor FOREIGN KEY (counselor_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create indexes for PKL and BK tables
CREATE INDEX idx_pkl_internships_student ON pkl_internships(student_id);
CREATE INDEX idx_pkl_internships_guru_pembimbing ON pkl_internships(guru_pembimbing_id);
CREATE INDEX idx_pkl_internships_status ON pkl_internships(status);
CREATE INDEX idx_internships_user ON internships(user_id);
CREATE INDEX idx_internships_status ON internships(status);
CREATE INDEX idx_career_guidances_student ON career_guidances(student_id);
CREATE INDEX idx_counseling_sessions_student ON counseling_sessions(student_id);
CREATE INDEX idx_counseling_sessions_counselor ON counseling_sessions(counselor_id);
CREATE INDEX idx_counseling_sessions_status ON counseling_sessions(status); 