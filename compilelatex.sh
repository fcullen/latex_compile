#!/bin/bash
# Script to fully compile latex files to pdf, including bibtex references.
# Usage: compilepdf.sh name_of_latex_file [name_of_bbitex_file]
# .tex and .bib extensions should not be given!
#
# e.g. if the names of the .tex and .bib files are otherwise identical,
#     ./compilepdf.sh file_name_without_extension
# Or, if the file names for the .tex and .bib are different,
#     ./compilepdf.sh latex_file bibtex_file
# Lastly, if you have *only* one *.tex and one *.bib file in the directory,
#     ./compilepdf.sh

function findfile () {
	numfiles=$(ls -1 *$1 | wc -l)
	if [ $numfiles -ne 1 ]; then
		return 1
	else
		foundfile=$(find *$1)
		return 0
	fi
}

function numfileserror () {
	echo -e "Error.  More than one $1 files found in directory."
	echo -e "Please specify the .tex and .bib files, in that order."
}


# NB: $# = 0 means no arguments *other than the command itself*, which
# can be accessed by $0. 
if [ $# -eq 0 ]; then
	if ! findfile ".tex"; then
		numfileserror ".tex"
		exit
	else
		texfile=${foundfile:0:${#foundfile}-4}
	fi
	if ! findfile ".bib"; then
		numfileserror ".bib"
		exit
	else
		bibfile=${foundfile:0:${#foundfile}-4}
	fi
	pdflatex $texfile
	bibtex $bibfile
	pdflatex $texfile
	pdflatex $texfile
	open -a Preview $texfile.pdf
elif [ $# -eq 1 ]; then
	pdflatex $1
	bibtex $1
	pdflatex $1
	pdflatex $1
	open -a Preview $1.pdf
elif [ $# -eq 2 ]; then
	pdflatex $1
	bibtex $2
	pdflatex $1
	pdflatex $1
	open -a Preview $1.pdf
else
	echo -e "Error.  Usage:"
	echo -e "If the names of the .tex and .bib files are otherwise identical,"
	echo -e "  ./compilepdf.sh file_name_without_extension"
	echo -e "Or, if the file names for the .tex and .bib are different,"
	echo -e "  ./compilepdf.sh latex_file bibtex_file"
	echo -e "Or, if you have *only* one *.tex and one *.bib file in the directory:"
	echo -e "  ./compilepdf.sh"
fi