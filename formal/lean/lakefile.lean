import Lake
open Lake DSL

package con2phys_formal where

-- Mathlib v4.34.0, pinned to the exact release commit.
require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @
  "5ed2965256430c3649e86755f9576b54eca72435"

@[default_target]
lean_lib Con2physFormal where
