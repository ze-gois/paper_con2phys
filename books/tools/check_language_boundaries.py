#!/usr/bin/env python3
"""Fail if the two books include source files from the wrong language."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
BOUNDS = {
    "electrophysiology": ".m",
    "formal_foundations": ".lean",
}
PATTERN = re.compile(r"\\lstinputlisting(?:\[[^\]]*\])?\{([^}]+)\}")
problems = []
for book, extension in BOUNDS.items():
    root = ROOT / "books" / book
    for tex in root.rglob("*.tex"):
        body = tex.read_text(encoding="utf-8")
        for match in PATTERN.finditer(body):
            reference = match.group(1)
            suffix = Path(reference).suffix.lower()
            if suffix != extension:
                problems.append(f"{tex}: expected {extension}, got {reference}")
            # lstinputlisting uses the compilation directory, not TeX file's directory.
            source = (root / reference).resolve()
            if not source.is_file():
                problems.append(f"{tex}: missing listing source {reference}")
    master = (root / "main.tex").read_text(encoding="utf-8")
    if book == "electrophysiology" and "language=LeanFour" in master:
        problems.append("Lean listings configuration in electrophysiology master")
    if book == "formal_foundations" and "language=Matlab" in master:
        problems.append("MATLAB listings configuration in formal master")
if problems:
    print("\n".join("ERROR: " + p for p in problems), file=sys.stderr)
    sys.exit(1)
print("Language boundaries passed: electrophysiology=.m; formal_foundations=.lean")
