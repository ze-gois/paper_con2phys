import Mathlib

namespace Con2physFormal.BridgesNumbers

-- BRIDGE-009: associativity of addition, proved by induction
-- on the third summand using the recursive successor equation.
theorem add_assoc_induction (a b c : ℕ) :
    (a + b) + c = a + (b + c) := by
  induction c with
  | zero =>
      simp only [Nat.add_zero]
  | succ c ih =>
      simp only [Nat.add_succ, ih]

-- BRIDGE-010: integer representatives as pairs of naturals.
-- (a,b) represents the formal difference a-b.
def integerPairRel (p q : ℕ × ℕ) : Prop :=
  p.1 + q.2 = p.2 + q.1

theorem integerPairRel_refl (p : ℕ × ℕ) :
    integerPairRel p p := by
  simp [integerPairRel, Nat.add_comm]

theorem integerPairRel_symm (p q : ℕ × ℕ) :
    integerPairRel p q → integerPairRel q p := by
  intro h
  exact h.symm

theorem integerPairRel_trans (p q r : ℕ × ℕ) :
    integerPairRel p q → integerPairRel q r → integerPairRel p r := by
  intro hpq hqr
  dsimp [integerPairRel] at *
  omega

theorem integerPairRel_equivalence :
    Equivalence integerPairRel := by
  constructor
  · exact integerPairRel_refl
  · exact integerPairRel_symm
  · exact integerPairRel_trans

def integerPairAdd (p q : ℕ × ℕ) : ℕ × ℕ :=
  (p.1 + q.1, p.2 + q.2)

theorem integerPairAdd_respects (p p' q q' : ℕ × ℕ)
    (hpp : integerPairRel p p') (hqq : integerPairRel q q') :
    integerPairRel (integerPairAdd p q) (integerPairAdd p' q') := by
  dsimp [integerPairRel, integerPairAdd] at *
  omega

#print axioms integerPairRel_equivalence
#print axioms integerPairAdd_respects

#print axioms add_assoc_induction

end Con2physFormal.BridgesNumbers
