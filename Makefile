version = 0.0.1
tarball = eif_$(version).tar.gz

doc: 
	R -e "pkgload::load_all(); roxygen2::roxygenize()"

manual: doc
	R CMD Rd2pdf --force -o manual.pdf .

build: doc
	rm -f *.tar.gz
	R CMD build .

check: build 
	R CMD check *.tar.gz

install: check
	R CMD INSTALL --install-tests $(tarball)

cran: manual build
	R CMD build --compact-vignettes="gs+qpdf" 
	R CMD check --as-cran $(tarball)

clean:
	rm -f *.tar.gz	
	rm -rf *.Rcheck
