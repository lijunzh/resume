# Tools
LATEXMK = latexmk
RM = rm -f

# Options
LATEXOPT = -xelatex
DEPOPT = -M -MP -MF
CONTINUOUS = -pvc

# List of LaTeX files to build
TEX_FILES = resume.tex cv.tex coverletter.tex teachingstatement.tex 
BASE_FILES = $(TEX_FILES:.tex=)
# PDF files are generated in build directory
PDF_FILES = $(addprefix $(BUILD_DIR)/,$(TEX_FILES:.tex=.pdf))

# Build directory
BUILD_DIR = build
SRC_DIR = .

# Default target: Show help if no specific target is given
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  $(BASE_FILES): Build specific versions (e.g., make resume)"
	@echo "  all:        Build all versions"
	@echo "  clean:      Remove generated files"
	@echo "  setup:      Create necessary directories"
	@echo "  lint:       Check LaTeX files for common issues"
	@echo "  stats:      Show build statistics and file sizes"
	@echo "  watch:      Watch for file changes and rebuild (e.g., make watch doc=resume)"
	@echo "  validate:   Validate all PDFs were built correctly"
	@echo "  dev-setup:  Setup development environment"
	@echo "  backup:     Create backup of current state"
	@echo "  optimize:   Optimize PDF file sizes"
	@echo "  install-hooks: Install git pre-commit hooks"
	@echo "  version:    Create timestamped copies in build/versions/"
	@echo "  package:    Create release archive"

# Setup build directory
.PHONY: setup
setup:
	@mkdir -p $(BUILD_DIR)

# Lint LaTeX files
.PHONY: lint
lint:
	@echo "Checking LaTeX files for common issues..."
	@grep -n "TODO\|FIXME\|XXX" $(TEX_FILES) content/*.tex || echo "No TODOs found"
	@echo "Checking for typos in summary..."
	@grep -n "applyng\|pratical\|recieve\|seperate\|occurence\|definately" content/*.tex || echo "No common typos found"
	@echo "Checking bibliography for common issues..."
	@grep -n "month.*=.*[a-zA-Z]" content/*.bib && echo "Found text month fields (should use numbers)" || echo "No text month fields found"
	@echo "Checking for long lines (>100 characters)..."
	@awk 'length > 100 { print FILENAME ":" NR ": " $$0 }' $(TEX_FILES) content/*.tex || echo "No long lines found"
	@echo "Checking for missing trailing newlines..."
	@for file in $(TEX_FILES) content/*.tex; do [ -s "$$file" ] && [ -z "$$(tail -c 1 "$$file")" ] || echo "$$file: missing trailing newline"; done
	@echo "Linting complete!"

# Enhanced build statistics
.PHONY: stats
stats: all
	@echo "Build Statistics:"
	@echo "=================="
	@for pdf in $(PDF_FILES); do \
		if [ -f "$$pdf" ]; then \
			echo "$$(basename $$pdf): $$(du -h $$pdf | cut -f1)"; \
		fi; \
	done
	@echo "Build directory size: $$(du -sh $(BUILD_DIR) | cut -f1)"
	@echo "Total PDF count: $$(ls -1 $(BUILD_DIR)/*.pdf 2>/dev/null | wc -l)"

# Pattern rule to build PDFs directly in build directory
$(BUILD_DIR)/%.pdf: %.tex setup
	$(LATEXMK) $(LATEXOPT) -output-directory=$(BUILD_DIR) $(DEPOPT) $(BUILD_DIR)/$*.d $*
	@echo "Built $(BUILD_DIR)/$*.pdf (from $<)"

# Create convenience targets that point to build directory
%.pdf: $(BUILD_DIR)/%.pdf
	@echo "PDF available at $(BUILD_DIR)/$*.pdf"

# Prevent Make from deleting PDFs as intermediate files
.PRECIOUS: $(PDF_FILES)

# Rule to clean generated files
.PHONY: clean
clean:
	$(LATEXMK) -silent -C -output-directory=$(BUILD_DIR)
	$(RM) *.run.xml *.synctex.gz *.bbl *.d
	$(RM) -rf $(BUILD_DIR)
	@echo "Cleaned all build artifacts"

# Target to build all PDF files
.PHONY: all
all: $(BASE_FILES)
	@echo "Built all versions: $(PDF_FILES)"

# Target to version PDFs with timestamp
.PHONY: version
version: all
	@mkdir -p $(BUILD_DIR)/versions
	@for pdf in $(PDF_FILES); do \
		cp $$pdf $(BUILD_DIR)/versions/$${pdf%.pdf}_$(shell date +%Y%m%d_%H%M%S).pdf; \
	done
	@echo "Versioned PDFs created in $(BUILD_DIR)/versions/"

# Target to create a release package
.PHONY: package
package: all
	@cd $(BUILD_DIR) && tar -czf lijun_zhu_resume_$(shell date +%Y%m%d).tar.gz *.pdf
	@echo "Release package created: $(BUILD_DIR)/lijun_zhu_resume_$(shell date +%Y%m%d).tar.gz"

# Phony targets for each base file, explicitly depending on their .pdf counterparts
.PHONY: $(BASE_FILES)
$(BASE_FILES): %: %.pdf 

# Target to check for required tools
.PHONY: check-deps
check-deps:
	@command -v $(LATEXMK) >/dev/null 2>&1 || { echo "latexmk not found. Install TeX Live."; exit 1; }
	@command -v xelatex >/dev/null 2>&1 || { echo "xelatex not found. Install TeX Live."; exit 1; }
	@echo "All dependencies found"

# Include auto-generated dependencies
-include *.d

# Watch for changes and rebuild automatically  
.PHONY: watch
watch: setup check-deps
	@if [ -n "$(doc)" ]; then \
		echo "Watching $(doc).tex for changes... (Ctrl+C to stop)"; \
		$(LATEXMK) $(LATEXOPT) -output-directory=$(BUILD_DIR) $(CONTINUOUS) $(DEPOPT) $(BUILD_DIR)/$(doc).d $(doc); \
	else \
		echo "Watching all documents for changes... (Ctrl+C to stop)"; \
		echo "Use 'make watch doc=<name>' to watch a specific document for better performance"; \
		while true; do \
			$(MAKE) -q all || $(MAKE) all; \
			sleep 2; \
		done; \
	fi

# Validate all PDFs were built correctly
.PHONY: validate
validate: all
	@echo "Validating built PDFs..."
	@for pdf in $(PDF_FILES); do \
		if [ ! -f "$$pdf" ]; then \
			echo "ERROR: $$pdf not found!"; \
			exit 1; \
		fi; \
		if [ ! -s "$$pdf" ]; then \
			echo "ERROR: $$pdf is empty!"; \
			exit 1; \
		fi; \
		echo "✓ $$(basename $$pdf) is valid ($$(du -h $$pdf | cut -f1))"; \
	done
	@echo "All PDFs validated successfully!"

# Development utilities shortcuts
.PHONY: dev-setup backup optimize
dev-setup:
	@./scripts/dev-utils.sh setup

backup:
	@./scripts/dev-utils.sh backup

optimize: all
	@./scripts/dev-utils.sh optimize

# Development utility shortcuts
.PHONY: install-hooks
install-hooks:
	@./scripts/dev-utils.sh hooks
