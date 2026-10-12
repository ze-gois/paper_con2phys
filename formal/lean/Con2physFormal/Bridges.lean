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

-- BRIDGE-005: equivalence classes cover the carrier and overlap only when equal.
def equivalenceClass (r : α → α → Prop) (a : α) : Set α :=
  {b | r b a}

theorem equivalence_class_cover (r : α → α → Prop)
    (h : Equivalence r) (a : α) :
    a ∈ equivalenceClass r a := by
  exact h.refl a

theorem equivalence_classes_equal_of_overlap
    (r : α → α → Prop) (h : Equivalence r) (a b : α)
    (hoverlap : ∃ x, x ∈ equivalenceClass r a ∧
      x ∈ equivalenceClass r b) :
    equivalenceClass r a = equivalenceClass r b := by
  obtain ⟨x, hxa, hxb⟩ := hoverlap
  have hab : r a b := h.trans (h.symm hxa) hxb
  ext y
  constructor
  · intro hya
    exact h.trans hya hab
  · intro hyb
    exact h.trans hyb (h.symm hab)

-- BRIDGE-006: images preserve unions; preimages preserve intersections and unions.
theorem image_union_bridge {β : Type*} (f : α → β)
    (E F : Set α) :
    f '' (E ∪ F) = f '' E ∪ f '' F := by
  exact Set.image_union f E F

theorem preimage_inter_bridge {β : Type*} (f : α → β)
    (C D : Set β) :
    f ⁻¹' (C ∩ D) = f ⁻¹' C ∩ f ⁻¹' D := by
  exact Set.preimage_inter

theorem preimage_union_bridge {β : Type*} (f : α → β)
    (C D : Set β) :
    f ⁻¹' (C ∪ D) = f ⁻¹' C ∪ f ⁻¹' D := by
  exact Set.preimage_union

-- BRIDGE-007: a two-sided inverse exists exactly for bijections.
theorem inverse_iff_bijective {β : Type*} (f : α → β) :
    (∃ g : β → α, Function.LeftInverse g f ∧
      Function.RightInverse g f) ↔ Function.Bijective f := by
  constructor
  · rintro ⟨g, hleft, hright⟩
    constructor
    · intro a₁ a₂ heq
      calc
        a₁ = g (f a₁) := (hleft a₁).symm
        _ = g (f a₂) := congrArg g heq
        _ = a₂ := hleft a₂
    · intro b
      exact ⟨g b, hright b⟩
  · intro h
    let g : β → α := fun b => Classical.choose (h.2 b)
    have hright : Function.RightInverse g f := by
      intro b
      exact Classical.choose_spec (h.2 b)
    refine ⟨g, ?_, hright⟩
    intro a
    apply h.1
    exact hright (f a)

-- BRIDGE-008: pairs of natural indices form a countable type.
theorem natural_pairs_countable : Countable (ℕ × ℕ) := by
  infer_instance

#print axioms natural_pairs_countable

#print axioms inverse_iff_bijective

#print axioms image_union_bridge
#print axioms preimage_inter_bridge
#print axioms preimage_union_bridge

#print axioms equivalence_class_cover
#print axioms equivalence_classes_equal_of_overlap

#print axioms relation_composition_associative

#print axioms cartesian_membership
#print axioms cartesian_empty_left
#print axioms cartesian_empty_right

#print axioms subset_antisymm_iff
#print axioms subset_reflexive
#print axioms subset_transitive
#print axioms subset_antisymmetric

end Con2physFormal.Bridges
