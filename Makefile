# Thesis Makefile
# 1/21/2007
# Brian O'Connor

FILES=README \
	thesis.tex thesis.pdf \
	uclathes.cls uclath12.clo uclathti.clo uclathma.clo \
	uclathes.bst Makefile

#all: latex dvips pdf
#all: intro thesis.pdf
all: thesis

clean::
	$(RM) *.bbl *.aux *.blg *.dvi *.log *.lot *.lof *.toc thesis.pdf thesis.ps

tar:
	tar cvf thesis.tar $(FILES)
	gzip thesis.tar

bib:
	echo 'for i in *.tex; do bibtex $${i/.tex/}; done' | bash

thesis:
	#ok
	pdflatex --interaction nonstopmode thesis.tex
	$(MAKE) bib
	pdflatex thesis.tex
	# a hack for the special formating of the TOC
#	cp thesis.toc.custom thesis.toc
#	pdflatex thesis.tex

#
# generate dvi from tex 
#
%.dvi : %.tex
	latex $<
#
# generate postscript from dvi
#
%.ps : %.dvi
	dvips $< -o $@

#
# generate pdf from postscript
#
%.pdf : %.ps
	ps2pdf $<

#
# generate pdf from tex
#
%.pdf : %.tex
	pdflatex $<
	bibtex $*
	pdflatex $<
	pdflatex $<

#
# generate png from (encapsulated) postscript
#
%.png : %.ps
	convert $< $@
%.png : %.eps
	convert $< $@

# epstopdf diagram.eps     (convert image to new file diagram.pdf)
# pdflatex MyDoc.tex       (``first pass'')
# bibtex MyDoc               (extracts reference data)
# pdflatex MyDoc.tex       (matches citations/references)
# pdflatex MyDoc.tex       (finishes all cross-referencing, final form of file MyDoc.pdf)
