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

-- BRIDGE-003: Cartesian product membership and empty factors.
universe v

theorem cartesian_membership {β : Type v} (A : Set α) (B : Set β)
    (a : α) (b : β) :
    (a, b) ∈ Set.prod A B ↔ a ∈ A ∧ b ∈ B := by
  rfl

theorem cartesian_empty_left {β : Type v} (B : Set β) :
    Set.prod (∅ : Set α) B = ∅ := by
  ext p
  change (p.1 ∈ (∅ : Set α) ∧ p.2 ∈ B) ↔ False
  simp

theorem cartesian_empty_right {β : Type v} (A : Set α) :
    Set.prod A (∅ : Set β) = ∅ := by
  ext p
  change (p.1 ∈ A ∧ p.2 ∈ (∅ : Set β)) ↔ False
  simp

-- BRIDGE-004: associativity of composition of typed relations.
-- relComp S R means R first, then S (as in function composition).
def relComp {X Y Z : Type*}
    (S : Y → Z → Prop) (R : X → Y → Prop) : X → Z → Prop :=
  fun x z => ∃ y, R x y ∧ S y z

theorem relation_composition_associative
    {X Y Z W : Type*}
    (R : X → Y → Prop) (S : Y → Z → Prop)
    (T : Z → W → Prop) :
    relComp (relComp T S) R = relComp T (relComp S R) := by
  funext x w
  apply propext
  change
    (∃ y, R x y ∧ (∃ z, S y z ∧ T z w)) ↔
    (∃ z, (∃ y, R x y ∧ S y z) ∧ T z w)
  constructor
  · rintro ⟨y, hxy, z, hyz, hzw⟩
    exact ⟨z, ⟨y, hxy, hyz⟩, hzw⟩
  · rintro ⟨z, ⟨y, hxy, hyz⟩, hzw⟩
    exact ⟨y, hxy, z, hyz, hzw⟩

#print axioms relation_composition_associative

#print axioms cartesian_membership
#print axioms cartesian_empty_left
#print axioms cartesian_empty_right

#print axioms subset_antisymm_iff
#print axioms subset_reflexive
#print axioms subset_transitive
#print axioms subset_antisymmetric

end Con2physFormal.Bridges
