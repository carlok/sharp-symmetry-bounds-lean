# Sharp symmetry bounds for real plane algebraic curves (Theorem 1) in Lean 4

[![Lean build](https://github.com/carlok/sharp-symmetry-bounds-lean/actions/workflows/build.yml/badge.svg)](https://github.com/carlok/sharp-symmetry-bounds-lean/actions/workflows/build.yml)
[![Palomar record](https://img.shields.io/badge/Palomar-PALOMAR--2026--09--18--000007-0b7285)](https://palomar-registry.org/entry?id=PALOMAR-2026-09-18-000007&version=1)
[![Lean 4.32.0](https://img.shields.io/badge/Lean-4.32.0-blue)](lean-toolchain)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-lightgrey)](LICENSE)

Lean 4 / Mathlib formalization of Theorem 1 of the working note
"Sharp symmetry bounds for real algebraic curves" by Carlo Perassi.

Let `C` be an infinite real plane curve defined by a polynomial of degree
`d >= 2` that is irreducible over the complex numbers, and suppose `C` is not a
circle. Then the Euclidean symmetry group of `C` is finite, its
orientation-preserving part is cyclic of order at most `max(d, 2d - 4)`, and the
full group has order at most `2d`. Both bounds are attained in every degree.
For `d >= 5` the curves attaining the rotation bound are classified, up to
orientation-preserving similarity, as `Re(z^(d-2)(|z|^2 + a)) = 0` with
`|a| = 1` and `a` not real.

- `Challenge.lean`: the statements (Mathlib-only imports, intentional `sorry`).
- `Solution.lean`: the same statements proved from the library in `lean/`.
- `comparator.json`, `formalization.yaml`: Palomar entry configuration and metadata.
- `docs/THEOREM1.md`: informal statement, proof outline mapped step by step to
  the Lean declarations, and fidelity notes.

## Palomar registry

Registered on 2026-09-18 as
[`PALOMAR-2026-09-18-000007`](https://palomar-registry.org/entry?id=PALOMAR-2026-09-18-000007&version=1),
at commit `ced9fe2d4d2aa42aa03bbc19b1b56cdcd18c9413`. The registry rebuilt the
project in a sandbox from the pinned dependencies, exported the proof terms and
replayed them with an independent kernel, and checked with the Comparator that
`Solution.lean` proves the `Challenge.lean` statements using only the permitted
axioms. The record, its machine-readable evidence and immutable copies of the
source are public:

- record JSON: <https://data.palomar-registry.org/entries/PALOMAR-2026-09-18-000007-v1.json>
- source preservation: `PalomarArchive/carlok--sharp-symmetry-bounds-lean--f3036be09495`,
  tag `palomar/PALOMAR-2026-09-18-000007-v1/ced9fe2d4d2aa42aa03bbc19b1b56cdcd18c9413`

The editorial review behind the record was automated and raised no problems.
Registration certifies that the Lean proofs check, not that the result is new.

This repository is extracted from a larger private development and contains
only the modules needed for Theorem 1. The proofs use only the axioms
`propext`, `Classical.choice` and `Quot.sound`. The Lean code was written by AI
coding agents under the author's direction (see `formalization.yaml`); no
independent human review of the formalization has taken place.

Build: `lake exe cache get && lake build`. Lean 4.32.0, Mathlib pinned in
`lake-manifest.json`. License: Apache-2.0.
