TEX := pdflatex
ROOT := main
BUILD := build

.PHONY: pdf theorems foundations all clean check

pdf: theorems

check:
	python3 tools/check_sources.py

theorems: check
	mkdir -p $(BUILD)
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex
	BIBINPUTS=refs: bibtex $(BUILD)/$(ROOT)
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex

foundations: check
	$(MAKE) -C foundations pdf

all: theorems foundations

clean:
	rm -rf $(BUILD)
	$(MAKE) -C foundations clean
