# Development Workflow

## Quick Start
```bash
# Setup development environment (first time)
make dev-setup

# Check dependencies
make check-deps

# Build all documents
make all

# Work on resume with live preview
make edit doc=resume

# Create release package
make package
```

## Development Tools

### 🛠 Utility Scripts

The project includes several development utilities:

```bash
# Development environment setup
./scripts/dev-utils.sh setup

# Project statistics and metrics
./scripts/dev-utils.sh stats

# Create backups
./scripts/dev-utils.sh backup

# Optimize PDF file sizes
./scripts/dev-utils.sh optimize

# Generate new content sections
./scripts/new-section.sh
```

### 🔧 Makefile Shortcuts

All scripts are accessible through convenient Make targets:

```bash
make dev-setup      # Setup development environment
make stats          # Show build statistics
make backup         # Create backup
make optimize       # Optimize PDF sizes
make new-section    # Generate new content section
make install-hooks  # Install git pre-commit hooks
make validate       # Validate all PDFs
make watch          # Watch for changes and rebuild
```

### 📋 Quality Assurance

Enhanced linting and validation:

```bash
make lint           # Comprehensive code quality checks
make validate       # Verify PDFs are correct
make stats          # Build statistics and metrics
```

The linting now checks for:
- TODO/FIXME comments
- Common typos
- Bibliography formatting issues
- Long lines (>100 characters)
- Missing trailing newlines

## File Organization
- **Source**: `.tex` files and `content/` directory
- **Output**: `build/` directory contains all generated files
- **Scripts**: `scripts/` directory contains development utilities
- **Config**: `.project-config` for build settings
- **Hooks**: `.githooks/` for git pre-commit validation
- **Distribution**: Use `make package` for release archives

## Enhanced Build System

### Performance Features
- **Incremental builds**: Only rebuild changed files
- **Parallel processing**: Faster builds on multi-core systems  
- **Build caching**: Reuse compiled components when possible
- **Dependency tracking**: Automatic rebuilds when dependencies change

### Quality Features
- **Enhanced linting**: Comprehensive code quality checks
- **PDF validation**: Verify output file integrity
- **Size optimization**: Compress PDFs without quality loss
- **Statistics tracking**: Monitor build performance and output

### Development Features
- **Live preview**: Auto-rebuild on file changes (`make edit`)
- **Template generation**: Create new sections quickly (`make new-section`)
- **Backup system**: Automatic backups during development
- **Git integration**: Pre-commit hooks for quality assurance

## Common Tasks
- `make resume` - Build just the resume
- `make lint` - Check for common issues
- `make clean` - Remove all build artifacts
- `make version` - Create timestamped copies
- `make package` - Create release archive

## Troubleshooting
- If build fails, run `make clean` first
- For LaTeX errors, check the `.log` files in `build/`
- Use `make edit doc=<filename>` for live preview during development
