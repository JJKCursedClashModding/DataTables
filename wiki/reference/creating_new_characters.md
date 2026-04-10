# Creating a new character (partial guide)

**This list is incomplete.** It sketches what you must add or change across **Unreal DataTable JSON exports** if you were building the files yourself—no automation assumed. The real game uses more tables and columns than appear here. Treat this as a **map**, not a schema reference. For column-level detail, see [`wiki/datatables/`](../../wiki/datatables/).

---

## Row id conventions

- Roster characters use ids like **`CP_###`** (three digits). Companion / summon-style entries may use **`CN_###`**.
- Related rows reuse the prefix: base **`CP_260`**, costumes **`CP_260_00`**, **`CP_260_01`**, …, poses **`CP_260_POSE_00`**, chat lines **`CP_260_GREETING_1`**, voice groups **`CP_260_READY`**, items **`ITM_COSTUME_CP_260_00`**, and so on.
- Any field that stores another row id (actions, attacks, variations, voice groups, glossary keys, item text ids) must be updated everywhere so nothing still points at the donor character.

---

## Practical workflow

1. **Choose a donor** character already in the exports that is closest to what you want.
2. **Duplicate** their rows across every table file that character uses (the set differs by character; missing a file often means missing behavior or UI).
3. **Rename** all row keys and every cross-reference to your new **`CP_xxx`** scheme.
4. **Adjust** fields for gameplay and presentation (parameters, animation/effect ids, texture asset names, audio ids, text).
5. **Add localized rows** where the game splits by language (`ChatTextDataTable_*.json`, `StampTextDataTable_*.json`, `ItemTextDataTable_*.json`, etc.) if those locales matter for your build.

---

## Partial checklist of table files (by area)

Names follow typical exports; numbered splits (`DamageDataTable1.json`, `AttackDataTable3.json`, …) depend on how the project split large tables.

| Area | Example files |
|------|----------------|
| Core | `CharacterDataTable.json`, `CharacterBaseParameterDataTable.json`, `CharacterSelectDataTable.json` |
| Combat / motion | `ActionDataTable.json`, `ActionDashDataTable*.json`, `ActionJumpDataTable*.json`, `ActionStepDataTable.json`, `AttackDataTable*.json`, `AttackSetDataTable.json`, `DamageDataTable*.json` |
| Presentation | `CharacterImageDataTable.json`, `CharacterVariationDataTable.json`, `CharacterSoundDataTable.json`, `SituationOverviewPoseDataTable.json`, … |
| Text & audio | `ChatTextDataTable_En.json` (and other language files), `StampTextDataTable_En.json`, `CommandListDataTable.json`, `VoiceGroupDataTable.json`, `CharacterCustomVoiceDataTable.json` |
| Items | `ItemDataTable.json`, `ItemTextDataTable_En.json`, and any item-set tables your costumes reference |

---

## Example: kinds of rows one character needs (still partial)

Using **`CP_260`**–style naming only as an illustration of **patterns**, not as an exhaustive list:

| Table | What you are authoring |
|-------|-------------------------|
| `CharacterDataTable` | Main row `CP_260`: groups, variation slots, links to action / effect / command-list ids, combat tuning fields, etc. |
| `CharacterSelectDataTable` | Row `CP_260`: lobby / list placement and related UI flags. |
| `CharacterImageDataTable` | Row `CP_260_00` (or per-layout key your export uses): paths or names for select icons, cut-ins, battle HUD icons, out-of-game art, command-list icon, etc. |
| `CharacterSoundDataTable` | Row `CP_260`: list of `Id_VoiceGroup` keys; each of those keys needs a matching row in `VoiceGroupDataTable`. |
| `CharacterVariationDataTable` | Rows `CP_260_00`, …: costume thumbnails and free-battle images. |
| `SituationOverviewPoseDataTable` | Rows `CP_260_POSE_00`, …: pose shop-style images. |
| `CharacterCustomVoiceDataTable` | Rows such as `CP_260_NORMAL_00`, `CP_260_CURSED_00`: category, index type, and `Id_Voice_Sample` lists. |
| `ChatTextDataTable_En` | One row per quick-chat id (`CP_260_GREETING_1`, …) with display `Text`. |
| `StampTextDataTable_En` | Stamp rows (`CP_260_STAMP_001`, …) with `Text`. |
| `CommandListDataTable` | Row `CP_260`: many `Id_CommandListText_*` references plus property-type arrays for each listed move slot. |
| `VoiceGroupDataTable` | One row per voice-group id; each holds an `Id_Voice` array (unused slots are often `"None"`). |
| `ItemDataTable` / `ItemTextDataTable_En` | Costume items `ITM_COSTUME_CP_260_*` with type, sorting, prices, possession limits, and display names. |

Anything omitted here—arcade tables, unique mechanics, shikigami, domain expansion, extra damage or action shards—still has to exist in the full export set if the game expects it for that character.

---

## Cross-checking completeness

Comparing **two finished character exports** row-by-row (same filenames, different `CP_###` prefixes) is the most reliable way to see which files or row keys you have not created yet. A concrete gap-style comparison for two slots in this repo is documented in [`wiki/Dagon-CP270-vs-CP260-missing-fields.md`](../../wiki/Dagon-CP270-vs-CP260-missing-fields.md).
