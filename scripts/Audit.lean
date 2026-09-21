/-
Axiom audit of the headline results: the five Theorem 1 statements proved in
`Solution.lean` (the ones `comparator.json` lists).

`scripts/check_axioms.py` runs this file and fails unless every theorem below
depends on `propext`, `Classical.choice` and `Quot.sound` only.
-/
import Solution

#print axioms SharpSymmetryBounds.sharp_bounds
#print axioms SharpSymmetryBounds.rotation_bound_sharp
#print axioms SharpSymmetryBounds.full_bound_sharp
#print axioms SharpSymmetryBounds.equality_classification
#print axioms SharpSymmetryBounds.family_attains_bound
