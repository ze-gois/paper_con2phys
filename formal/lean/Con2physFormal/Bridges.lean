import Mathlib

namespace Con2physFormal.Bridges

universe u
variable {α : Type u}

-- BRIDGE-001: equality of sets is mutual inclusion.
theorem subset_antisymm_iff (A B : Set α) :
    A = B ↔ A ⊆ B ∧ B ⊆ A := by
  constructor
  · intro h
    constructor
    · exact h.le
    · exact h.ge
  · rintro ⟨hAB, hBA⟩
    exact Set.Subset.antisymm hAB hBA

-- BRIDGE-002: inclusion on the power set is a partial order.
theorem subset_reflexive (A : Set α) : A ⊆ A := by
  exact Set.Subset.refl A

theorem subset_transitive (A B C : Set α)
    (hAB : A ⊆ B) (hBC : B ⊆ C) : A ⊆ C := by
  exact hAB.trans hBC

theorem subset_antisymmetric (A B : Set α)
    (hAB : A ⊆ B) (hBA : B ⊆ A) : A = B := by
  exact (subset_antisymm_iff A B).mpr ⟨hAB, hBA⟩

#print axioms subset_antisymm_iff
#print axioms subset_reflexive
#print axioms subset_transitive
#print axioms subset_antisymmetric

end Con2physFormal.Bridges
