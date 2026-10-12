#!/usr/bin/env python3
"""Produce separate, explicitly curated mathematical and pedagogical DAGs.

Do not infer pedagogy or theorem equivalence from kernel-level references.
"""
from pathlib import Path
import argparse
import json
import sys

ROOT = Path(__file__).resolve().parents[1]
CURATED = ROOT / "mathematics" / "concept_dependencies.json"
REGISTRY = ROOT / "mathematics" / "formal_registry.json"
BRIDGES = ROOT / "mathematics" / "bridge_inventory.json"


def render(entries, attribute):
    edges = sorted({(entry["id"], prerequisite) for entry in entries
                    for prerequisite in entry[attribute]})
    nodes = sorted({value for edge in edges for value in edge})
    return {"schema_version": 1, "graph_kind": attribute,
            "certification": "human_curated_not_kernel_verified",
            "nodes": [{"id": name} for name in nodes],
            "edges": [{"from": a, "to": b} for a, b in edges]}


def validate(data, registry, bridges):
    failures = []
    ids = {item["id"] for item in registry["results"]}
    ids |= {item["id"] for item in bridges["entries"] if item["status"] == "verified"}
    seen = set()
    for item in data["entries"]:
        ident = item["id"]
        if ident not in ids:
            failures.append(f"{ident}: not in formal registry")
        if ident in seen:
            failures.append(f"{ident}: duplicate entry")
        seen.add(ident)
        for key in ("math_prerequisites", "pedagogical_prerequisites"):
            if len(item[key]) != len(set(item[key])):
                failures.append(f"{ident}: repeated {key}")
            if ident in item[key]:
                failures.append(f"{ident}: self-dependency in {key}")
    if seen != ids:
        failures.append(f"Missing curated mappings: {sorted(ids - seen)}")
    return failures


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    opts = parser.parse_args()
    data = json.loads(CURATED.read_text())
    registry = json.loads(REGISTRY.read_text())
    bridges = json.loads(BRIDGES.read_text())
    verified_bridges = [item for item in bridges["entries"] if item["status"] == "verified"]
    data["entries"].extend(verified_bridges)
    failures = validate(data, registry, bridges)
    for failure in failures:
        print("ERROR:", failure, file=sys.stderr)
    if failures:
        return 1
    if opts.write:
        for key, filename in [("math_prerequisites", "mathematical_graph.json"),
                              ("pedagogical_prerequisites", "pedagogical_graph.json")]:
            (ROOT / "mathematics" / filename).write_text(
                json.dumps(render(data["entries"], key), indent=2) + "\n")
    print(f"Curated graph validation passed: {len(data['entries'])} mapped results (including {len(verified_bridges)} verified bridges)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
