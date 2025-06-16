#!/usr/bin/env bash
#
# Development utilities for LaTeX resume project
# Provides convenient commands for common development tasks
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="backups"
VERSIONS_DIR="build/versions"

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_header() {
    echo -e "${PURPLE}🚀 $1${NC}"
    echo "========================================"
}

# Check if we're in the right directory
check_project_root() {
    if [ ! -f "Makefile" ] || [ ! -f "resume.tex" ]; then
        log_error "Not in LaTeX resume project root directory"
        exit 1
    fi
}

# Install git hooks
install_hooks() {
    log_header "Installing Git Hooks"
    
    if [ ! -d ".git" ]; then
        log_error "Not a git repository"
        return 1
    fi
    
    # Create hooks directory if it doesn't exist
    mkdir -p .git/hooks
    
    # Install pre-commit hook
    if [ -f ".githooks/pre-commit" ]; then
        cp .githooks/pre-commit .git/hooks/pre-commit
        chmod +x .git/hooks/pre-commit
        log_success "Pre-commit hook installed"
    else
        log_warning "Pre-commit hook file not found"
    fi
}

# Create backup of current state
create_backup() {
    log_header "Creating Backup"
    
    timestamp=$(date +"%Y%m%d_%H%M%S")
    backup_name="backup_${timestamp}"
    
    mkdir -p "$BACKUP_DIR"
    
    # Create tar archive of source files
    tar -czf "${BACKUP_DIR}/${backup_name}.tar.gz" \
        --exclude="build/*" \
        --exclude="backups/*" \
        --exclude=".git/*" \
        .
    
    log_success "Backup created: ${BACKUP_DIR}/${backup_name}.tar.gz"
}

# Generate project statistics
project_stats() {
    log_header "Project Statistics"
    
    echo "📄 Document Files:"
    find . -name "*.tex" -not -path "./build/*" | wc -l | xargs echo "  LaTeX files:"
    
    echo ""
    echo "📊 Content Analysis:"
    if [ -d "content" ]; then
        echo "  Content sections: $(ls content/*.tex 2>/dev/null | wc -l)"
        if [ -f "content/lijun.bib" ]; then
            echo "  Bibliography entries: $(grep -c "^@" content/lijun.bib || echo "0")"
        fi
    fi
    
    echo ""
    echo "🔨 Build Artifacts:"
    if [ -d "build" ]; then
        echo "  PDF files: $(ls build/*.pdf 2>/dev/null | wc -l)"
        if ls build/*.pdf >/dev/null 2>&1; then
            echo "  Total PDF size: $(du -ch build/*.pdf 2>/dev/null | tail -1 | cut -f1)"
        fi
        echo "  Build directory size: $(du -sh build 2>/dev/null | cut -f1)"
    fi
    
    echo ""
    echo "📈 Code Metrics:"
    total_lines=$(find . -name "*.tex" -not -path "./build/*" -exec wc -l {} + | tail -1 | awk '{print $1}')
    echo "  Total lines of LaTeX: $total_lines"
    
    if command -v git >/dev/null 2>&1 && [ -d ".git" ]; then
        echo "  Git commits: $(git rev-list --count HEAD 2>/dev/null || echo "N/A")"
        echo "  Last commit: $(git log -1 --format="%cd" --date=short 2>/dev/null || echo "N/A")"
    fi
}

# Clean and optimize project
deep_clean() {
    log_header "Deep Cleaning Project"
    
    # Standard clean
    make clean
    
    # Remove additional temporary files
    find . -name "*.aux" -delete
    find . -name "*.log" -delete
    find . -name "*.out" -delete
    find . -name "*.toc" -delete
    find . -name "*.synctex.gz" -delete
    find . -name "*~" -delete
    find . -name ".DS_Store" -delete
    
    # Clean up backup directory if it gets too large
    if [ -d "$BACKUP_DIR" ]; then
        backup_count=$(ls -1 "$BACKUP_DIR" | wc -l)
        if [ "$backup_count" -gt 10 ]; then
            log_warning "Backup directory has $backup_count files"
            log_info "Consider cleaning old backups manually"
        fi
    fi
    
    log_success "Deep clean completed"
}

# Optimize PDF files
optimize_pdfs() {
    log_header "Optimizing PDF Files"
    
    if ! command -v gs >/dev/null 2>&1; then
        log_warning "Ghostscript not found - PDF optimization skipped"
        log_info "Install with: brew install ghostscript"
        return
    fi
    
    if [ ! -d "build" ]; then
        log_error "Build directory not found - run 'make all' first"
        return
    fi
    
    for pdf in build/*.pdf; do
        if [ -f "$pdf" ]; then
            original_size=$(stat -f%z "$pdf" 2>/dev/null || stat -c%s "$pdf" 2>/dev/null)
            
            # Create optimized version
            gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
               -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${pdf}.opt" "$pdf"
            
            # Check if optimization was successful
            if [ -f "${pdf}.opt" ]; then
                optimized_size=$(stat -f%z "${pdf}.opt" 2>/dev/null || stat -c%s "${pdf}.opt" 2>/dev/null)
                
                if [ "$optimized_size" -lt "$original_size" ]; then
                    mv "${pdf}.opt" "$pdf"
                    log_success "Optimized $(basename "$pdf"): $(echo "scale=1; $original_size/1024" | bc)KB → $(echo "scale=1; $optimized_size/1024" | bc)KB"
                else
                    rm "${pdf}.opt"
                    log_info "$(basename "$pdf") already optimized"
                fi
            fi
        fi
    done
}

# Setup development environment
setup_dev() {
    log_header "Setting Up Development Environment"
    
    # Install git hooks
    install_hooks
    
    # Create necessary directories
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$VERSIONS_DIR"
    
    # Check dependencies
    log_info "Checking dependencies..."
    make check-deps
    
    # Initial build
    log_info "Performing initial build..."
    make all
    
    log_success "Development environment setup complete!"
}

# Quick development cycle
quick_dev() {
    local doc=${1:-resume}
    
    log_header "Quick Development Cycle for $doc"
    
    # Clean and build
    make clean
    make "$doc"
    
    # Validate
    make validate
    
    # Show stats
    make stats
    
    log_success "Quick development cycle complete for $doc"
}

# Usage information
usage() {
    echo "LaTeX Resume Development Utilities"
    echo ""
    echo "Usage: $0 <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  setup         Setup development environment"
    echo "  hooks         Install git hooks"
    echo "  backup        Create backup of current state"
    echo "  stats         Show project statistics"
    echo "  clean         Deep clean project files"
    echo "  optimize      Optimize PDF file sizes"
    echo "  quick [doc]   Quick development cycle (default: resume)"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 setup      # Initial setup"
    echo "  $0 quick cv   # Quick cycle for CV"
    echo "  $0 backup     # Create backup"
    echo "  $0 stats      # Show statistics"
}

# Main execution
main() {
    check_project_root
    
    case "${1:-help}" in
        setup)
            setup_dev
            ;;
        hooks)
            install_hooks
            ;;
        backup)
            create_backup
            ;;
        stats)
            project_stats
            ;;
        clean)
            deep_clean
            ;;
        optimize)
            optimize_pdfs
            ;;
        quick)
            quick_dev "$2"
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
