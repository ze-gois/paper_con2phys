import Con2physFormal
import Lean

open Lean Elab Command

/-!
Export direct constants referenced by elaborated theorem types and proof bodies.
Output is a generated TSV file, not a source import graph.
-/
run_cmd do
  let env ← getEnv
  let mut lines : Array String := #["source\ttarget\tkind"]
  let names : Array Name := #[
    `Con2physFormal.Logic.deMorganAnd,
    `Con2physFormal.Logic.deMorganOr,
    `Con2physFormal.Logic.contrapositive,
    `Con2physFormal.Logic.notForall,
    `Con2physFormal.Logic.notExists
  ]
  for theoremName in names do
    let some info := env.find? theoremName
      | throwError "Missing theorem {theoremName}"
    for name in info.type.getUsedConstants do
      lines := lines.push s!"{theoremName}\t{name}\ttype"
    let proof? := match info with
      | .thmInfo theorem => some theorem.value
      | .defnInfo definition => some definition.value
      | .opaqueInfo definition => some definition.value
      | _ => none
    if let some value := proof? then
      for name in value.getUsedConstants do
        lines := lines.push s!"{theoremName}\t{name}\tproof"
    else
      throwError "No proof body for {theoremName}"
  liftIO <| IO.FS.createDirAll "build"
  liftIO <| IO.FS.writeFile "build/direct_dependencies.tsv" (String.intercalate "\n" lines.toList ++ "\n")
  logInfo m!"Exported {lines.size - 1} direct edges"
