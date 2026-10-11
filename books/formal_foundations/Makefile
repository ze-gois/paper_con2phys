TEX := pdflatex
ROOT := main
BUILD := build

.PHONY: pdf clean

pdf:
	python3 ../tools/check_sources.py
	mkdir -p $(BUILD)
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex
	$(TEX) -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$(BUILD) $(ROOT).tex

clean:
	rm -rf $(BUILD)
