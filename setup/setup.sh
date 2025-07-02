#!/bin/bash

# 🚀 AI Development Setup Script
# This script installs everything you need for AI-powered development
# Works on macOS, Linux, and Windows (WSL)

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "\n${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew (macOS/Linux)
install_homebrew() {
    if ! command_exists brew; then
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Initialize Homebrew in current shell
        if [[ "$OS" == "macos" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ "$OS" == "linux" ]]; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
        
        print_success "Homebrew installed and initialized"
    else
        print_success "Homebrew already installed"
    fi
}

# Install Node.js
install_node() {
    if ! command_exists node; then
        print_step "Installing Node.js..."
        
        if [[ "$OS" == "macos" || "$OS" == "linux" ]]; then
            brew install node
        else
            # Windows - download installer
            print_warning "Please install Node.js from https://nodejs.org/"
            print_warning "Then run this script again"
            exit 1
        fi
        
        print_success "Node.js installed"
    else
        print_success "Node.js already installed ($(node --version))"
    fi
}

# Install Git
install_git() {
    if ! command_exists git; then
        print_step "Installing Git..."
        
        if [[ "$OS" == "macos" || "$OS" == "linux" ]]; then
            brew install git
        else
            print_warning "Please install Git from https://git-scm.com/"
            print_warning "Then run this script again"
            exit 1
        fi
        
        print_success "Git installed"
    else
        print_success "Git already installed ($(git --version))"
    fi
}

# Install GitHub CLI
install_gh() {
    if ! command_exists gh; then
        print_step "Installing GitHub CLI..."
        
        if [[ "$OS" == "macos" || "$OS" == "linux" ]]; then
            brew install gh
        else
            print_warning "Please install GitHub CLI from https://cli.github.com/"
            print_warning "Then run this script again"
            exit 1
        fi
        
        print_success "GitHub CLI installed"
    else
        print_success "GitHub CLI already installed"
    fi
}

# Install Cursor
install_cursor() {
    print_step "Checking for Cursor..."
    
    if [[ "$OS" == "macos" ]]; then
        if [[ ! -d "/Applications/Cursor.app" ]]; then
            print_step "Installing Cursor..."
            brew install --cask cursor
            print_success "Cursor installed"
        else
            print_success "Cursor already installed"
        fi
    else
        print_warning "Please download Cursor from https://cursor.sh/"
        print_warning "Install it, then continue"
        read -p "Press Enter when Cursor is installed..."
    fi
}

# Install Claude Code (Claude Desktop)
install_claude() {
    print_step "Installing Claude Code..."
    
    if ! command_exists claude; then
        if [[ "$OS" == "macos" || "$OS" == "linux" ]]; then
            print_step "Installing Claude Code via npm..."
            npm install -g @anthropic-ai/claude-code
            print_success "Claude Code installed"
        else
            print_warning "Please install Claude Desktop from https://claude.ai/download"
            print_warning "This gives you access to Claude Code"
            read -p "Press Enter when Claude is installed..."
        fi
    else
        print_success "Claude Code already installed"
    fi
}

# Install common web development dependencies
install_web_deps() {
    print_step "Installing common web development tools..."
    
    # Check if npm is available
    if command_exists npm; then
        print_step "Installing global npm packages..."
        
        # Create-react-app for React projects
        if ! command_exists create-react-app; then
            npm install -g create-react-app
            print_success "create-react-app installed"
        fi
        
        # Vite for modern web projects
        if ! command_exists vite; then
            npm install -g vite
            print_success "Vite installed"
        fi
        
        # TypeScript
        if ! command_exists tsc; then
            npm install -g typescript
            print_success "TypeScript installed"
        fi
        
        # Prettier for code formatting
        if ! command_exists prettier; then
            npm install -g prettier
            print_success "Prettier installed"
        fi
        
        # ESLint for code linting
        if ! command_exists eslint; then
            npm install -g eslint
            print_success "ESLint installed"
        fi
        
        # Vercel CLI for deployment
        if ! command_exists vercel; then
            npm install -g vercel
            print_success "Vercel CLI installed"
        fi
        
        # Netlify CLI for deployment
        if ! command_exists netlify; then
            npm install -g netlify-cli
            print_success "Netlify CLI installed"
        fi
        
        print_success "Web development tools installed"
    else
        print_warning "npm not found - skipping web dependency installation"
    fi
}

# Configure Git (for beginners)
configure_git() {
    print_step "Configuring Git..."
    
    # Check if git is already configured
    if [[ -z $(git config --global user.email) ]]; then
        print_warning "Let's set up your Git identity (used for commits)"
        read -p "Enter your name: " git_name
        read -p "Enter your email: " git_email
        
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        
        print_success "Git configured"
    else
        print_success "Git already configured for $(git config --global user.name)"
    fi
}

# Verify project setup
verify_project() {
    print_step "Verifying AI Starter Kit setup..."
    
    # Check if we're in the starter kit directory
    if [[ ! -f "AI_DEVELOPMENT_GUIDE.md" ]]; then
        print_error "AI_DEVELOPMENT_GUIDE.md not found!"
        print_error "Please run this script from the ai-starter-kit directory"
        print_error "You should already have the starter kit downloaded locally"
        exit 1
    fi
    
    print_success "Project structure verified!"
}

# Main installation flow
main() {
    echo -e "${BLUE}🚀 AI Development Environment Setup${NC}"
    echo "This script will install everything you need for AI-powered development"
    echo
    
    # Detect OS
    detect_os
    echo "Detected OS: $OS"
    
    # Confirm before proceeding
    read -p "Ready to start? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Setup cancelled"
        exit 0
    fi
    
    # Install dependencies based on OS
    if [[ "$OS" == "macos" || "$OS" == "linux" ]]; then
        install_homebrew
    fi
    
    install_git
    install_node
    install_gh
    install_cursor
    install_claude
    install_web_deps
    configure_git
    verify_project
    
    # Final instructions
    echo
    echo -e "${GREEN}🎉 Setup Complete!${NC}"
    echo
    echo "Next steps:"
    echo "1. Open this folder in Cursor"
    echo "2. Read AI_DEVELOPMENT_GUIDE.md"
    echo "3. Start building with AI!"
    echo
    echo "Quick commands:"
    echo "  cursor .          # Open Cursor in this directory"
    echo "  claude --help     # See Claude Code commands"
    echo "  gh issue list     # View GitHub issues"
    echo
    print_success "Happy coding! 🚀"
}

# Run main function
main