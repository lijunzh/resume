# Contributing to LaTeX Resume Project

Thank you for your interest in contributing to this LaTeX resume project! This document provides guidelines and best practices for making contributions.

## 🚀 Quick Start

1. **Fork and Clone**
   ```bash
   git clone <your-fork-url>
   cd resume
   ```

2. **Check Dependencies**
   ```bash
   make check-deps
   ```

3. **Build Everything**
   ```bash
   make all
   ```

4. **Validate Your Changes**
   ```bash
   make lint
   make validate
   ```

## 📁 Project Structure

```
├── content/              # Modular content sections
│   ├── education.tex
│   ├── experience.tex
│   ├── skills.tex
│   ├── summary.tex
│   ├── publication.tex
│   ├── services.tex
│   ├── honors.tex
│   ├── certificates.tex
│   └── lijun.bib        # Bibliography entries
├── awesome-cv.cls       # LaTeX class file
├── Makefile            # Build automation
├── *.tex               # Main document files
└── build/              # Generated output files
```

## 🛠 Development Workflow

### Making Changes

1. **Content Updates**: Edit files in `content/` directory
2. **Document Structure**: Modify main `.tex` files
3. **Styling**: Update `awesome-cv.cls` if needed
4. **Build System**: Enhance `Makefile` for new features

### Testing Your Changes

```bash
# Build specific document
make resume

# Continuous editing with live reload
make edit doc=resume

# Run comprehensive checks
make lint
make validate
make stats
```

### Build Validation

- All PDFs must build without errors
- Bibliography entries must be properly formatted
- No TODO/FIXME comments in final version
- File sizes should be reasonable (< 1MB for most documents)

## 📝 Content Guidelines

### Bibliography Standards

- Use numeric month fields: `month = {9}` not `month = {Sep}`
- Include DOI when available
- Use consistent naming conventions for entry keys
- Remove duplicate entries

### LaTeX Best Practices

- Keep lines under 100 characters when possible
- Use meaningful section and subsection titles
- Include comments for complex formatting
- Maintain consistent indentation (2 spaces)

### Content Organization

- **Resume**: 1-2 pages maximum, focused on key achievements
- **CV**: Comprehensive academic/professional history
- **Cover Letter**: Template with placeholder content
- **Teaching Statement**: Academic philosophy and approach

## 🔧 Build System

### Available Make Targets

| Target | Description |
|--------|-------------|
| `all` | Build all documents |
| `clean` | Remove all build artifacts |
| `lint` | Check for common issues |
| `stats` | Show build statistics |
| `validate` | Verify PDFs are correct |
| `watch` | Auto-rebuild on changes |
| `version` | Create timestamped copies |
| `package` | Create release archive |

### Adding New Documents

1. Create new `.tex` file in root directory
2. Add to `TEX_FILES` in `Makefile`
3. Update documentation and help text
4. Test build process thoroughly

## 🐛 Troubleshooting

### Common Issues

**Build Fails**
```bash
make clean  # Clear build artifacts
make all    # Rebuild everything
```

**Missing Dependencies**
```bash
make check-deps  # Verify required tools
```

**Bibliography Errors**
```bash
make lint  # Check for common bib issues
```

**Large PDF Files**
- Check for high-resolution images
- Consider compressing images
- Review included packages

### Debug Information

Build logs are stored in `build/*.log`. Common error patterns:

- **Missing packages**: Install via TeX Live package manager
- **Bibliography issues**: Check `.bib` file syntax
- **Font problems**: Ensure XeLaTeX compatibility
- **Memory issues**: Consider splitting large documents

## 📊 Quality Assurance

### Pre-commit Checklist

- [ ] All documents build successfully
- [ ] No lint warnings or errors
- [ ] PDFs validated correctly
- [ ] Bibliography entries standardized
- [ ] File sizes reasonable
- [ ] Documentation updated if needed

### Performance Considerations

- Use efficient LaTeX packages
- Optimize image sizes and formats
- Minimize redundant package loading
- Consider build time for large documents

## 🚀 Continuous Integration

The project uses GitHub Actions for automated building and testing:

- **Lint Check**: Validates code quality
- **Build Test**: Ensures all documents compile
- **Release**: Automatically creates tagged releases

Local testing should match CI environment. Use `make lint` and `make validate` before committing.

## 📞 Getting Help

1. **Check Documentation**: README.md and DEVELOPMENT.md
2. **Review Issues**: Existing GitHub issues
3. **Build Logs**: Check `build/*.log` files
4. **Make Help**: Run `make help` for target information

## 🎯 Best Practices Summary

- **Test Early**: Build frequently during development
- **Lint Often**: Run `make lint` before committing
- **Document Changes**: Update relevant documentation
- **Small Commits**: Make focused, atomic changes
- **Validate Output**: Always check generated PDFs

---

Thank you for contributing to making this LaTeX resume project better! 🎉
