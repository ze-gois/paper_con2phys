#!/usr/bin/env python3
"""Source-only checks for the two independent LaTeX books."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
BOOKS = (ROOT / "electrophysiology", ROOT / "formal_foundations")
MARKERS = (
    "The requested file reference is not currently visible",
    "File is not visible in the requested files surface",
    "Use files.search or files.list to rediscover the file",
)
INCLUDE = re.compile(r"\\(?:input|include)\s*\{([^}]+)\}")


def main():
    problems = []
    count = 0
    for root in BOOKS:
        files = sorted(root.rglob("*.tex"))
        count += len(files)
        for path in files:
            data = path.read_text(encoding="utf-8")
            if not data.strip() or any(marker in data for marker in MARKERS):
                problems.append(f"{path}: empty or damaged source")
        visited = set()
        todo = [root / "main.tex"]
        while todo:
            file = todo.pop().resolve()
            if file in visited:
                continue
            visited.add(file)
            if not file.is_file():
                problems.append(f"{file}: missing input")
                continue
            data = file.read_text(encoding="utf-8")
            for line in data.splitlines():
                if line.lstrip().startswith("%"):
                    continue
                for match in INCLUDE.finditer(line):
                    relative = Path(match.group(1).strip())
                    if not relative.suffix:
                        relative = relative.with_suffix(".tex")
                    todo.append(root / relative)

    bridges = sorted((ROOT / "formal_foundations" / "bridges").glob("*.tex"))
    total = sum(x.read_text(encoding="utf-8").count(r"\bridgeentry{") for x in bridges)
    if len(bridges) != 6 or total != 48:
        problems.append(f"Expected 6 bridge sources and 48 entries; got {len(bridges)}, {total}")
    master = (ROOT / "formal_foundations" / "main.tex").read_text(encoding="utf-8")
    for file in bridges:
        if rf"\input{{bridges/{file.stem}}}" not in master:
            problems.append(f"Not imported: {file.name}")
    if problems:
        print("\n".join("ERROR: " + p for p in problems), file=sys.stderr)
        return 1
    print(f"Validated {count} LaTeX files in two books and 48 mathematical bridges.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
