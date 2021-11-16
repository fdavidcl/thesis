SHELL=/bin/bash
MKLATEX = latexmk
MKLATEXOPTS=-pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make
MAIN=main
ALL=$(MAIN).pdf
BBL=$(MAIN).bbl

default: clean $(ALL)

$(ALL): $(MAIN).tex latt.sty chapters/* config.tex
	$(MKLATEX) $(MKLATEXOPTS) $<

$(BBL): references.bib
	biber $(MAIN)

clean:
	$(MKLATEX) -CA
	rm -f $(ALL) *.{aux,bbl,bcf,blg,cb,fdb_latexmk,fls,idx,ilg,lof,log,lot,lmw,out,run.xml,rel,synctex.gz,toc}