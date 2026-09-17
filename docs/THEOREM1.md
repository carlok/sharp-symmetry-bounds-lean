# Theorem 1: sharp symmetry bounds for real plane curves

This document is the informal account for reviewers. It restates Theorem 1 of
the working note "Sharp symmetry bounds for real algebraic curves" by Carlo
Perassi (unpublished; only Theorem 1 is formalized here), outlines its proof,
and maps every step to the Lean development in `lean/`.

## Setting

Throughout, `f ∈ ℝ[x, y]` is irreducible in `ℂ[x, y]`, has total degree
`d ≥ 2`, and its real zero set `C = {(x, y) ∈ ℝ² : f(x, y) = 0}` is infinite and
is not a circle. The plane is identified with `ℂ` by `z = x + iy`. `Sym(C)` is
the group of Euclidean isometries of the plane mapping `C` onto itself and
`Sym⁺(C)` its orientation-preserving subgroup; the identity counts in both.

## Statement

**Theorem 1.** `Sym(C)` and `Sym⁺(C)` are finite, `Sym⁺(C)` is cyclic, and with
`N = |Sym⁺(C)|`

    N ≤ max(d, 2d − 4),        |Sym(C)| ≤ 2d.

Both bounds are attained in every degree `d ≥ 2`. If `d ≥ 5` and `N = 2d − 4`,
an orientation-preserving similarity carries `C` onto

    C_{m,α} = { z ∈ ℂ : Re(z^m (|z|² + α)) = 0 },   m = d − 2,  |α| = 1,  α ∉ ℝ.

Conversely every such curve with `m ≥ 3` attains the rotation bound.

## Formal statements

`Challenge.lean` (Mathlib imports only) states five theorems in the namespace
`SharpSymmetryBounds`; `Solution.lean` proves them with identical statements.

| Clause | Lean declaration |
|---|---|
| finiteness, cyclic direct part, both bounds | `SharpSymmetryBounds.sharp_bounds` |
| rotation bound attained for every `d ≥ 2` | `SharpSymmetryBounds.rotation_bound_sharp` |
| full bound `2d` attained for every `d ≥ 2` | `SharpSymmetryBounds.full_bound_sharp` |
| equality classification for `d ≥ 5` | `SharpSymmetryBounds.equality_classification` |
| converse for `m ≥ 3` | `SharpSymmetryBounds.family_attains_bound` |

Definitions used by the statements:

- `realCurve f`: `{z : ℂ | f(Re z, Im z) = 0}`.
- `symmetries C`: isometries `T : ℂ ≃ᵢ ℂ` with `T z ∈ C ↔ z ∈ C` for all `z`
  (so `T` maps `C` onto `C`).
- `directSymmetries C`: those symmetries of the form `z ↦ a z + b`, `|a| = 1`.
- `extremalCurve m α`: `{z | Re(z^m (‖z‖² + α)) = 0}`.
- Irreducibility over `ℂ` is `Irreducible (MvPolynomial.map Complex.ofRealHom f)`.

## Proof outline and Lean map

Internally the curve is handled through its complexification
`P(X, Y) = f((X + Y)/2, (X − Y)/(2i))`, whose real locus is `{z | P(z, z̄) = 0}`.

1. **Coordinates.** The substitution is invertible and degree preserving, the
   zero sets agree, and conversely an irreducible complex equation with infinite
   real locus descends to a real Cartesian equation.
   `CartesianCoordinates`, `CartesianReal`, `RealEquation.exists_real_equation`,
   `CartesianDescent.exists_cartesian_equation`.
2. **Zariski density (Bézout).** If `P` is irreducible with infinite real locus
   and `Q` vanishes there, then `P ∣ Q`; with equal degree, `Q` is a nonzero
   multiple of `P`. `Elimination.dvd_of_realLocus_subset`,
   `Elimination.proportional_of_realLocus_subset`.
3. **Isometries.** Every isometry of `ℂ` is `z ↦ az + b` or `z ↦ a z̄ + b` with
   `|a| = 1` (Mazur–Ulam); the actual groups agree with these parameters, and
   the direct form is equivalent to determinant `+1`.
   `IsometryInterface.isometry_affine_forms`, `IsometryInterface.euclideanIsometryEquiv`,
   `DirectIsometries`, `PaperBounds.mem_direct_isometry_iff_det`.
4. **Lemma 3 (finiteness, cyclicity, sign).** No nonzero translation preserves
   `C` (a whole line would lie in the curve); all nontrivial rotations share one
   center (their commutator is a translation); after moving the center to `0`
   the rotation group is finite and cyclic; a rotation acts on the equation by a
   sign `±1`, and a reflection fixes it (otherwise its fixed line is a
   component). `Translation.no_translation_symmetry`,
   `EuclideanCenter.direct_symmetries_common_center`, `ChangeCenter`,
   `RotationGroup.centeredRotationGroup_finite`,
   `GeometricRotation.rotation_sign_of_realLocus`,
   `Reflection.reflection_fixes_equation`.
5. **Weights.** For a primitive `N`-th root `ζ` with `P(ζX, ζ⁻¹Y) = εP`, every
   monomial `X^a Y^b` of `P` satisfies `ζ^(a−b) = ε`.
   `RotationSupport.fixed_support`, `RotationSupport.anti_support`,
   `RotationSupport.anti_even_order`.
6. **Rotation bound.** If `ε = 1` and `N > d`, then `P` is a polynomial in `XY`,
   hence linear in `XY` by irreducibility, and an infinite radial locus is a
   circle: excluded, so `N ≤ d`. If `N > d` then `ε = −1`, `N = 2m`, weights are
   `±m`, `P = X^m A(XY) + Y^m Ā(XY)`; a constant `A` would give a reducible binary
   form, so `m ≤ d − 2` and `N ≤ 2d − 4`.
   `Irreducibility.irreducible_radial_form`, `RealLocus.radial_realLocus_is_circle`,
   `Irreducibility.irreducible_anti_degree_gap`,
   `Irreducibility.irreducible_rotation_bound`, `DirectBound.direct_euclidean_bound`.
7. **Full bound.** If a reflection exists, every rotation is a product of two
   reflections and fixes the equation, so `N ≤ d` and `|Sym(C)| = 2N ≤ 2d`;
   otherwise `|Sym(C)| = N ≤ max(d, 2d − 4) < 2d`.
   `ReflectionBound.direct_bound_with_opposite`, `ReflectionBound.full_euclidean_bound`.
8. **Sharpness.** `Re(z^d) = 1`, i.e. `X^d + Y^d − 2`, is irreducible
   (Eisenstein) with `d` rotations and `d` reflections; for `d = 2, 3` it also
   attains the rotation bound. For `d ≥ 4` the family `C_{d−2, i}` has exactly
   `2d − 4` rotations. `Fermat.fermat_irreducible`, `Sharpness.rotation_bound_sharp`,
   `Sharpness.full_bound_sharp`, `FamilyRotations.family_direct_card`.
9. **The family.** `X^m(α + XY) + Y^m(ᾱ + XY)` is irreducible for nonreal `α`
   (a blow-up `X = tY` and Eisenstein on the strict transform), has degree `m+2`,
   and its real locus meets every centered circle, so it is infinite and not a
   circle. `FamilyQuadratic.familyQuadratic_irreducible`, `Blowup.irreducible_of_blowup`,
   `FamilyIrreducibility.familyPolynomial_irreducible`, `FamilyRotations.family_degree`,
   `FamilyRealLocus.family_point_of_norm`.
10. **Equality case.** For `d ≥ 5` and `N = 2d − 4`, the weight analysis leaves
    four monomials, `P = X^m(a + bXY) + Y^m(ā + b̄XY)`; `b ≠ 0` by degree,
    `a ≠ 0` (else a factor `XY`), and `a/b ∉ ℝ` (else a factorization). A
    rotation-dilation `z = r e^{iφ} w` and a real rescaling normalize to `C_{m,α}`
    with `α = (a/b)/|a/b|`; the original center is restored.
    `RotationSupport.anti_real_normal_form`, `EqualityForm.irreducible_anti_normal_form`,
    `Normalization.normalize_twoParameter`, `ExtremalClassification.extremal_classification`.
11. **Paper-facing endpoints.** `PaperBounds.paper_sharp_bounds`,
    `paper_rotation_sharp`, `paper_full_sharp`, `paper_equality_classification`,
    `paper_family_converse`; `Solution.lean` restates them with the Challenge
    definitions.

## Fidelity notes

- "Orientation-preserving" is stated through the affine form `z ↦ az + b`,
  `|a| = 1`; its equivalence with determinant `+1` is proved in the library but
  is not part of the compared statements.
- "Cyclic" is stated as: the orientation-preserving symmetries are exactly the
  integer powers of one isometry.
- Counts use `Set.ncard` (which is `0` for infinite sets); finiteness is stated
  explicitly in `sharp_bounds`, and the exact counts elsewhere are positive.
- "Not real" is `α.im ≠ 0`. The converse is proved without assuming `|α| = 1`.
- The sign character and the reflection statement of Lemma 3 are proof
  ingredients, not compared statements.

## Reproduction and checks

    lake exe cache get
    lake build

Lean 4.32.0 and Mathlib `81a5d257c8e410db227a6665ed08f64fea08e997`, pinned in
`lake-manifest.json`. The proofs use only `propext`, `Classical.choice` and
`Quot.sound`; there is no `sorry` outside the intentional holes of
`Challenge.lean`. Palomar's reusable mechanical preflight
(`PalomarRegistry/PalomarSubmission` at `ec6064aea91e2f99187f3f46a2652e4d977ce755`,
profile `palomar-standard-v1`) passed on commit
`4408003da5abd6a6b6e3ad2643f3b7dcfc0c392c` of this repository, run
`35183549777`, with no errors or warnings. The Lean code was written by AI
coding agents under the author's direction; there has been no independent human
review.
