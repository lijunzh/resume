#!/usr/bin/env bash
#
# Template generator for LaTeX resume sections
# Helps create new content sections with proper formatting
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

# Templates
generate_basic_section() {
    local section_name="$1"
    local section_title="$2"
    
    cat > "content/${section_name}.tex" << EOF
%-------------------------------------------------------------------------------
%	SECTION TITLE
%-------------------------------------------------------------------------------
\\cvsection{${section_title}}

%-------------------------------------------------------------------------------
%	CONTENT
%-------------------------------------------------------------------------------
\\begin{cventries}

%---------------------------------------------------------
\\cventry
  {Position/Title} % Job title
  {Organization/Company} % Organization
  {Location} % Location
  {Date Range} % Date(s)
  {
    \\begin{cvitems} % Description(s) of tasks/responsibilities
      \\item {Description of responsibility or achievement}
      \\item {Another key accomplishment or duty}
      \\item {Additional relevant information}
    \\end{cvitems}
  }

%---------------------------------------------------------
% Add more entries as needed
% \\cventry{...}{...}{...}{...}{...}

\\end{cventries}
EOF
}

generate_skills_section() {
    local section_name="$1"
    local section_title="$2"
    
    cat > "content/${section_name}.tex" << EOF
%-------------------------------------------------------------------------------
%	SECTION TITLE
%-------------------------------------------------------------------------------
\\cvsection{${section_title}}

%-------------------------------------------------------------------------------
%	CONTENT
%-------------------------------------------------------------------------------
\\begin{cvskills}

%---------------------------------------------------------
  \\cvskill
    {Category} % Category
    {Skill 1, Skill 2, Skill 3, Skill 4} % Skills

%---------------------------------------------------------
  \\cvskill
    {Another Category} % Category
    {Tool 1, Tool 2, Framework 1, Technology 1} % Skills

%---------------------------------------------------------
% Add more skill categories as needed

\\end{cvskills}
EOF
}

generate_honors_section() {
    local section_name="$1"
    local section_title="$2"
    
    cat > "content/${section_name}.tex" << EOF
%-------------------------------------------------------------------------------
%	SECTION TITLE
%-------------------------------------------------------------------------------
\\cvsection{${section_title}}

%-------------------------------------------------------------------------------
%	CONTENT
%-------------------------------------------------------------------------------
\\begin{cvhonors}

%---------------------------------------------------------
\\cvhonor
  {Award Name} % Award
  {Description or Details} % Event
  {Location} % Location
  {Date} % Date(s)

%---------------------------------------------------------
\\cvhonor
  {Recognition Title} % Award
  {Granting Organization} % Event
  {Location} % Location
  {Date} % Date(s)

%---------------------------------------------------------
% Add more honors/awards as needed

\\end{cvhonors}
EOF
}

generate_education_section() {
    local section_name="$1"
    local section_title="$2"
    
    cat > "content/${section_name}.tex" << EOF
%-------------------------------------------------------------------------------
%	SECTION TITLE
%-------------------------------------------------------------------------------
\\cvsection{${section_title}}

%-------------------------------------------------------------------------------
%	CONTENT
%-------------------------------------------------------------------------------
\\begin{cventries}

%---------------------------------------------------------
\\cventry
  {Degree Name} % Degree
  {Institution Name} % Institution
  {Location} % Location
  {Graduation Date} % Date(s)
  {
    \\begin{cvitems} % Description(s) bullet points
      \\item {GPA: X.X/4.0 (if noteworthy)}
      \\item {Relevant Coursework: Course 1, Course 2, Course 3}
      \\item {Thesis/Project: Brief description if applicable}
      \\item {Academic achievements or distinctions}
    \\end{cvitems}
  }

%---------------------------------------------------------
% Add more degrees as needed

\\end{cventries}
EOF
}

generate_publications_section() {
    local section_name="$1"
    local section_title="$2"
    
    cat > "content/${section_name}.tex" << EOF
%-------------------------------------------------------------------------------
%	SECTION TITLE
%-------------------------------------------------------------------------------
\\cvsection{${section_title}}

%-------------------------------------------------------------------------------
%	CONTENT
%-------------------------------------------------------------------------------
\\begin{cventries}

%---------------------------------------------------------
\\cventry
  {} % Empty for publications
  {Publication Venue/Journal} % Venue
  {} % Empty location for publications
  {Publication Date} % Date
  {
    \\begin{cvitems}
      \\item {\\textbf{Your Name}, Co-author Name. "Paper Title." \\textit{Journal/Conference Name}, Year.}
      \\item {Brief description of the work and its significance}
      \\item {DOI or URL if available}
    \\end{cvitems}
  }

%---------------------------------------------------------
% Alternative format using bibliography
% If you prefer to use .bib entries, uncomment below:
% \\nocite{citation-key-1}
% \\nocite{citation-key-2}
% \\printbibliography[heading=none]

\\end{cventries}
EOF
}

# Interactive section generator
interactive_generator() {
    echo "LaTeX Resume Section Generator"
    echo "============================="
    echo ""
    
    # Get section name
    read -p "Enter section filename (without .tex): " section_name
    if [ -z "$section_name" ]; then
        log_error "Section name cannot be empty"
        exit 1
    fi
    
    # Check if file already exists
    if [ -f "content/${section_name}.tex" ]; then
        read -p "File content/${section_name}.tex already exists. Overwrite? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            log_info "Operation cancelled"
            exit 0
        fi
    fi
    
    # Get section title
    read -p "Enter section title (display name): " section_title
    if [ -z "$section_title" ]; then
        section_title=$(echo "$section_name" | sed 's/_/ /g' | sed 's/\b\w/\U&/g')
        log_info "Using auto-generated title: $section_title"
    fi
    
    # Choose template type
    echo ""
    echo "Choose template type:"
    echo "1) Basic/Experience (default)"
    echo "2) Skills"
    echo "3) Honors/Awards"
    echo "4) Education"
    echo "5) Publications"
    echo ""
    read -p "Enter choice [1-5]: " template_choice
    
    # Create content directory if it doesn't exist
    mkdir -p content
    
    # Generate template based on choice
    case "$template_choice" in
        2)
            generate_skills_section "$section_name" "$section_title"
            log_success "Generated skills section: content/${section_name}.tex"
            ;;
        3)
            generate_honors_section "$section_name" "$section_title"
            log_success "Generated honors section: content/${section_name}.tex"
            ;;
        4)
            generate_education_section "$section_name" "$section_title"
            log_success "Generated education section: content/${section_name}.tex"
            ;;
        5)
            generate_publications_section "$section_name" "$section_title"
            log_success "Generated publications section: content/${section_name}.tex"
            ;;
        1|"")
            generate_basic_section "$section_name" "$section_title"
            log_success "Generated basic section: content/${section_name}.tex"
            ;;
        *)
            log_error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    log_info "To use this section in your document, add this line:"
    echo "\\input{content/${section_name}.tex}"
    echo ""
    log_info "Remember to:"
    echo "- Customize the content for your needs"
    echo "- Add the \\input line to your main .tex file"
    echo "- Run 'make lint' to check for issues"
    echo "- Build and test your document"
}

# Command line usage
usage() {
    echo "LaTeX Resume Section Template Generator"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -i, --interactive    Interactive mode (default)"
    echo "  -t, --type TYPE      Template type (basic|skills|honors|education|publications)"
    echo "  -n, --name NAME      Section filename (without .tex)"
    echo "  -T, --title TITLE    Section display title"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Interactive mode"
    echo "  $0 -t skills -n my_skills -T \"My Skills\""
    echo "  $0 --type education --name degrees"
}

# Parse command line arguments
parse_args() {
    local template_type=""
    local section_name=""
    local section_title=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--interactive)
                interactive_generator
                exit 0
                ;;
            -t|--type)
                template_type="$2"
                shift 2
                ;;
            -n|--name)
                section_name="$2"
                shift 2
                ;;
            -T|--title)
                section_title="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # If no arguments provided, run interactive mode
    if [ -z "$template_type" ] && [ -z "$section_name" ]; then
        interactive_generator
        exit 0
    fi
    
    # Validate required arguments
    if [ -z "$section_name" ]; then
        log_error "Section name is required"
        usage
        exit 1
    fi
    
    # Auto-generate title if not provided
    if [ -z "$section_title" ]; then
        section_title=$(echo "$section_name" | sed 's/_/ /g' | sed 's/\b\w/\U&/g')
    fi
    
    # Create content directory
    mkdir -p content
    
    # Generate based on type
    case "$template_type" in
        basic)
            generate_basic_section "$section_name" "$section_title"
            ;;
        skills)
            generate_skills_section "$section_name" "$section_title"
            ;;
        honors)
            generate_honors_section "$section_name" "$section_title"
            ;;
        education)
            generate_education_section "$section_name" "$section_title"
            ;;
        publications)
            generate_publications_section "$section_name" "$section_title"
            ;;
        *)
            log_error "Unknown template type: $template_type"
            log_info "Valid types: basic, skills, honors, education, publications"
            exit 1
            ;;
    esac
    
    log_success "Generated ${template_type} section: content/${section_name}.tex"
}

# Main execution
main() {
    # Check if we're in the right directory
    if [ ! -f "Makefile" ] || [ ! -f "resume.tex" ]; then
        log_error "Not in LaTeX resume project root directory"
        exit 1
    fi
    
    if [ $# -eq 0 ]; then
        interactive_generator
    else
        parse_args "$@"
    fi
}

main "$@"
