# New character tuning (fields illustrated by `Dagon.ts`)

**This is a partial, illustrative list only.** It is derived from how [`Dagon.ts`](./Dagon.ts) wires one playable character (`CP_260`). The game and this repo use many more JSON tables, pipeline steps, and `CharacterTuning` areas than appear here. Treat the sections below as a **checklist-shaped map**, not a complete specification. Other character files may add or omit whole blocks; defaults come from [`createDefaultCharacterTuning()`](./default-character-tuning.ts) and [`CharacterTuning`](./types.ts).

---

## Outside this file (still required for a new slot)

These steps are **not** shown in `Dagon.ts` but are needed for the tuning to run:

- Add a stable **`CharacterId`** entry (and string id like `CP_xxx`) in the project `constants` layer used by the build.
- **Register** the exported tuning object in [`registry.ts`](./registry.ts) (`CHARACTER_TUNING`).

---

## File-level pieces in `Dagon.ts`

| Piece | Role |
|--------|------|
| `FILE_INDEX` | Numeric index passed into helpers that emit or patch table rows (e.g. attack conversions). |
| `CHARACTER_ID` | String id for this character (e.g. `"CP_260"`), used in attack-set / action-data helpers. |
| `NEW_ATTACKS` | `NewAttackDefinition[]` — brand-new attacks; merged into output via `ConvertNewAttackDefinitionToTableRows`. |
| `TWEAKED_ATTACKS` | `TweakedAttackDefinitions` — overrides on existing attacks; merged via `ConvertTweakedAttackDefinitionsToTableRowOverrides`. |
| `ATTACK_SET_DEFINITIONS` | `AttackSetDefinitions` — maps logical slots (normals, air, cursed energy buckets, etc.) to attack id lists; drives `CreateActionDataFromAttackSetDefinitions` and `ConvertAttackSetDefinitionsToAttackSetTableRows`. |

---

## `CharacterTuning` shape (as used in `Dagon.ts`)

### Base object

- Spread **`createDefaultCharacterTuning()`** so `damage`, `attack`, `character`, `movement`, `effect`, `attackSet`, and default `actionData` profiles are present unless you override them elsewhere in the same object.

### `actionData`

- **`profile`**: e.g. `"default"`.
- **`setFields`**: typically the spread result of **`CreateActionDataFromAttackSetDefinitions(ATTACK_SET_DEFINITIONS, CHARACTER_ID)`**, which fills `ActionData`-related ids from your attack-set map.

### `tableRowOverrides`

Shallow merges onto **existing** input rows (file basename → row id → fields). In `Dagon.ts` this includes **examples** of:

| Table (basename) | What gets patched (examples from Dagon) |
|------------------|----------------------------------------|
| `CharacterDataTable` | e.g. `Id_CharacterSelect`. |
| `CharacterImageDataTable` | UI texture names: select icons, cut-in, battle icons, out-of-game art, command list icon, etc. |
| `CharacterSoundDataTable` | `Id_VoiceGroup` list — ids that must line up with voice-group rows you add elsewhere. |
| `CharacterVariationDataTable` | Per-costume `ImageFileName`, `ThumbnailImageFileName`, `FreeBattleImageFileName` (keys like `CP_260_00` …). |
| `SituationOverviewPoseDataTable` | Pose item image + thumbnail per pose id (`CP_260_POSE_00`, …). |

Many other tables and fields may need overrides for a full character; this file only shows a slice.

### `tableRows`

New or merged rows injected before transforms (`merge`, optional `baseRowId` per [`CharacterTableRowInjectionSpec`](./types.ts)). In `Dagon.ts` this includes **examples** of:

| Table | Content pattern |
|-------|------------------|
| `CharacterSelectDataTable` | Row for `CP_260` with `merge`: `PlacementIndex`, `VisualLobbyPlacementIndex`, `bUseListItemLeftPadding`, etc. |
| `CharacterCustomVoiceDataTable` | Multiple rows keyed like `CP_260_NORMAL_00`, with `Id_Character`, `Category`, `IndexType`, `Id_Voice_Sample` arrays for normal and cursed-energy custom voices. |
| `ChatTextDataTable_En` | Many chat line ids (`CP_260_GREETING_1`, …) each with `merge.Text`. |
| `StampTextDataTable_En` | Stamp ids with `merge.Text`. |
| `CommandListDataTable` | Large `merge` block: command list text ids for description, passives, normals, cursed attacks, tag/super, extras, plus `CommandListAttackPropertyType_*` arrays. |
| `VoiceGroupDataTable` | One row per `Id_VoiceGroup` entry — each with `Id_Voice` array (slots + `"None"` padding). |
| `ItemDataTable` | Costume items `ITM_COSTUME_CP_260_*` with `Id_ItemText`, `ItemType`, `SortingOrder`, prices, possession flags, etc. |
| `ItemTextDataTable_En` | Display `Text` per costume item id. |

Plus any rows produced by spreading **`ConvertNewAttackDefinitionToTableRows`** and **`ConvertAttackSetDefinitionsToAttackSetTableRows`** at the top of `tableRows`.

---

## Related types

- **[`CharacterTuning`](./types.ts)** — full tuning type (`tableRows`, `tableRowOverrides`, optional `characterSelect`, plus logic tunings).
- **[`AttackSetDefinitions` / `NewAttackDefinition`](../logic/utils/types.ts)** — attack and attack-set authoring shapes.

When in doubt, compare your new file to `Dagon.ts` **and** another character that is closer to your gameplay needs; the pipeline and datatables wiki under `wiki/` may document additional tables not touched here.
