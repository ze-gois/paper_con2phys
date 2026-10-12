import Con2physFormal
import Lean

open Lean Elab Command

/-! Bounded transitive walk of elaborated proof and declaration terms. -/
run_cmd do
  let env ← getEnv
  let roots : Array Name := #[
    `Con2physFormal.Logic.deMorganAnd,
    `Con2physFormal.Logic.deMorganOr,
    `Con2physFormal.Logic.contrapositive,
    `Con2physFormal.Logic.notForall,
    `Con2physFormal.Logic.notExists
  ]
  let maxDepth := 3
  let maxNodes := 600
  let mut queue : Array (Name × Nat) := roots.map (fun n => (n, 0))
  let mut visited : Std.HashSet Name := {}
  let mut cursor := 0
  let mut lines : Array String := #["source\ttarget\tkind\tdepth"]
  let mut nodes : Array String := #["name\tdepth\tkind\tbody_available"]
  while cursor < queue.size && visited.size < maxNodes do
    let (current, depth) := queue[cursor]!
    cursor := cursor + 1
    if visited.contains current then
      continue
    visited := visited.insert current
    let some info := env.find? current
      | continue
    let kind := match info with
      | .thmInfo _ => "theorem"
      | .defnInfo _ => "definition"
      | .opaqueInfo _ => "opaque"
      | .axiomInfo _ => "axiom"
      | .quotInfo _ => "quotient"
      | .inductInfo _ => "inductive"
      | .ctorInfo _ => "constructor"
      | .recInfo _ => "recursor"
    let body? := match info with
      | .thmInfo thm => some thm.value
      | .defnInfo d => some d.value
      | .opaqueInfo o => some o.value
      | _ => none
    nodes := nodes.push s!"{current}\t{depth}\t{kind}\t{body?.isSome}"
    let mut refs : Array (Name × String) := #[]
    for dep in info.type.getUsedConstants do
      refs := refs.push (dep, "type")
    if let some body := body? then
      for dep in body.getUsedConstants do
        refs := refs.push (dep, "body")
    for (dep, relation) in refs do
      lines := lines.push s!"{current}\t{dep}\t{relation}\t{depth}"
      if depth < maxDepth && !visited.contains dep && queue.size < maxNodes * 15 then
        queue := queue.push (dep, depth + 1)
  liftIO <| IO.FS.createDirAll "build"
  liftIO <| IO.FS.writeFile "build/transitive_dependencies.tsv" (String.intercalate "\n" lines.toList ++ "\n")
  liftIO <| IO.FS.writeFile "build/transitive_nodes.tsv" (String.intercalate "\n" nodes.toList ++ "\n")
  logInfo m!"Traversed {visited.size} constants, exported {lines.size - 1} edges"
