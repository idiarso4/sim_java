#!/bin/bash

# This script sets up the development environment for the SIM Java Frontend project

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Setting up SIM Java Frontend Development Environment...${NC}"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}❌ Flutter is not installed. Please install Flutter and try again.${NC}"
    echo -e "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo -e "${GREEN}✅ Found Flutter: $FLUTTER_VERSION${NC}"

# Install Flutter dependencies
echo -e "${YELLOW}📦 Installing Flutter dependencies...${NC}"
flutter pub get

# Copy .env.example to .env if it doesn't exist
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}📄 Creating .env file from .env.example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ Created .env file. Please update it with your configuration.${NC}"
else
    echo -e "${GREEN}✅ .env file already exists.${NC}"
fi

# Generate code
if [ -d "lib/generated" ]; then
    echo -e "${YELLOW}🧹 Cleaning generated code...${NC}"
    rm -rf lib/generated/
fi

echo -e "${YELLOW}🔨 Generating code...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs

# Check for iOS-specific setup
if [ "$(uname)" == "Darwin" ]; then
    if [ -d "ios" ]; then
        echo -e "${YELLOW}🍏 Setting up iOS dependencies...${NC}"
        cd ios
        pod install || {
            echo -e "${YELLOW}⚠️  Failed to install iOS dependencies. You may need to run 'pod install' manually.${NC}"
        }
        cd ..
    fi
fi

echo -e "\n${GREEN}✨ Setup complete! You can now run the app using:${NC}"
echo -e "  flutter run -d <device_id>"
echo -e "\n${YELLOW}Don't forget to:${NC}"
echo -e "  1. Update the .env file with your configuration"
echo -e "  2. Run 'flutter pub run build_runner watch' for continuous code generation during development"
echo -e "\n${GREEN}Happy coding! 🚀${NC}"
