#!/usr/bin/env bash
#
# Update awesome-cv.cls from upstream repository
# Provides controlled updates with backup and testing
#

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Configuration
UPSTREAM_URL="https://raw.githubusercontent.com/posquit0/Awesome-CV/master/awesome-cv.cls"
BACKUP_DIR="backups"
CURRENT_FILE="awesome-cv.cls"

# Check if we're in the right directory
if [ ! -f "Makefile" ] || [ ! -f "resume.tex" ]; then
    log_error "Not in LaTeX resume project root directory"
    exit 1
fi

# Create backup
backup_current() {
    log_info "Creating backup of current awesome-cv.cls..."
    mkdir -p "$BACKUP_DIR"
    timestamp=$(date +"%Y%m%d_%H%M%S")
    cp "$CURRENT_FILE" "${BACKUP_DIR}/awesome-cv_${timestamp}.cls"
    log_success "Backup created: ${BACKUP_DIR}/awesome-cv_${timestamp}.cls"
}

# Download latest version
download_latest() {
    log_info "Downloading latest awesome-cv.cls from upstream..."
    curl -sL "$UPSTREAM_URL" -o "${CURRENT_FILE}.new"
    
    if [ ! -f "${CURRENT_FILE}.new" ]; then
        log_error "Failed to download latest version"
        exit 1
    fi
    
    log_success "Downloaded latest version"
}

# Compare versions
compare_versions() {
    log_info "Comparing versions..."
    
    current_version=$(grep "ProvidesClass{awesome-cv}" "$CURRENT_FILE" | grep -o '\[.*\]' || echo "[unknown]")
    new_version=$(grep "ProvidesClass{awesome-cv}" "${CURRENT_FILE}.new" | grep -o '\[.*\]' || echo "[unknown]")
    
    echo "Current version: $current_version"
    echo "New version: $new_version"
    
    if [ "$current_version" = "$new_version" ]; then
        log_info "No version change detected"
        rm "${CURRENT_FILE}.new"
        return 1
    else
        log_warning "Version change detected!"
        return 0
    fi
}

# Test build
test_build() {
    log_info "Testing build with new awesome-cv.cls..."
    
    # Replace the file temporarily
    mv "$CURRENT_FILE" "${CURRENT_FILE}.backup"
    mv "${CURRENT_FILE}.new" "$CURRENT_FILE"
    
    # Test build
    if make clean && make resume; then
        log_success "Build test passed!"
        rm "${CURRENT_FILE}.backup"
        return 0
    else
        log_error "Build test failed!"
        # Restore original
        mv "$CURRENT_FILE" "${CURRENT_FILE}.failed"
        mv "${CURRENT_FILE}.backup" "$CURRENT_FILE"
        log_warning "Restored original awesome-cv.cls"
        log_info "Failed version saved as ${CURRENT_FILE}.failed for analysis"
        return 1
    fi
}

# Show differences
show_diff() {
    log_info "Showing differences between versions..."
    if command -v diff >/dev/null 2>&1; then
        diff -u "$CURRENT_FILE" "${CURRENT_FILE}.new" || true
    else
        log_warning "diff command not available"
    fi
}

# Interactive update
interactive_update() {
    echo ""
    echo "Awesome CV Update Tool"
    echo "===================="
    echo ""
    
    # Download and compare
    download_latest
    
    if ! compare_versions; then
        log_info "Already up to date!"
        exit 0
    fi
    
    # Show diff if requested
    echo ""
    read -p "Show differences? (y/N): " show_diff_choice
    if [[ "$show_diff_choice" =~ ^[Yy]$ ]]; then
        show_diff | head -50
        echo ""
        log_info "Use 'diff -u awesome-cv.cls awesome-cv.cls.new' to see full differences"
    fi
    
    # Confirm update
    echo ""
    read -p "Proceed with update? (y/N): " proceed
    if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
        log_info "Update cancelled"
        rm "${CURRENT_FILE}.new"
        exit 0
    fi
    
    # Backup and test
    backup_current
    
    if test_build; then
        log_success "awesome-cv.cls updated successfully!"
        log_info "Remember to test all document types (resume, cv, coverletter)"
        log_info "Run 'make all validate' to ensure everything works"
    else
        log_error "Update failed - original file restored"
        exit 1
    fi
}

# Usage
usage() {
    echo "Awesome CV Update Tool"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -i, --interactive    Interactive update (default)"
    echo "  -f, --force          Force update without confirmation"
    echo "  -c, --check          Check for updates only"
    echo "  -d, --diff           Show differences only"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                   # Interactive update"
    echo "  $0 --check          # Check for updates"
    echo "  $0 --diff           # Show differences"
}

# Main execution
main() {
    case "${1:-interactive}" in
        -i|--interactive|interactive)
            interactive_update
            ;;
        -f|--force)
            download_latest
            backup_current
            mv "${CURRENT_FILE}.new" "$CURRENT_FILE"
            log_success "Force updated awesome-cv.cls"
            ;;
        -c|--check)
            download_latest
            compare_versions || log_info "Up to date"
            rm -f "${CURRENT_FILE}.new"
            ;;
        -d|--diff)
            download_latest
            if compare_versions; then
                show_diff
            fi
            rm -f "${CURRENT_FILE}.new"
            ;;
        -h|--help)
            usage
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
}

main "$@"
