import Mathlib

/-!
# Sharp symmetry bounds for real plane algebraic curves (Theorem 1)

Challenge statements for the first theorem of the note "Sharp symmetry bounds
for real algebraic curves". The plane is identified with `ℂ` by `z = x + i y`.
A curve is the real zero set of a real polynomial `f(x, y)` that stays
irreducible over `ℂ`. Symmetries are genuine Euclidean isometries of the plane
mapping the curve onto itself.
-/

namespace SharpSymmetryBounds

open MvPolynomial

/-- The real zero set `{(x, y) : f(x, y) = 0}` of a real polynomial in two
variables, viewed inside `ℂ` via `z = x + i y`. -/
def realCurve (f : MvPolynomial (Fin 2) ℝ) : Set ℂ :=
  {z | eval (fun i : Fin 2 => if i = 0 then z.re else z.im) f = 0}

/-- All Euclidean isometries of the plane mapping `C` onto itself:
`T z ∈ C` exactly when `z ∈ C`. -/
def symmetries (C : Set ℂ) : Set (ℂ ≃ᵢ ℂ) :=
  {T | ∀ z : ℂ, T z ∈ C ↔ z ∈ C}

/-- The orientation-preserving symmetries of `C`: those of the form
`z ↦ a z + b` with `|a| = 1` (rotations and translations). -/
def directSymmetries (C : Set ℂ) : Set (ℂ ≃ᵢ ℂ) :=
  {T | T ∈ symmetries C ∧ ∃ a b : ℂ, ‖a‖ = 1 ∧ ∀ z : ℂ, T z = a * z + b}

/-- The extremal curve `Re(z^m (|z|^2 + α)) = 0`. -/
def extremalCurve (m : ℕ) (α : ℂ) : Set ℂ :=
  {z | (z ^ m * ((‖z‖ : ℂ) ^ 2 + α)).re = 0}

/-- Theorem 1, bounds. Let `f` be a real polynomial of total degree `d ≥ 2`
that is irreducible over `ℂ`, whose real zero set `C` is infinite and is not a
circle. Then the symmetry group of `C` is finite, its orientation-preserving
part is cyclic (the integer powers of one isometry), has at most
`max(d, 2d − 4)` elements, and the full group has at most `2d` elements. -/
theorem sharp_bounds (f : MvPolynomial (Fin 2) ℝ)
    (hirr : Irreducible (MvPolynomial.map Complex.ofRealHom f))
    (hdeg : 2 ≤ f.totalDegree) (hinf : (realCurve f).Infinite)
    (hcircle : ∀ (c : ℂ) (R : ℝ), 0 < R → realCurve f ≠ Metric.sphere c R) :
    (symmetries (realCurve f)).Finite ∧
      (∃ g : ℂ ≃ᵢ ℂ, directSymmetries (realCurve f) = Set.range (fun n : ℤ => g ^ n)) ∧
      (directSymmetries (realCurve f)).ncard ≤ max f.totalDegree (2 * f.totalDegree - 4) ∧
      (symmetries (realCurve f)).ncard ≤ 2 * f.totalDegree := by
  sorry

/-- Theorem 1, sharpness of the rotation bound in every degree `d ≥ 2`. -/
theorem rotation_bound_sharp (d : ℕ) (hd : 2 ≤ d) :
    ∃ f : MvPolynomial (Fin 2) ℝ, Irreducible (MvPolynomial.map Complex.ofRealHom f) ∧
      f.totalDegree = d ∧ (realCurve f).Infinite ∧
      (∀ (c : ℂ) (R : ℝ), 0 < R → realCurve f ≠ Metric.sphere c R) ∧
      (directSymmetries (realCurve f)).ncard = max d (2 * d - 4) := by
  sorry

/-- Theorem 1, sharpness of the full bound `2d` in every degree `d ≥ 2`. -/
theorem full_bound_sharp (d : ℕ) (hd : 2 ≤ d) :
    ∃ f : MvPolynomial (Fin 2) ℝ, Irreducible (MvPolynomial.map Complex.ofRealHom f) ∧
      f.totalDegree = d ∧ (realCurve f).Infinite ∧
      (∀ (c : ℂ) (R : ℝ), 0 < R → realCurve f ≠ Metric.sphere c R) ∧
      (symmetries (realCurve f)).ncard = 2 * d := by
  sorry

/-- Theorem 1, equality case. If `d ≥ 5` and the rotation bound `2d − 4` is
attained, an orientation-preserving similarity `z ↦ a z + b` maps the curve onto
`Re(z^(d−2) (|z|^2 + α)) = 0` with `|α| = 1` and `α` not real. -/
theorem equality_classification (f : MvPolynomial (Fin 2) ℝ)
    (hirr : Irreducible (MvPolynomial.map Complex.ofRealHom f))
    (hdeg : 5 ≤ f.totalDegree) (hinf : (realCurve f).Infinite)
    (hcircle : ∀ (c : ℂ) (R : ℝ), 0 < R → realCurve f ≠ Metric.sphere c R)
    (hcard : (directSymmetries (realCurve f)).ncard = 2 * f.totalDegree - 4) :
    ∃ a b α : ℂ, a ≠ 0 ∧ ‖α‖ = 1 ∧ α.im ≠ 0 ∧
      (fun z : ℂ => a * z + b) '' realCurve f = extremalCurve (f.totalDegree - 2) α := by
  sorry

/-- Theorem 1, converse. For `m ≥ 3` and nonreal `α`, the curve
`Re(z^m (|z|^2 + α)) = 0` is the zero set of a real polynomial of degree `m + 2`,
irreducible over `ℂ`, infinite and not a circle, with exactly `2m` rotations.
(Modulus one is not needed.) -/
theorem family_attains_bound (m : ℕ) (hm : 3 ≤ m) (α : ℂ) (hα : α.im ≠ 0) :
    ∃ f : MvPolynomial (Fin 2) ℝ, Irreducible (MvPolynomial.map Complex.ofRealHom f) ∧
      f.totalDegree = m + 2 ∧ realCurve f = extremalCurve m α ∧ (realCurve f).Infinite ∧
      (∀ (c : ℂ) (R : ℝ), 0 < R → realCurve f ≠ Metric.sphere c R) ∧
      (directSymmetries (realCurve f)).ncard = 2 * m := by
  sorry

end SharpSymmetryBounds
