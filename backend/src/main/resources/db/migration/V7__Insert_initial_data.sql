-- Migration: V7__Insert_initial_data.sql
-- Description: Insert initial data for the system
-- Author: System
-- Date: 2024-01-15

-- Insert departments
INSERT INTO departments (name, kode, status) VALUES
('Rekayasa Perangkat Lunak', 'RPL', true),
('Teknik Komputer dan Jaringan', 'TKJ', true),
('Multimedia', 'MM', true),
('Akuntansi', 'AK', true),
('Administrasi Perkantoran', 'AP', true);

-- Insert school years
INSERT INTO school_years (tahun, semester, status) VALUES
('2024/2025', 'ganjil', 'aktif'),
('2024/2025', 'genap', 'tidak aktif'),
('2023/2024', 'ganjil', 'tidak aktif'),
('2023/2024', 'genap', 'tidak aktif');

-- Insert shifts
INSERT INTO shifts (name, start_time, end_time) VALUES
('Pagi', '07:00:00', '15:00:00'),
('Sore', '13:00:00', '21:00:00'),
('Shift 1', '08:00:00', '16:00:00'),
('Shift 2', '16:00:00', '00:00:00');

-- Insert subjects
INSERT INTO subjects (name, code, description, is_active) VALUES
('Matematika', 'MTK', 'Mata pelajaran Matematika', true),
('Bahasa Indonesia', 'BIN', 'Mata pelajaran Bahasa Indonesia', true),
('Bahasa Inggris', 'BIG', 'Mata pelajaran Bahasa Inggris', true),
('Sejarah', 'SEJ', 'Mata pelajaran Sejarah', true),
('Geografi', 'GEO', 'Mata pelajaran Geografi', true),
('Ekonomi', 'EKO', 'Mata pelajaran Ekonomi', true),
('Fisika', 'FIS', 'Mata pelajaran Fisika', true),
('Kimia', 'KIM', 'Mata pelajaran Kimia', true),
('Biologi', 'BIO', 'Mata pelajaran Biologi', true),
('Seni Budaya', 'SBD', 'Mata pelajaran Seni Budaya', true),
('Pendidikan Jasmani', 'PJK', 'Mata pelajaran Pendidikan Jasmani', true),
('Pendidikan Agama', 'PAI', 'Mata pelajaran Pendidikan Agama', true),
('Pemrograman Dasar', 'PD', 'Mata pelajaran Pemrograman Dasar', true),
('Komputer dan Jaringan Dasar', 'KJD', 'Mata pelajaran Komputer dan Jaringan Dasar', true),
('Administrasi Sistem', 'AS', 'Mata pelajaran Administrasi Sistem', true);

-- Insert offices (school location and sample companies)
INSERT INTO offices (name, address, latitude, longitude, radius, phone, email, description, type, status) VALUES
('SMK Negeri 1 Jakarta', 'Jl. Pendidikan No. 1, Jakarta Pusat', -6.2088, 106.8456, 100, '021-1234567', 'info@smkn1jakarta.sch.id', 'Lokasi utama sekolah', 'school', true),
('PT. Tech Solutions', 'Jl. Sudirman No. 123, Jakarta Selatan', -6.2088, 106.8456, 50, '021-9876543', 'hr@techsolutions.com', 'Perusahaan teknologi', 'company', true),
('PT. Digital Innovation', 'Jl. Thamrin No. 456, Jakarta Pusat', -6.2088, 106.8456, 50, '021-5555666', 'info@digitalinnovation.com', 'Perusahaan inovasi digital', 'company', true),
('PT. Creative Studio', 'Jl. Gatot Subroto No. 789, Jakarta Selatan', -6.2088, 106.8456, 50, '021-7777888', 'contact@creativestudio.com', 'Studio kreatif', 'company', true);

-- Insert roles
INSERT INTO roles (name, guard_name) VALUES
('super_admin', 'web'),
('admin', 'web'),
('guru', 'web'),
('siswa', 'web');

-- Insert permissions
INSERT INTO permissions (name, guard_name) VALUES
-- User management
('users.view', 'web'),
('users.create', 'web'),
('users.edit', 'web'),
('users.delete', 'web'),

-- Student management
('students.view', 'web'),
('students.create', 'web'),
('students.edit', 'web'),
('students.delete', 'web'),

-- Attendance management
('attendance.view', 'web'),
('attendance.create', 'web'),
('attendance.edit', 'web'),
('attendance.delete', 'web'),

-- Teaching activities
('teaching.view', 'web'),
('teaching.create', 'web'),
('teaching.edit', 'web'),
('teaching.delete', 'web'),

-- PKL management
('pkl.view', 'web'),
('pkl.create', 'web'),
('pkl.edit', 'web'),
('pkl.delete', 'web'),
('pkl.approve', 'web'),

-- BK management
('bk.view', 'web'),
('bk.create', 'web'),
('bk.edit', 'web'),
('bk.delete', 'web'),

-- Assessment management
('assessment.view', 'web'),
('assessment.create', 'web'),
('assessment.edit', 'web'),
('assessment.delete', 'web'),

-- Extracurricular management
('extracurricular.view', 'web'),
('extracurricular.create', 'web'),
('extracurricular.edit', 'web'),
('extracurricular.delete', 'web'),

-- Administrative
('leaves.view', 'web'),
('leaves.create', 'web'),
('leaves.approve', 'web'),
('reports.view', 'web'),
('reports.export', 'web');

-- Assign permissions to roles
-- Super Admin gets all permissions
INSERT INTO role_has_permissions (permission_id, role_id)
SELECT p.id, r.id FROM permissions p, roles r WHERE r.name = 'super_admin';

-- Admin gets most permissions except super admin specific ones
INSERT INTO role_has_permissions (permission_id, role_id)
SELECT p.id, r.id FROM permissions p, roles r 
WHERE r.name = 'admin' 
AND p.name NOT IN ('users.delete', 'system.settings');

-- Guru gets teaching and student related permissions
INSERT INTO role_has_permissions (permission_id, role_id)
SELECT p.id, r.id FROM permissions p, roles r 
WHERE r.name = 'guru' 
AND p.name IN (
    'students.view', 'attendance.view', 'attendance.create', 'attendance.edit',
    'teaching.view', 'teaching.create', 'teaching.edit',
    'assessment.view', 'assessment.create', 'assessment.edit',
    'extracurricular.view', 'extracurricular.create', 'extracurricular.edit',
    'leaves.view', 'leaves.create'
);

-- Siswa gets limited permissions
INSERT INTO role_has_permissions (permission_id, role_id)
SELECT p.id, r.id FROM permissions p, roles r 
WHERE r.name = 'siswa' 
AND p.name IN (
    'students.view', 'attendance.view', 'attendance.create',
    'pkl.view', 'pkl.create',
    'bk.view', 'bk.create',
    'extracurricular.view',
    'leaves.view', 'leaves.create'
);

-- Insert sample class rooms
INSERT INTO class_rooms (name, level, department_id, school_year_id, is_active) VALUES
('XII RPL 1', 'XII', 1, 1, true),
('XII RPL 2', 'XII', 1, 1, true),
('XII TKJ 1', 'XII', 2, 1, true),
('XII TKJ 2', 'XII', 2, 1, true),
('XII MM 1', 'XII', 3, 1, true),
('XII AK 1', 'XII', 4, 1, true),
('XII AP 1', 'XII', 5, 1, true);

-- Insert sample extracurriculars
INSERT INTO extracurriculars (nama, deskripsi, hari, jam_mulai, jam_selesai, tempat, status) VALUES
('Rohis', 'Rohani Islam', 'Jumat', '15:00:00', '17:00:00', 'Masjid Sekolah', true),
('PMR', 'Palang Merah Remaja', 'Sabtu', '08:00:00', '12:00:00', 'Ruang PMR', true),
('Pramuka', 'Kepramukaan', 'Sabtu', '08:00:00', '12:00:00', 'Lapangan Sekolah', true),
('English Club', 'Klub Bahasa Inggris', 'Selasa', '15:00:00', '17:00:00', 'Ruang Bahasa', true),
('IT Club', 'Klub Teknologi Informasi', 'Rabu', '15:00:00', '17:00:00', 'Lab Komputer', true),
('Basket', 'Tim Basket Sekolah', 'Senin', '15:00:00', '17:00:00', 'Lapangan Basket', true),
('Futsal', 'Tim Futsal Sekolah', 'Kamis', '15:00:00', '17:00:00', 'Lapangan Futsal', true); 