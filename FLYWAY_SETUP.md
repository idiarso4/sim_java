# Flyway Setup & Usage Guide

Panduan lengkap untuk setup dan penggunaan Flyway database migration di Sistem Manajemen Sekolah.

---

## 📋 **Table of Contents**
1. [Prerequisites](#prerequisites)
2. [Setup Database](#setup-database)
3. [Flyway Configuration](#flyway-configuration)
4. [Migration Files](#migration-files)
5. [Running Migrations](#running-migrations)
6. [Development Workflow](#development-workflow)
7. [Troubleshooting](#troubleshooting)

---

## 🔧 **Prerequisites**

### Software Requirements
- Java 17+
- Maven 3.6+
- PostgreSQL 12+
- IDE (IntelliJ IDEA, Eclipse, VS Code)

### Database Setup
```bash
# Create database
createdb sistem_manajemen_sekolah

# Or using psql
psql -U postgres
CREATE DATABASE sistem_manajemen_sekolah;
\q
```

---

## 🗄️ **Setup Database**

### 1. PostgreSQL Installation
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# macOS
brew install postgresql

# Windows
# Download from https://www.postgresql.org/download/windows/
```

### 2. Database Configuration
```bash
# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create user (optional)
sudo -u postgres createuser --interactive
# Enter name of role to add: sekolah_user
# Shall the new role be a superuser? (y/n) n
# Shall the new role be allowed to create databases? (y/n) y
# Shall the new role be allowed to create more new roles? (y/n) n

# Set password
sudo -u postgres psql
ALTER USER sekolah_user PASSWORD 'password123';
\q
```

### 3. Update Application Properties
```properties
# application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/sistem_manajemen_sekolah
spring.datasource.username=sekolah_user
spring.datasource.password=password123
```

---

## ⚙️ **Flyway Configuration**

### 1. Maven Dependencies
```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-database-postgresql</artifactId>
</dependency>
```

### 2. Application Properties
```properties
# Flyway Configuration
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
spring.flyway.baseline-on-migrate=true
spring.flyway.validate-on-migrate=true
spring.flyway.clean-disabled=false
spring.flyway.baseline-version=0
spring.flyway.baseline-description=Initial baseline
```

### 3. Maven Plugin
```xml
<plugin>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-maven-plugin</artifactId>
    <version>10.8.1</version>
    <configuration>
        <url>jdbc:postgresql://localhost:5432/sistem_manajemen_sekolah</url>
        <user>sekolah_user</user>
        <password>password123</password>
        <locations>
            <location>classpath:db/migration</location>
        </locations>
    </configuration>
</plugin>
```

---

## 📁 **Migration Files**

### File Structure
```
src/main/resources/db/migration/
├── V1__Create_initial_schema.sql
├── V2__Create_attendance_tables.sql
├── V3__Create_teaching_activities_tables.sql
├── V4__Create_pkl_and_bk_tables.sql
├── V5__Create_assessment_and_extracurricular_tables.sql
├── V6__Create_administrative_tables.sql
└── V7__Insert_initial_data.sql
```

### Naming Convention
- `V` - Version migration
- `1` - Version number (sequential)
- `__` - Separator (double underscore)
- `Description` - Human readable description
- `.sql` - SQL file extension

### Migration Types
- **V** - Version migration (schema changes)
- **U** - Undo migration (rollback)
- **R** - Repeatable migration (data seeding)

---

## 🚀 **Running Migrations**

### 1. Using Maven
```bash
# Check migration status
mvn flyway:info

# Run migrations
mvn flyway:migrate

# Clean database (WARNING: This will delete all data!)
mvn flyway:clean

# Repair migration
mvn flyway:repair

# Validate migration
mvn flyway:validate
```

### 2. Using Spring Boot
```bash
# Run application (migrations will run automatically)
mvn spring-boot:run
```

### 3. Using Flyway CLI
```bash
# Install Flyway CLI
# Download from https://flywaydb.org/download

# Run migration
flyway -url=jdbc:postgresql://localhost:5432/sistem_manajemen_sekolah \
       -user=sekolah_user \
       -password=password123 \
       migrate
```

---

## 🔄 **Development Workflow**

### 1. Creating New Migration
```bash
# Create new migration file
touch src/main/resources/db/migration/V8__Add_new_feature.sql
```

### 2. Migration Content Example
```sql
-- V8__Add_new_feature.sql
-- Description: Add new feature table
-- Author: Developer Name
-- Date: 2024-01-15

-- Add new table
CREATE TABLE new_feature (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add index
CREATE INDEX idx_new_feature_name ON new_feature(name);
```

### 3. Testing Migration
```bash
# Test on development database
mvn flyway:migrate

# Check if migration applied correctly
mvn flyway:info
```

### 4. Rollback (if needed)
```bash
# Clean and reapply
mvn flyway:clean
mvn flyway:migrate
```

---

## 🛠️ **Troubleshooting**

### Common Issues

#### 1. Migration Failed
```bash
# Check migration status
mvn flyway:info

# Check database connection
psql -U sekolah_user -d sistem_manajemen_sekolah -c "\dt"

# Repair migration
mvn flyway:repair
```

#### 2. Version Conflict
```sql
-- Check flyway_schema_history table
SELECT * FROM flyway_schema_history ORDER BY installed_rank DESC;
```

#### 3. Permission Issues
```bash
# Grant permissions to user
sudo -u postgres psql
GRANT ALL PRIVILEGES ON DATABASE sistem_manajemen_sekolah TO sekolah_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sekolah_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sekolah_user;
\q
```

#### 4. Connection Issues
```bash
# Check PostgreSQL service
sudo systemctl status postgresql

# Check connection
psql -U sekolah_user -d sistem_manajemen_sekolah -c "SELECT 1;"
```

### Debug Commands
```bash
# Enable SQL logging
# Add to application.properties
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
logging.level.org.flywaydb=DEBUG

# Check migration files
ls -la src/main/resources/db/migration/

# Validate migration files
mvn flyway:validate
```

---

## 📊 **Migration Status**

### Check Current Status
```bash
mvn flyway:info
```

### Expected Output
```
+-----------+---------+---------------------+------+---------------------+---------+
| Category  | Version | Description         | Type | Installed On        | State   |
+-----------+---------+---------------------+------+---------------------+---------+
|           | 0       | Initial baseline    |      | 2024-01-15 10:00:00 | Baselin |
| Versioned | 1       | Create initial      | SQL  | 2024-01-15 10:00:01 | Success |
| Versioned | 2       | Create attendance   | SQL  | 2024-01-15 10:00:02 | Success |
| Versioned | 3       | Create teaching     | SQL  | 2024-01-15 10:00:03 | Success |
| Versioned | 4       | Create pkl and bk   | SQL  | 2024-01-15 10:00:04 | Success |
| Versioned | 5       | Create assessment   | SQL  | 2024-01-15 10:00:05 | Success |
| Versioned | 6       | Create administrat | SQL  | 2024-01-15 10:00:06 | Success |
| Versioned | 7       | Insert initial data | SQL  | 2024-01-15 10:00:07 | Success |
+-----------+---------+---------------------+------+---------------------+---------+
```

---

## 🔒 **Production Deployment**

### 1. Production Configuration
```properties
# application-prod.properties
spring.flyway.clean-disabled=true
spring.flyway.validate-on-migrate=true
spring.flyway.baseline-on-migrate=false
```

### 2. Backup Before Migration
```bash
# Create backup
pg_dump -U sekolah_user -d sistem_manajemen_sekolah > backup_$(date +%Y%m%d_%H%M%S).sql

# Run migration
mvn flyway:migrate

# Verify migration
mvn flyway:info
```

### 3. Rollback Strategy
```bash
# If migration fails, restore from backup
psql -U sekolah_user -d sistem_manajemen_sekolah < backup_20240115_100000.sql
```

---

## 📚 **Best Practices**

### 1. Migration Guidelines
- Always test migrations on development database first
- Use descriptive migration names
- Keep migrations small and focused
- Never modify existing migration files
- Always backup before running migrations in production

### 2. Version Control
```bash
# Commit migration files
git add src/main/resources/db/migration/
git commit -m "Add V8__Add_new_feature migration"

# Tag releases
git tag -a v1.0.0 -m "Release version 1.0.0"
```

### 3. Team Collaboration
- Coordinate migration development with team
- Use sequential version numbers
- Document complex migrations
- Review migration files before committing

---

## 🎯 **Quick Start Commands**

```bash
# 1. Setup database
createdb sistem_manajemen_sekolah

# 2. Update application.properties with database credentials

# 3. Run migrations
mvn flyway:migrate

# 4. Check status
mvn flyway:info

# 5. Start application
mvn spring-boot:run
```

---

## 📞 **Support**

If you encounter issues:

1. Check the troubleshooting section above
2. Review Flyway documentation: https://flywaydb.org/documentation/
3. Check application logs for detailed error messages
4. Verify database connection and permissions
5. Ensure migration files are properly formatted

---

**Happy Migrating! 🚀** 