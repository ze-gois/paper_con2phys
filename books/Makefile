TEX := pdflatex
.PHONY: all check matlab lean electrophysiology formal_foundations foundations theorems clean

all: electrophysiology formal_foundations
check:
	python3 tools/check_sources.py

matlab: electrophysiology
lean: formal_foundations
theorems: electrophysiology
foundations: formal_foundations

electrophysiology: check
	$(MAKE) -C electrophysiology pdf

formal_foundations: check
	$(MAKE) -C formal_foundations pdf

clean:
	$(MAKE) -C electrophysiology clean
	$(MAKE) -C formal_foundations clean
