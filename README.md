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
| `make clean` | Remove all build artifacts |
| `make lint` | Check for common issues |
| `make stats` | Show build statistics |
| `make validate` | Verify PDFs are correct |
| `make watch` | Watch for changes and rebuild automatically |
| `make watch doc=resume` | Watch specific document (faster) |
| `make package` | Create release archive |
| `make help` | Show all available targets |

### Development Workflow

```bash
# Make changes to content
vim content/experience.tex

# Live preview during editing (efficient for single document)
make watch doc=resume

# Or watch all documents (slower but comprehensive)
make watch

# Check for issues
make lint

# Validate final output
make validate
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
│   ├── Makefile               # Build automation
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
make lint validate stats

# Test specific scenarios
make watch doc=cv      # Live editing
make package           # Release preparation
make clean && make all # Clean build
```

## 🚀 Continuous Integration

This project uses GitHub Actions for automated quality assurance:

- **Pull Request Checks**: Linting and build validation
- **Automated Releases**: Tagged releases with built PDFs  
- **Multi-platform Testing**: Ensures compatibility

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make lint validate`
5. Submit a pull request

## 📊 Project Stats

- **Languages**: LaTeX, Makefile, YAML
- **Build Time**: ~30-60 seconds for all documents
- **Dependencies**: XeLaTeX, latexmk, biber
- **Output**: 4 PDF documents, ~200KB total

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

This project is based on the [Awesome-CV](https://github.com/posquit0/Awesome-CV) template by Claud D. Park.  
Licensed under [CC BY-SA 4.0](LICENSE).

---

⭐ **Star this repository if you find it useful!**
