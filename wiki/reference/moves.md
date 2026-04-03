# Editing moves by hand (JSON)

Combat moves are spread across several DataTable JSON exports. The same **row name** is usually the glue: an attack’s identity string appears as a key under `Rows` in one shard of the attack table, the matching damage row, and as entries inside `Id_Attack` arrays on attack sets.

## `ActionDataTable.json`

There is one row per character (or variant), keyed by that character’s action row id. The fields that matter for **which move comes out on which input** are the various `Id_AttackSet_*` properties:

- Ground normals: `Id_AttackSet_Normal_1`, `…_2`, `…_3`, plus the “button + down” and `_Auto` variants, and solo variants where present.
- Air normals: the `Id_AttackSet_Normal_Air_*` family mirrors the ground layout.
- Cursed energy: `Id_AttackSet_CursedEnergy_*` and air/auto counterparts. Some tiers are **arrays** of attack-set ids (one entry per CE level).
- Supers / extras: `Id_AttackSet_SuperCursedEnergy*`, `Id_ExtraAttack_*`, and any other attack-set fields present in the export.

Each of those fields should hold the `**ID` string of a row in `AttackSetDataTable.json`** (or an array of such ids, for CE tiers). Changing a button’s behavior is usually: point that field at a **different** attack-set row, or add a new attack-set row and point at it.

Movement (dash, jump, step, etc.) is on the **same character row** via `Id_ActionDash`, `Id_ActionJump`, and so on—those reference **other** tables, not attack sets.

## `AttackSetDataTable.json`

Each row USUALLY describes **one attack string** (combo sequence): the property `**Id_Attack`** is a list of attack row ids in order—first hit, follow-up, etc. Unused slots in the export are typically filled with `"None"` or a numeric zero depending on how the JSON was saved; match the style of nearby rows.

For some characters (for example, Nanami or Megumi), the attack set is not just a combo. It might list ALL the possible moves for that combo, and which one is used depends on the blueprint logic. For example, Megumi has both summoning Nue and Demon dog in the same attack set (but only one is used at a time).

Other columns on the row (for example range type, cursed-energy flags, inertia) gate how that string behaves when selected.

To **change a combo**, edit the `Id_Attack` list so each slot references the correct attack row id. To **add a branch**, you often add a new row here with a new `ID`, set `Id_Attack` as needed, then point the right `Id_AttackSet_*` field on the character in `ActionDataTable.json` at that new `ID`.

For some characters, changing attack sets will not work for specific moves. For example, if you try to overwrite Megumi's frog attacks with a melee combo, it will glitch out. I think there's probably blueprint logic for that specific move.

## `AttackDataTable1.json` … `AttackDataTable5.json`

Attack **logic** (animations, transition enums, timing, armor flags, homing links, CE add on the attack side, etc.) lives in these files. They are **sharded**: a given attack id exists in **at most one** of the numbered files. Edit the row whose key matches the id you reference from `AttackSetDataTable.json`.

When **adding a new move**, you normally duplicate an existing row close to what you want, assign a **new unique `ID`** (and ensure the key under `Rows` matches that `ID`), then adjust fields. Any id you list in `Id_Attack` must have a row here (in the correct shard).

## `DamageDataTable1.json` … `DamageDataTable5.json`

Hit **effects**—damage numbers, reaction type, guard behavior, meter gain on hit, slowdown, knockback, and related columns—live here, again sharded the same way. For a given attack, the damage row should use the **same id** as the attack row so the game pairs them.

Damage table rows, unlike Attack table rows, cannot be cloned (well, they can, they won't be used). A specific damage row id is specified in the animation itself. To allow new damage rows, the animation in the pak file will need to be edited. 

Animations can use more than one damage row for multi-hit attacks.

Attack and Damage rows do not always need to share ids. There are some damage rows that exist, while the attack doesn't, and vice versa. For example. SETUP attacks do not have any damage rows generally.

## Practical order of operations

1. **Rebind which string fires on an input** — only `ActionDataTable.json` (change which `Id_AttackSet_`* value points where).
2. **Change the chain (which hits fire in order)** — `AttackSetDataTable.json` (`Id_Attack`), without new attacks.
3. **New hit / new timing / new transitions** — new or edited rows in the numbered `AttackDataTable` and `DamageDataTable` files, then reference the new id from `Id_Attack`.
4. **Keep shards consistent** — if your export splits tables 1–5, open the shard that already contains that character’s rows; do not duplicate the same `ID` across two shards.
