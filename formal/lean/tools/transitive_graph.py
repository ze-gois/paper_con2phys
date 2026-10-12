#!/usr/bin/env python3
from pathlib import Path
import csv, json
folder = Path(__file__).resolve().parents[1] / "build"
def rows(name):
    with (folder / name).open(newline="", encoding="utf8") as f:
        return list(csv.DictReader(f, delimiter="\t"))
nodes, edges = rows("transitive_nodes.tsv"), rows("transitive_dependencies.tsv")
graph = {
    "schema_version": 2,
    "mathlib_commit": "5ed2965256430c3649e86755f9576b54eca72435",
    "scope": "bounded kernel-term graph, not exhaustive transitive closure",
    "limits": {"depth": 3, "nodes": 600},
    "nodes": [{"id": r["name"], "depth": int(r["depth"]), "kind": r["kind"],
               "body_available": r["body_available"] == "true"} for r in nodes],
    "edges": [{"from": r["source"], "to": r["target"], "kind": r["kind"],
               "source_depth": int(r["depth"])} for r in edges]
}
(folder / "transitive_dependencies.json").write_text(json.dumps(graph,indent=2)+"\n")
print(f"Walk: {len(nodes)} nodes, {len(edges)} edges")
