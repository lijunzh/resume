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
	@echo "  setup:      Initial project setup (directories + git hooks)"
	@echo "  lint:       Check LaTeX files for common issues"
	@echo "  stats:      Show build statistics and file sizes"
	@echo "  watch:      Watch for file changes and rebuild (e.g., make watch doc=resume)"
	@echo "  optimize:   Validate and optimize PDF file sizes"


# Setup build directory and install git hooks for development
.PHONY: setup
setup:
	@mkdir -p $(BUILD_DIR)
	@if [ -d ".git" ] && [ -f ".githooks/pre-commit" ] && [ ! -f ".git/hooks/pre-commit" ]; then \
		echo "Installing git pre-commit hooks..."; \
		mkdir -p .git/hooks; \
		cp .githooks/pre-commit .git/hooks/pre-commit; \
		chmod +x .git/hooks/pre-commit; \
		echo "✅ Pre-commit hook installed"; \
	fi

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

# Validate and optimize PDF files
.PHONY: optimize
optimize: all
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
	@echo "Optimizing PDF files..."
	@if ! command -v gs >/dev/null 2>&1; then \
		echo "⚠️  Ghostscript not found - PDF optimization skipped"; \
		echo "💡 Install with: brew install ghostscript"; \
		exit 1; \
	fi
	@for pdf in $(BUILD_DIR)/*.pdf; do \
		if [ -f "$$pdf" ]; then \
			original_size=$$(stat -f%z "$$pdf" 2>/dev/null || stat -c%s "$$pdf" 2>/dev/null); \
			gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
			   -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$${pdf}.opt" "$$pdf"; \
			if [ -f "$${pdf}.opt" ]; then \
				optimized_size=$$(stat -f%z "$${pdf}.opt" 2>/dev/null || stat -c%s "$${pdf}.opt" 2>/dev/null); \
				if [ "$$optimized_size" -lt "$$original_size" ]; then \
					mv "$${pdf}.opt" "$$pdf"; \
					echo "✅ Optimized $$(basename $$pdf): $$(echo "scale=1; $$original_size/1024" | bc)KB → $$(echo "scale=1; $$optimized_size/1024" | bc)KB"; \
				else \
					rm "$${pdf}.opt"; \
					echo "ℹ️  $$(basename $$pdf) already optimized"; \
				fi; \
			fi; \
		fi; \
	done
	@echo "PDF optimization complete!"
