#!/usr/bin/env python3
"""First-pass, source-linked inventory. Not a semantic theorem prover.

Usage:
  python3 mathematics/audit_formal.py --write
  python3 mathematics/audit_formal.py --check
The inventory includes ALL TeX files in formal_foundations. Explicit
environments and displays are discovered mechanically; implicit reasoning
is explicitly flagged for human review.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BOOK = ROOT / "books" / "formal_foundations"
FORMAL = ROOT / "formal" / "lean"
REGISTRY = ROOT / "mathematics" / "formal_registry.json"
INVENTORY = ROOT / "mathematics" / "formal_inventory.json"
BEGIN = re.compile(r"\\begin\{(theorem|lemma|proposition|corollary|definition|workedexample|proof|remark|readergoal)\}(?:\[([^\]]*)\])?")
SECTION = re.compile(r"\\(?:chapter|section|subsection|subsubsection)\*?(?:\[[^\]]+\])?\{([^}]*)\}")
BRIDGE = re.compile(r"\\bridgeentry\{([^}]+)\}\{([^}]+)\}")
DISPLAY = re.compile(r"\\\[|\\begin\{(?:equation|align|gather|multline|array)\*?\}")
FORBIDDEN = re.compile(r"\b(sorry|admit)\b|^\s*axiom\s", re.MULTILINE)

def relative(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()

def scan() -> dict:
    files = []
    all_explicit = []
    for path in sorted(BOOK.rglob("*.tex")):
        text = path.read_text(encoding="utf8")
        lines = text.splitlines()
        sections = []
        candidates = []
        displays = []
        for i, line in enumerate(lines, 1):
            if line.lstrip().startswith("%"):
                continue
            for m in SECTION.finditer(line):
                sections.append({"line": i, "heading": m.group(1)})
            for m in BEGIN.finditer(line):
                c = {"kind": m.group(1), "line": i, "name": m.group(2),
                     "status": "pending_semantic_review"}
                candidates.append(c)
                all_explicit.append({"file": relative(path), **c})
            for m in BRIDGE.finditer(line):
                c = {"kind": "bridge", "line": i, "name": m.group(2),
                     "bridge_key": m.group(1), "status": "pending_semantic_review"}
                candidates.append(c)
                all_explicit.append({"file": relative(path), **c})
            if DISPLAY.search(line):
                displays.append(i)
        files.append({
            "file": relative(path),
            "chapters_and_sections": sections,
            "explicit_environments": candidates,
            "mathematical_displays": displays,
            "implicit_invocations": "pending_manual_semantic_audit",
        })
    return {
        "schema_version": 1,
        "scope": "formal_foundations complete TeX source",
        "limitations": "Syntactic scan, not a semantic inventory of all implicit mathematical facts.",
        "files_count": len(files),
        "explicit_environment_count": len(all_explicit),
        "mathematical_display_count": sum(len(f["mathematical_displays"]) for f in files),
        "files": files,
    }

def source_fingerprint(source: str) -> str:
    """FNV-1a over Unicode codepoints, a drift detector (not a security hash)."""
    h = 2166136261
    for c in source:
        h = ((h ^ ord(c)) * 16777619) & 0xFFFFFFFF
    return f"{h:08x}"


def validate(registry: dict, inventory: dict) -> list[str]:
    failures = []
    if inventory["files_count"] < 40:
        failures.append("Found fewer than 40 TeX files; scan likely incomplete")
    ids = set()
    for r in registry["results"]:
        key = r["id"]
        if key in ids:
            failures.append(f"duplicate theorem ID: {key}")
        ids.add(key)
        for field in ("english_source", "lean_source"):
            value = r.get(field)
            if value and not (ROOT / value).is_file():
                failures.append(f"{key}: missing {field}: {value}")
        for field, hash_field in (
            ("english_source", "english_source_fingerprint"),
            ("lean_source", "lean_source_fingerprint"),
            ("english_panel", "english_panel_fingerprint"),
        ):
            source = r.get(field)
            expected = r.get(hash_field)
            if source and expected:
                actual = source_fingerprint((ROOT / source).read_text(encoding="utf8"))
                if actual != expected:
                    failures.append(f"{key}: {field} changed since manual verification")
        declaration = r.get("lean_declaration")
        if declaration and r.get("lean_source"):
            short_name = declaration.split(".")[-1]
            lean_text = (ROOT / r["lean_source"]).read_text(encoding="utf8")
            if not re.search(r"\\b(?:theorem|lemma)\\s+" + re.escape(short_name) + r"\\b", lean_text):
                failures.append(f"{key}: Lean declaration {short_name} missing")
        if r.get("english_panel"):
            body = (ROOT / r["english_panel"]).read_text(encoding="utf8")
            if key not in body:
                failures.append(f"{key}: no corresponding identifier in English panel")
        if r.get("status") == "verified" and not r.get("verification_evidence"):
            failures.append(f"{key}: marked verified without immutable evidence")
        if r.get("status") not in ("pending_ci", "pending", "verified"):
            failures.append(f"{key}: invalid verification status")
    for file in FORMAL.rglob("*.lean"):
        content = file.read_text(encoding="utf8")
        # Strip comment-only lines before looking for unproved bodies.
        content = "\n".join(x for x in content.splitlines() if not x.lstrip().startswith("--"))
        if FORBIDDEN.search(content):
            failures.append(f"{relative(file)}: sorry/admit/axiom declaration")
    return failures

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--write", action="store_true")
    ap.add_argument("--check", action="store_true")
    opts = ap.parse_args()
    inventory = scan()
    if opts.write:
        INVENTORY.write_text(json.dumps(inventory, indent=2, ensure_ascii=False) + "\n", encoding="utf8")
    registry = json.loads(REGISTRY.read_text(encoding="utf8"))
    failures = validate(registry, inventory)
    if opts.check and INVENTORY.exists():
        prior = json.loads(INVENTORY.read_text(encoding="utf8"))
        if prior != inventory:
            failures.append("formal_inventory.json is outdated; regenerate with --write")
    print(f"Inventory: {inventory['files_count']} TeX files, "
          f"{inventory['explicit_environment_count']} explicit environments, "
          f"{inventory['mathematical_display_count']} mathematical displays, "
          f"{len(registry['results'])} manually mapped results.")
    for error in failures:
        print("ERROR: " + error, file=sys.stderr)
    return 1 if failures else 0

if __name__ == "__main__":
    raise SystemExit(main())
