# Tools
LATEXMK = latexmk
RM = rm -f

# Options
LATEXOPT = -xelatex
DEPOPT = -M -MP -MF
CONTINUOUS = -pvc

# List of LaTeX files to build
TEX_FILES = resume_IC.tex resume_PM.tex cv.tex coverletter.tex teachingstatement.tex 
PDF_FILES = $(TEX_FILES:.tex=.pdf)
BASE_FILES = $(TEX_FILES:.tex=)

# Default target: Show help if no specific target is given
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  $(BASE_FILES:.pdf=): Build specific versions (e.g., make resume_PM)"
	@echo "  all:        Build all versions"
	@echo "  release:    Release all versions"
	@echo "  clean:      Remove generated files"
	@echo "  squeeze:    Squeeze temporary build files"
	@echo "  edit:       Continuously build one document (e.g., make edit doc=resume_PM)"


edit: $(doc).tex
	$(LATEXMK) $(LATEXOPT) $(CONTINUOUS) $(DEPOPT) $(doc).d $(doc)

# Pattern rule to build any .pdf file from its corresponding .tex file
%.pdf: %.tex
	$(LATEXMK) $(LATEXOPT) $(DEPOPT) $*.d $*
	@echo "Built $@ (from $<)"

.PHONY: squeeze
squeeze:
	$(LATEXMK) -silent -c

# Rule to clean generated files
.PHONY: clean
clean: squeeze
	$(LATEXMK) -silent -C
	$(RM) *.run.xml *.synctex.gz
	$(RM) *.bbl
	$(RM) *.d

# Target to build all PDF files
.PHONY: all
all: $(BASE_FILES)
	@echo "Built all versions: $(PDF_FILES)"

# Target to release all PDF files
.PHONY: release
release: all squeeze

# Phony targets for each base file, explicitly depending on their .pdf counterparts
.PHONY: $(BASE_FILES)
$(BASE_FILES): %: %.pdf

# Include auto-generated dependencies
-include *.d
