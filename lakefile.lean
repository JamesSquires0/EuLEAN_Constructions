import Lake
open Lake DSL

package «my_project» where
  -- you can put options here later

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "master"
