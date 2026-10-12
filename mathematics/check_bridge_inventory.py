#!/usr/bin/env python3
"""Validate the human-reviewed bridge inventory against actual TeX labels."""
from pathlib import Path
import json, re, sys
root=Path(__file__).resolve().parents[1]
manifest=json.loads((root/"mathematics/bridge_inventory.json").read_text())
entries=manifest["entries"]
errors=[]
if len(entries)!=8: errors.append("exactly eight first-bridge entries required")
found=set()
for n,item in enumerate(entries,1):
    if item["bridge_number"] != n: errors.append(f"{item['id']}: wrong position")
    if item["id"] in found: errors.append(f"{item['id']}: duplicate ID")
    found.add(item["id"])
    source=root/item["english_source"]
    if not source.is_file():
        errors.append(f"{item['id']}: source missing")
        continue
    body=source.read_text()
    if "\\bridgeentry{"+item["latex_key"]+"}{" not in body:
        errors.append(f"{item['id']}: bridge label absent in manuscript")
    if item["status"] != "pending_mathlib_lookup":
        errors.append(f"{item['id']}: unexpected status without verified proof evidence")
    if item["lean_declaration"] is not None:
        errors.append(f"{item['id']}: unverified Lean declaration")
if errors:
    print("\n".join("ERROR: "+e for e in errors),file=sys.stderr)
    raise SystemExit(1)
print(f"Validated {len(entries)} bridge identifiers and source links; all pending formal verification.")
