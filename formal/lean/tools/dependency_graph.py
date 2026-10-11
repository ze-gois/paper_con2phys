#!/usr/bin/env python3
"""Convert Lean-generated direct declaration dependencies to JSON."""
from pathlib import Path
import csv
import json

folder = Path(__file__).resolve().parents[1] / "build"
with (folder / "direct_dependencies.tsv").open(newline="", encoding="utf8") as f:
    rows = list(csv.DictReader(f, delimiter="\t"))
edges = sorted({(r["source"],r["target"],r["kind"]) for r in rows})
graph = {
    "schema_version":1,
    "mathlib_commit":"5ed2965256430c3649e86755f9576b54eca72435",
    "scope":"direct theorem type/proof constants; transitive graph pending",
    "nodes":sorted({s for a,b,_ in edges for s in (a,b)}),
    "edges":[{"from":a,"to":b,"kind":kind} for a,b,kind in edges],
}
(folder / "direct_dependencies.json").write_text(json.dumps(graph,indent=2)+"\n")
print(f"Nodes: {len(graph['nodes'])}, edges: {len(edges)}")
