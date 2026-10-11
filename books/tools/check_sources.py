#!/usr/bin/env python3
"""Check both LaTeX books before compilation, without third-party packages."""
from __future__ import annotations

from pathlib import Path
import re
import sys

LATEX = Path(__file__).resolve().parent.parent
MASTERS = (LATEX / "main.tex", LATEX / "foundations" / "main.tex")
INPUT = re.compile(r"\\(?:input|include)\s*\{([^}]+)\}")
CORRUPT_MARKERS = (
    "The requested file reference is not currently visible",
    "File is not visible in the requested files surface",
    "Use files.search or files.list to rediscover the file",
)


def check() -> int:
    problems: list[str] = []
    source_files = sorted(LATEX.rglob("*.tex"))
    for source in source_files:
        content = source.read_text(encoding="utf-8")
        if not content.strip():
            problems.append(f"{source.relative_to(LATEX)}: empty TeX source")
        for marker in CORRUPT_MARKERS:
            if marker in content:
                problems.append(
                    f"{source.relative_to(LATEX)}: connector error text stored as source"
                )
                break

    for master in MASTERS:
        book_root = master.parent
        pending = [master]
        visited: set[Path] = set()
        while pending:
            current = pending.pop()
            if current in visited:
                continue
            visited.add(current)
            if not current.is_file():
                problems.append(f"{current}: missing input")
                continue
            # TeX resolves relative \input paths from the compilation directory.
            for line in current.read_text(encoding="utf-8").splitlines():
                if line.lstrip().startswith("%"):
                    continue
                for match in INPUT.finditer(line):
                    input_name = match.group(1).strip()
                    candidate = book_root / input_name
                    if candidate.suffix == "":
                        candidate = candidate.with_suffix(".tex")
                    pending.append(candidate.resolve())

    bridges = sorted((LATEX / "foundations" / "bridges").glob("*.tex"))
    total = sum(
        source.read_text(encoding="utf-8").count(r"\bridgeentry{")
        for source in bridges
    )
    if len(bridges) != 6 or total != 48:
        problems.append(
            f"Foundations: expected six bridge chapters and 48 entries; "
            f"found {len(bridges)} chapters and {total} entries"
        )
    foundations_master = MASTERS[1].read_text(encoding="utf-8")
    for bridge in bridges:
        if rf"\input{{bridges/{bridge.stem}}}" not in foundations_master:
            problems.append(f"Missing bridge import: {bridge.name}")

    if problems:
        for problem in problems:
            print(f"ERROR: {problem}", file=sys.stderr)
        return 1
    print(
        f"Source preflight passed: {len(source_files)} TeX files, "
        f"{len(bridges)} bridge chapters, {total} bridges, "
        f"{len(MASTERS)} compilable books."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(check())
