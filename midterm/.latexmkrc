#!/usr/bin/env perl
# LaTeX
$latex = 'platex -synctex=1';
# BibTeX
$bibtex = 'pbibtex';
# DVI / PDF
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';
$pdf_mode = 3;
