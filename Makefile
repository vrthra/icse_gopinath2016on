# To actually build, change MutMin to the actual package.

things=$(wildcard src/*.Rnw src/*.bib etc/*.tex)
pdf=acm_sigproc

all: build
	make build/$(pdf).pdf

build/$(pdf).pdf: $(things)
	mkdir -p build/fig
	cp fig/* build/fig
	mkdir -p build/data
	cp -r data/* build/data
	cp -r etc/* build
	cp src/*.Rnw build
	cp src/*.bib build
	cd build; Rscript -e "require(knitr); knit('paper.Rnw', encoding='UTF-8');"
	cd build; ../bin/latexmk -pdf $(pdf).tex

build/data/MutMin.tar.gz: | build build/data
	rm -rf build/cache
	make data

.PHONY: data

data: | build build/data
	cat data/MutMin.tar.gz | (cd build/data; gzip -dc | tar -xvpf - ; R CMD INSTALL MutMin )

build build/data:
	mkdir -p build/data

clobber:
	rm -rf build/*

clean:
	rm -rf build/cache
	touch src/paper.Rnw

makepaper:
	 pdftk build/$(pdf).pdf cat 1-10 output result.pdf
	 pdftk result.pdf fig/refs.pdf output paper.pdf

mksrc:
	./bin/mksrc.rb $(pdf) > build/full.tex

mkold:
	./bin/mksrc.rb $(pdf) > .old.tex

mkdiff:
	./bin/mksrc.rb $(pdf) | sed -e '/^%/d' | ./bin/strip.pl > build/full.tex
	(cd build; latexdiff ../.old.tex full.tex > diff.tex)
	(cd build; latexmk -pdf diff.tex)

forcarlos:
	perl -pi -e 's#^%\\linespread\{2\}#\\linespread\{2\}#g' etc/meta.tex
	make
	cp build/$(pdf).pdf .
	perl -pi -e 's#^\\linespread\{2\}#%\\linespread\{2\}#g' etc/meta.tex
	scp $(pdf).pdf flip1:public_html

#gs -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=output.pdf build/acm_sigproc.pdf

fontembed:
	pdffonts build/acm_sigproc.pdf
	gs -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen \
		-dCompressFonts=true -dSubsetFonts=true         -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=output.pdf \
														   -c ".setpdfwrite <</NeverEmbed [ ]>> setdistillerparams" -f build/acm_sigproc.pdf
	pdffonts output.pdf
