# .latexmkrc configuration for IEICE technical report
# This file configures latexmk to compile with pdflatex and bibtex

# Use pdflatex as the main LaTeX engine
$pdf_mode = 1;
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Use bibtex for bibliography
$bibtex_use = 2;
$bibtex = 'bibtex %O %S';

# Force to use bibtex even if no bibliography database is found
$bibtex_fudge = 1;

# Set the number of compilation passes
$max_repeat = 5;

# Clean up auxiliary files
$clean_ext = "aux bbl blg fdb_latexmk fls log out synctex.gz";

# Force regeneration of output if source files change
$force_mode = 1;
