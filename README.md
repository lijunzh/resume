# Lijun Zhu's Resume & CV

Professional resume and CV built with LaTeX using the Awesome-CV template.

[![Build and Release](https://github.com/lijunzh/resume/actions/workflows/build_and_release.yml/badge.svg)](https://github.com/lijunzh/resume/actions/workflows/build_and_release.yml)
[![License](https://img.shields.io/badge/license-CC%20BY--SA%204.0-blue.svg)](LICENSE)

## 📋 Documents

This repository generates four main document types:

- **`resume.pdf`** - One-page resume format optimized for job applications
- **`cv.pdf`** - Full academic CV format with comprehensive details
- **`coverletter.pdf`** - Professional cover letter template
- **`teachingstatement.pdf`** - Academic teaching philosophy statement

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/lijunzh/resume.git
cd resume

# Check dependencies
make check-deps

# Build all documents
make all

# View generated PDFs
open build/*.pdf
```

## 🛠 Building

### Prerequisites

- **XeLaTeX** (part of TeX Live or MiKTeX)
- **latexmk** (build automation)
- **Biber** (bibliography processing)
- **Make** (build orchestration)

#### Installation

**macOS (with Homebrew):**
```bash
brew install --cask mactex
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install texlive-full make
```

**Windows:**
- Install [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/)
- Install [Git for Windows](https://gitforwindows.org/) (includes Make)

### Build Commands

| Command | Description |
|---------|-------------|
| `make all` | Build all documents |
| `make resume` | Build only resume.pdf |
| `make cv` | Build only cv.pdf |
| `make coverletter` | Build only coverletter.pdf |
| `make teachingstatement` | Build only teachingstatement.pdf |
| `make clean` | Remove all build artifacts |
| `make setup` | Initial project setup (directories + git hooks) |
| `make lint` | Check for common issues |
| `make stats` | Show build statistics |
| `make watch` | Watch for changes and rebuild automatically |
| `make watch doc=resume` | Watch specific document (faster) |
| `make optimize` | Validate and optimize PDF file sizes |
| `make help` | Show all available targets |

### Development Workflow

```bash
# Initial setup (creates build directory and installs git hooks)
make setup

# Make changes to content
# Edit content/experience.tex with your preferred editor

# Live preview during editing (efficient for single document)
make watch doc=resume

# Or watch all documents (slower but comprehensive)
make watch

# Check for issues
make lint

# Validate and optimize PDFs for production
make optimize
```

## 📁 Project Structure

```
├── 📄 Main Documents
│   ├── resume.tex              # One-page resume
│   ├── cv.tex                  # Full academic CV
│   ├── coverletter.tex         # Cover letter template
│   └── teachingstatement.tex   # Teaching statement
├── 📂 content/                 # Modular content sections
│   ├── education.tex           # Educational background
│   ├── experience.tex          # Work experience
│   ├── skills.tex              # Technical skills
│   ├── summary.tex             # Professional summary
│   ├── publication.tex         # Publications list
│   ├── services.tex            # Service activities
│   ├── honors.tex              # Awards and honors
│   ├── certificates.tex        # Certifications
│   ├── lijun.bib              # Bibliography database
│   └── lijun.jpg              # Profile photo
├── 🎨 Styling
│   └── awesome-cv.cls          # LaTeX class file
├── 🔧 Build System
│   ├── Makefile               # Streamlined build automation
│   ├── .github/workflows/     # CI/CD pipelines  
│   └── build/                 # Generated output files
└── 📚 Documentation
    ├── README.md              # This file
    ├── CONTRIBUTING.md        # Contribution guidelines
    ├── DEVELOPMENT.md         # Development workflow
    └── LICENSE               # License information
```

## ✏️ Customization

### Content Updates

1. **Personal Information**: Update contact details in each main `.tex` file
2. **Content Sections**: Modify files in the `content/` directory
3. **Bibliography**: Add publications to `content/lijun.bib`
4. **Profile Photo**: Replace `content/lijun.jpg` with your photo

### Advanced Customization

1. **Styling**: Modify `awesome-cv.cls` for layout changes
2. **New Sections**: Create new files in `content/` and include them
3. **Document Structure**: Adjust main `.tex` files for different layouts
4. **Build Process**: Enhance `Makefile` for additional features

### Adding New Content

```latex
% In main document file (e.g., resume.tex)
\input{content/new-section.tex}

% Create content/new-section.tex
\cvsection{New Section}
\begin{cventries}
\cventry
  {Position}
  {Organization}
  {Location}
  {Date}
  {
    \begin{cvitems}
      \item {Description}
    \end{cvitems}
  }
\end{cventries}
```

## 🧪 Quality Assurance

### Automated Checks

- **Linting**: Code quality and style checks
- **Validation**: PDF generation verification
- **CI/CD**: Automated building and testing
- **Performance**: Build time and file size monitoring

### Manual Testing

```bash
# Run all quality checks
make lint optimize stats

# Test specific scenarios
make watch doc=cv      # Live editing
make optimize          # PDF size optimization
make clean && make all # Clean build
```

## 🚀 Continuous Integration

This project uses GitHub Actions for automated quality assurance and releases:

- **Pull Request Checks**: Linting and build validation for all contributions
- **Automated Releases**: Tagged releases with built PDFs on every main branch push
- **Multi-platform Testing**: Ensures compatibility across different environments

**Release Process**: Simply push to the `main` branch and GitHub Actions will automatically:
1. Lint and validate the code
2. Build all PDF documents  
3. Create a timestamped release with downloadable PDFs
4. Archive the release package for distribution

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make lint optimize`
5. Submit a pull request

## 📊 Project Stats

- **Languages**: LaTeX, Makefile, YAML
- **Build System**: Streamlined 9-target Makefile with smart dependency management
- **Build Time**: ~30-60 seconds for all documents
- **Dependencies**: XeLaTeX, latexmk, biber, ghostscript (for optimization)
- **Output**: 4 PDF documents, ~200KB total
- **CI/CD**: Automated linting, building, and releasing

## 🆘 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Build fails | Run `make clean` then `make all` |
| Missing dependencies | Run `make check-deps` |
| Bibliography errors | Check `content/lijun.bib` syntax |
| Large PDF files | Optimize images and fonts |

### Getting Help

1. Check [DEVELOPMENT.md](DEVELOPMENT.md) for detailed workflow
2. Review existing [GitHub Issues](https://github.com/lijunzh/resume/issues)
3. Examine build logs in `build/*.log`
4. Run `make help` for available commands

## 📝 License

This resume is my personal work. Unless otherwise noted, all content is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).

This project is based on the [Awesome-CV](https://github.com/posquit0/Awesome-CV) template by Claud D. Park.

---

⭐ **Star this repository if you find it useful!**
