#!/usr/bin/env python3
"""Check manuscript anchors and evidence for the first eight bridges."""
from pathlib import Path
import json, re, sys
root = Path(__file__).resolve().parents[1]
data = json.loads((root / "mathematics/bridge_inventory.json").read_text())
entries = data["entries"]
errors = []
if len(entries) != 8:
    errors.append("expected eight bridges")
seen = set()
for index, item in enumerate(entries, 1):
    label = item["id"]
    if label in seen:
        errors.append(f"{label}: duplicate")
    seen.add(label)
    if item["bridge_number"] != index:
        errors.append(f"{label}: out of order")
    source = root / item["english_source"]
    if not source.is_file() or "\\bridgeentry{" + item["latex_key"] + "}{" not in source.read_text():
        errors.append(f"{label}: manuscript anchor missing")
    status = item["status"]
    if status == "verified":
        lean = root / item["lean_source"]
        evidence = item.get("verification_evidence", {})
        declarations = item.get("lean_declarations", [])
        if not lean.is_file():
            errors.append(f"{label}: Lean source missing")
            continue
        body = lean.read_text()
        if not declarations or item.get("lean_declaration") != declarations[0]:
            errors.append(f"{label}: missing primary Lean declaration")
        for declaration in declarations:
            local_name = declaration.rsplit(".", 1)[-1]
            if not re.search(r"\btheorem\s+" + re.escape(local_name) + r"\b", body):
                errors.append(f"{label}: Lean declaration missing: {declaration}")
        for key in ("run_url", "checked_repository_commit", "verified_target", "checked_mathlib_commit"):
            if not evidence.get(key):
                errors.append(f"{label}: evidence missing {key}")
        if evidence.get("checked_mathlib_commit") != item["pinned_mathlib_commit"]:
            errors.append(f"{label}: mismatched Mathlib pin")
    elif status == "pending_mathlib_lookup":
        if item.get("lean_declaration") is not None or item.get("lean_source") is not None:
            errors.append(f"{label}: pending result claims formal proof")
    else:
        errors.append(f"{label}: unknown status {status}")
if errors:
    print("\n".join("ERROR: " + x for x in errors), file=sys.stderr)
    sys.exit(1)
print(f"Bridge audit: {len(entries)} inventoried, {sum(x['status']=='verified' for x in entries)} kernel-verified.")
