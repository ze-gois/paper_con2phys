import Mathlib

namespace Con2physFormal.Logic

-- LOGIC-001: the negation of a conjunction.
theorem deMorganAnd (P Q : Prop) :
    ¬ (P ∧ Q) ↔ ¬ P ∨ ¬ Q := by
  tauto

-- LOGIC-002: the negation of a disjunction.
theorem deMorganOr (P Q : Prop) :
    ¬ (P ∨ Q) ↔ ¬ P ∧ ¬ Q := by
  tauto

-- LOGIC-003: contraposition (classical converse).
theorem contrapositive (P Q : Prop) :
    (P → Q) ↔ (¬ Q → ¬ P) := by
  tauto

-- LOGIC-004: the negation of a universal quantifier.
theorem notForall {α : Type*} (P : α → Prop) :
    (¬ ∀ x, P x) ↔ ∃ x, ¬ P x := by
  push Not
  rfl

-- LOGIC-005: the negation of an existential quantifier.
theorem notExists {α : Type*} (P : α → Prop) :
    (¬ ∃ x, P x) ↔ ∀ x, ¬ P x := by
  push Not
  rfl

#print axioms deMorganAnd
#print axioms deMorganOr
#print axioms contrapositive
#print axioms notForall
#print axioms notExists

end Con2physFormal.Logic
