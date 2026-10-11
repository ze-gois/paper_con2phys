# Compatibility shim: sources moved to books/.
.PHONY: all check pdf theorems foundations matlab lean clean
all:
	$(MAKE) -C ../books all
check:
	$(MAKE) -C ../books check
pdf theorems matlab:
	$(MAKE) -C ../books electrophysiology
foundations lean:
	$(MAKE) -C ../books formal_foundations
clean:
	$(MAKE) -C ../books clean
