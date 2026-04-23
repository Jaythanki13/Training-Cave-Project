-- ═══════════════════════════════════════════════════════════════
-- TRAINING CAVE PLATFORM - DATABASE SCHEMA
-- PostgreSQL Database Design
-- ═══════════════════════════════════════════════════════════════

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ═══════════════════════════════════════════════════════════════
-- USERS TABLE
-- Stores all user accounts (learners, trainers, admins)
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('super_admin', 'trainer', 'learner')),
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'pending', 'banned', 'inactive')),
    
    -- Optional profile fields
    profile_bio TEXT,
    expertise_areas TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE,
    
    -- Indexes
    INDEX idx_users_email (email),
    INDEX idx_users_role (role),
    INDEX idx_users_status (status)
);

-- ═══════════════════════════════════════════════════════════════
-- CATEGORIES TABLE
-- Training material categories (your 7 categories)
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    slug VARCHAR(100) UNIQUE NOT NULL,
    display_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert your 7 categories
INSERT INTO categories (name, description, slug, display_order) VALUES
('Soft Skills', 'Handouts, Workbooks, PPTs, Pre-read & Post-read materials, Gamification activities', 'soft-skills', 1),
('Technical Training', 'Pre-training materials, Handouts/PPTs, Code files & Datasets, Post-training materials', 'technical-training', 2),
('AI & Trending Technologies', 'Machine Learning, Generative AI, Cloud, DevOps and emerging tech', 'ai-trending-tech', 3),
('Security Training', 'Cybersecurity, InfoSec, Compliance, Ethical Hacking', 'security-training', 4),
('Tool-Based Training', 'Software tools, Platforms, Applications', 'tool-based-training', 5),
('Official Certifications', 'CSM, CSPO, Salesforce, Microsoft, AWS, Google Cloud certifications', 'official-certifications', 6),
('Healthcare Training', 'Medical, Clinical, Healthcare IT, Compliance', 'healthcare-training', 7);

-- ═══════════════════════════════════════════════════════════════
-- MATERIALS TABLE
-- All training materials uploaded by trainers
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Ownership
    trainer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Material info
    title VARCHAR(500) NOT NULL,
    description TEXT NOT NULL,
    category_id UUID NOT NULL REFERENCES categories(id),
    tags TEXT[], -- Array of tags for search
    
    -- File info
    file_name VARCHAR(500) NOT NULL,
    file_url TEXT NOT NULL, -- S3 URL
    file_size BIGINT NOT NULL, -- Size in bytes
    file_type VARCHAR(50) NOT NULL, -- pdf, docx, pptx, mp4, etc.
    file_mime_type VARCHAR(100),
    
    -- Training details
    training_date DATE NOT NULL,
    training_type VARCHAR(20) NOT NULL CHECK (training_type IN ('delivered', 'upcoming')),
    
    -- Metadata
    download_count INT DEFAULT 0,
    rating_avg DECIMAL(3,2) DEFAULT 0.00, -- Average rating (0.00 to 5.00)
    rating_count INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted')),
    
    -- Timestamps
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_materials_trainer (trainer_id),
    INDEX idx_materials_category (category_id),
    INDEX idx_materials_status (status),
    INDEX idx_materials_training_date (training_date),
    INDEX idx_materials_uploaded_at (uploaded_at DESC),
    INDEX idx_materials_download_count (download_count DESC),
    INDEX idx_materials_rating (rating_avg DESC)
);

-- Full-text search index on title and description
CREATE INDEX idx_materials_search ON materials USING GIN(to_tsvector('english', title || ' ' || description));

-- ═══════════════════════════════════════════════════════════════
-- DOWNLOADS TABLE
-- Track who downloaded what and when
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE downloads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    material_id UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_downloads_material (material_id),
    INDEX idx_downloads_user (user_id),
    INDEX idx_downloads_date (downloaded_at DESC)
);

-- ═══════════════════════════════════════════════════════════════
-- RATINGS TABLE
-- User ratings for materials
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    material_id UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique constraint: one rating per user per material
    UNIQUE(material_id, user_id),
    
    -- Indexes
    INDEX idx_ratings_material (material_id),
    INDEX idx_ratings_user (user_id)
);

-- ═══════════════════════════════════════════════════════════════
-- BOOKMARKS TABLE
-- User saved/favorited materials
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    material_id UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique constraint: one bookmark per user per material
    UNIQUE(material_id, user_id),
    
    -- Indexes
    INDEX idx_bookmarks_user (user_id),
    INDEX idx_bookmarks_material (material_id)
);

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATIONS TABLE
-- Admin notifications (trainer registrations, new uploads, etc)
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type VARCHAR(50) NOT NULL, -- 'trainer_registration', 'new_upload', 'material_flagged', etc.
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    related_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    related_material_id UUID REFERENCES materials(id) ON DELETE SET NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_notifications_read (is_read),
    INDEX idx_notifications_date (created_at DESC)
);

-- ═══════════════════════════════════════════════════════════════
-- AUDIT LOG TABLE
-- Track important actions for security/debugging
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL, -- 'user_created', 'material_uploaded', 'trainer_approved', etc.
    entity_type VARCHAR(50), -- 'user', 'material', etc.
    entity_id UUID,
    details JSONB, -- Additional context
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_audit_user (user_id),
    INDEX idx_audit_action (action),
    INDEX idx_audit_date (created_at DESC)
);

-- ═══════════════════════════════════════════════════════════════
-- FUNCTIONS & TRIGGERS
-- ═══════════════════════════════════════════════════════════════

-- Auto-update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_materials_updated_at BEFORE UPDATE ON materials
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ratings_updated_at BEFORE UPDATE ON ratings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ═══════════════════════════════════════════════════════════════
-- FUNCTION: Update material rating average
-- ═══════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION update_material_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE materials
    SET 
        rating_avg = (SELECT AVG(rating) FROM ratings WHERE material_id = NEW.material_id),
        rating_count = (SELECT COUNT(*) FROM ratings WHERE material_id = NEW.material_id)
    WHERE id = NEW.material_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_material_rating_trigger
    AFTER INSERT OR UPDATE OR DELETE ON ratings
    FOR EACH ROW EXECUTE FUNCTION update_material_rating();

-- ═══════════════════════════════════════════════════════════════
-- FUNCTION: Increment download count
-- ═══════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION increment_download_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE materials
    SET download_count = download_count + 1
    WHERE id = NEW.material_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER increment_download_count_trigger
    AFTER INSERT ON downloads
    FOR EACH ROW EXECUTE FUNCTION increment_download_count();

-- ═══════════════════════════════════════════════════════════════
-- INITIAL DATA: Create super admin account
-- ═══════════════════════════════════════════════════════════════

-- Password: 'admin123' (CHANGE THIS IN PRODUCTION!)
-- This is just for initial setup
INSERT INTO users (email, password_hash, full_name, role, status)
VALUES (
    'jay.thanki@cognixia.com',
    '$2b$10$XqKn1Y8k8ZoqZ8mZ8mZ8mOe8mZ8mZ8mZ8mZ8mZ8mZ8mZ8mZ8mZ8m', -- Hash of 'admin123'
    'Jay Thanki',
    'super_admin',
    'active'
);

-- ═══════════════════════════════════════════════════════════════
-- INDEXES FOR PERFORMANCE
-- ═══════════════════════════════════════════════════════════════

-- Composite indexes for common queries
CREATE INDEX idx_materials_category_status ON materials(category_id, status);
CREATE INDEX idx_materials_trainer_status ON materials(trainer_id, status);
CREATE INDEX idx_downloads_user_material ON downloads(user_id, material_id);

-- ═══════════════════════════════════════════════════════════════
-- VIEWS FOR COMMON QUERIES
-- ═══════════════════════════════════════════════════════════════

-- View: Popular materials (for learner dashboard)
CREATE VIEW popular_materials AS
SELECT 
    m.id,
    m.title,
    m.description,
    m.file_type,
    m.file_size,
    m.download_count,
    m.rating_avg,
    m.rating_count,
    m.uploaded_at,
    c.name as category_name,
    u.full_name as trainer_name
FROM materials m
JOIN categories c ON m.category_id = c.id
JOIN users u ON m.trainer_id = u.id
WHERE m.status = 'active'
ORDER BY m.download_count DESC, m.rating_avg DESC;

-- View: Trainer statistics
CREATE VIEW trainer_stats AS
SELECT 
    u.id as trainer_id,
    u.full_name,
    COUNT(DISTINCT m.id) as total_uploads,
    COALESCE(SUM(m.download_count), 0) as total_downloads,
    COALESCE(AVG(m.rating_avg), 0) as average_rating
FROM users u
LEFT JOIN materials m ON u.id = m.trainer_id AND m.status = 'active'
WHERE u.role = 'trainer'
GROUP BY u.id, u.full_name;

-- ═══════════════════════════════════════════════════════════════
-- END OF SCHEMA
-- ═══════════════════════════════════════════════════════════════
