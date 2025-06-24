# Setup script for Maven and PostgreSQL

# Function to download files
function Download-File {
    param (
        [string]$url,
        [string]$outputPath
    )
    try {
        Write-Host "Downloading $url to $outputPath"
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    } catch {
        Write-Error "Failed to download $url"
        exit 1
    }
}

# Function to create database
function Create-Database {
    param (
        [string]$dbName = "sistem_manajemen_sekolah"
    )
    
    $psqlPath = "C:\Program Files\PostgreSQL\15\bin\psql.exe"
    if (-not (Test-Path $psqlPath)) {
        Write-Error "PostgreSQL not found at expected location. Please install PostgreSQL first."
        exit 1
    }

    # Create database
    Write-Host "Creating database $dbName"
    & $psqlPath -U postgres -c "CREATE DATABASE $dbName;"
}

# Download Maven
$MAVEN_URL = "https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
$MAVEN_ZIP = "apache-maven-3.9.6-bin.zip"
$MAVEN_DIR = "C:\Program Files\Apache\maven"

Write-Host "Starting setup process..."

# Create Maven directory
if (-not (Test-Path $MAVEN_DIR)) {
    New-Item -ItemType Directory -Path $MAVEN_DIR -Force
}

# Download Maven
Download-File -url $MAVEN_URL -outputPath $MAVEN_ZIP

# Extract Maven
Write-Host "Extracting Maven..."
Expand-Archive -Path $MAVEN_ZIP -DestinationPath $MAVEN_DIR -Force

# Remove zip file
Remove-Item $MAVEN_ZIP

# Add Maven to PATH
$env:Path += ";$MAVEN_DIR\apache-maven-3.9.6\bin"

# Check if PostgreSQL is installed
$POSTGRES_PATH = "C:\Program Files\PostgreSQL\15\bin"
if (-not (Test-Path $POSTGRES_PATH)) {
    Write-Host "PostgreSQL is not installed. Please install PostgreSQL first from:"
    Write-Host "https://www.postgresql.org/download/windows/"
    exit 1
}

# Create database
Create-Database

Write-Host "Setup completed successfully!"
Write-Host "Next steps:"
Write-Host "1. Ensure PostgreSQL is running."
Write-Host "2. Update the database password in backend\src\main\resources\application.yml with the password you set for the 'postgres' user."
Write-Host "3. Navigate to the backend directory and run the application: cd backend; mvn spring-boot:run"
