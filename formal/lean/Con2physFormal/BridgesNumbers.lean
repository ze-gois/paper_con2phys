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

#print axioms add_assoc_induction

end Con2physFormal.BridgesNumbers
