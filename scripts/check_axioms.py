#!/usr/bin/env python3
"""Axiom audit for the headline theorems.

Runs `lake env lean` on the audit file (default: scripts/Audit.lean), which
holds one `#print axioms` line per headline theorem, and fails unless

  * Lean exits cleanly (so every listed name exists),
  * every `#print axioms` line produced exactly one report, and
  * no theorem depends on anything beyond propext, Classical.choice and
    Quot.sound (so no sorryAx, no Lean.ofReduceBool, no custom axiom).

Run it from the Lean project root after `lake build`.
"""
import pathlib
import re
import subprocess
import sys

ALLOWED = {"propext", "Classical.choice", "Quot.sound"}

audit = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "scripts/Audit.lean")
expected = [
    line.split()[2]
    for line in audit.read_text(encoding="utf-8").splitlines()
    if line.startswith("#print axioms ")
]
if not expected:
    sys.exit(f"{audit}: no `#print axioms` lines")

proc = subprocess.run(
    ["lake", "env", "lean", str(audit)], capture_output=True, text=True
)
output = proc.stdout + proc.stderr
print(output, end="")
if proc.returncode != 0:
    sys.exit(f"{audit}: lean exited with status {proc.returncode}")

reports = {}
for match in re.finditer(
    r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",
    output,
):
    name, axioms = match.group(1), match.group(2) or ""
    reports[name] = {a.strip() for a in axioms.replace("\n", " ").split(",") if a.strip()}

failures = []
for name in expected:
    if name not in reports:
        failures.append(f"{name}: no axiom report")
    elif reports[name] - ALLOWED:
        failures.append(f"{name}: non-standard axioms {sorted(reports[name] - ALLOWED)}")

for failure in failures:
    print(f"::error::{failure}")
if failures:
    sys.exit(1)
print(f"axiom audit: {len(expected)} theorems, standard axioms only")
