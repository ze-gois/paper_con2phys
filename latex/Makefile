TEX := pdflatex
ROOT := main
BUILD := build

.PHONY: pdf theorems foundations all clean

pdf: theorems

theorems:
	mkdir -p $(BUILD)
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex
	BIBINPUTS=refs: bibtex $(BUILD)/$(ROOT)
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex

foundations:
	$(MAKE) -C foundations pdf

all: theorems foundations

clean:
	rm -rf $(BUILD)
	$(MAKE) -C foundations clean
