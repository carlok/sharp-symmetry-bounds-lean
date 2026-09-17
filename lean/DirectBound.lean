import ChangeCenter

namespace CurveSymmetry

set_option autoImplicit false

/-- Direct Euclidean symmetries as unique affine parameters `(a,b)` for `z ↦ az+b`. -/
abbrev DirectSymmetries (P : BPoly) :=
  {ab : ℂ × ℂ // DirectSymmetry (realLocus P) ab.1 ab.2}

noncomputable def directRotationEquiv (P : BPoly) (c : ℂ)
    (hcenter : ∀ a b : ℂ, DirectSymmetry (realLocus P) a b → b = (1 - a) * c) :
    DirectSymmetries P ≃ centeredRotationGroup (shift c P) where
  toFun u := ⟨Units.mk0 u.val.1 (direct_coeff_ne_zero u.prop), ⟨u.prop.1, by
    intro z
    change u.val.1 * z ∈ realLocus (shift c P) ↔ z ∈ realLocus (shift c P)
    rw [mem_realLocus_shift, mem_realLocus_shift]
    have he : u.val.1 * z + c = u.val.1 * (z + c) + u.val.2 := by
      rw [hcenter _ _ u.prop]
      ring
    rw [he]
    exact u.prop.2 (z + c)⟩⟩
  invFun u := ⟨((u.val : ℂ), (1 - (u.val : ℂ)) * c), ⟨u.prop.1, by
    intro z
    have h := u.prop.2 (z - c)
    rw [mem_realLocus_shift, mem_realLocus_shift] at h
    have he : (u.val : ℂ) * (z - c) + c = (u.val : ℂ) * z + (1 - (u.val : ℂ)) * c := by ring
    simpa only [he, sub_add_cancel] using h⟩⟩
  left_inv u := by
    apply Subtype.ext
    apply Prod.ext
    · rfl
    · exact (hcenter _ _ u.prop).symm
  right_inv u := by
    apply Subtype.ext
    apply Units.ext
    rfl

/-- The rotation upper bound for all direct Euclidean symmetries, with no fixed-center
or polynomial-transformation assumptions. Sharpness is proved separately in `Sharpness`. -/
theorem direct_euclidean_bound {P : BPoly} (hP : Irreducible P)
    (hd : 2 ≤ P.totalDegree) (hinf : (realLocus P).Infinite) (hcircle : NotCircle P) :
    Finite (DirectSymmetries P) ∧
      Nat.card (DirectSymmetries P) ≤ max P.totalDegree (2 * P.totalDegree - 4) := by
  obtain ⟨c, hc⟩ := direct_symmetries_common_center hP hd hinf.nonempty
  have hirr : Irreducible (shift c P) := hP.map (shiftEquiv c).toMulEquiv
  have hdegree : 2 ≤ (shift c P).totalDegree := by simpa [shift_degree] using hd
  obtain ⟨hf, _, hb⟩ := centered_rotation_group_bound hirr hdegree
    (realLocus_shift_infinite c hinf) (shifted_not_circle c hcircle)
  letI := hf
  have hfinite : Finite (DirectSymmetries P) :=
    Finite.of_injective (directRotationEquiv P c hc) (directRotationEquiv P c hc).injective
  refine ⟨hfinite, ?_⟩
  rw [Nat.card_congr (directRotationEquiv P c hc)]
  simpa [shift_degree] using hb

#print axioms direct_euclidean_bound

end CurveSymmetry
