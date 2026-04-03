# Combat feel and responsiveness — extra DataTable findings

Companion to [`UE5_Combat_DataTables_Map.md`](./UE5_Combat_DataTables_Map.md). That file focuses on **attack chains, animation mapping, and hitboxes**. This one collects **other exported tables** that can make the game feel less stiff, slow, or “sticky” — including movement, resources, debuffs, camera shake, and mode-specific multipliers.

---

## 1. Why this matters for “clunk”

Clunky feel usually mixes several layers:

- **Animation length** and **when cancels are allowed** (often montages + per-hit state machine fields in `AttackDataTable*`).
- **Movement**: dash/jump minimum duration, inertia after dash, step cooldown, air-dash gravity delay.
- **Resources**: how long before CE refills, dash gauge regen delay — if you’re starved, you feel locked out.
- **Hit freeze / slowdown**: `DamageDataTable*` fields like `HitSlow_Time_Attacker` / `HitSlow_Time_Guard_Attacker`, plus `Guard_Rigidity_Time` and `RestraintTime` (these affect perceived end-lag).
- **Modifiers**: domain effects, PvE growth, Binding Vows, and buff rows that scale speed, dash, or rigidity.
- **Presentation**: long camera shake or strong rumble can *feel* like lost control even when logic is fine.

The tables below are the ones in this export that most clearly touch those layers.

---

## 2. Cursed energy pacing — `CharacterCursedEnergyDataTable.json`

**Row struct:** `GameDataTableRow_CharacterCursedEnergy` · **Key:** character id (`CP_XXX`)

| Field | Role for feel |
|--------|----------------|
| `Recover_Wait` | Seconds (or game-time units) before CE starts refilling after spend — **lower = less downtime** between specials. |
| `Recover_Speed` | How fast the bar refills once recovery begins. |
| `LevelThreshold` | Tier breakpoints; indirect pacing for how often high-tier tools are available. |
| `*_Solo` rate fields | Solo-mode adjustments to the above. |

Tuning **`Recover_Wait` down** and **`Recover_Speed` up** makes neutral less “empty” when you rely on CE attacks.

---

## 3. Domain expansion combat rates — `DomainExpansionRateDataTable.json`

**Row struct:** `GameDataTableRow_DomainExpansionRate`

Rows are keyed by context, e.g. **`CP_140`**, **`CP_140_ALLY`**, **`CP_140_ENEMY`** — multipliers while a domain (or similar mode) is active.

Examples from the export:

- **`Dash_Cancel_Time_Rate`** — scales dash cancel timing (values below 1 can mean **stricter / slower** cancels for that row).
- **`Run_Speed_End_Rate`** — end-of-run speed scaling.
- **`Dash_Speed_*_Rate`**, **`DashAir_*_Rate`**, **`HomingDashAir_*_Rate`** — dash and air-dash speed multipliers.
- Dash **gauge consume** rates — how costly dashes are in that mode.
- **`Damage_Rate`**, **`Down_Damage_Rate`**, **`GuardDurability_Damage_Rate`**
- **`DownTime_Min_Add`**, **`DownTime_Max_Add`** — extra knockdown / down state duration (higher = **longer loss of control**).

If certain modes feel slugish, compare the **`CP_XXX`** row vs **`CP_XXX_ALLY`** / **`CP_XXX_ENEMY`** and align multipliers toward snappier dash/cancel rates.

---

## 4. PvE growth — `PvEGrowthDataTable.json`

**Row struct:** `GameDataTableRow_PvEGrowth` · **Key:** numeric level id (`"1"`, `"2"`, …)

Relevant columns:

- **`DashGaugeMaxRate`** — early levels use **`0.7`** in samples; later rows reach **`1.0`**. Lower max dash resource = **fewer dashes**, which reads as clunky in PvE.
- **`CursedEnergyRecoverRate`**, **`CursedEnergyExpAddRate`**
- **`GuardDurabilityMaxRate`**, **`HitPointMaxRate`**, **`DamageRate`**

This is **progression tuning**, not per-character animation data — but it explains why early PvE can feel tighter than versus.

---

## 5. Buffs / debuffs — `BuffDebuffDataTable.json`

**Row struct:** uses `BuffDebuff` enum `EGameBuffDebuff::*` and **`FloatValue`** arrays (game-specific layout per buff type).

Types that directly affect **responsiveness**:

- **`MoveSlow`**, **`MoveSlowItem`** — paired floats (e.g. level vs speed multiplier) in rows like `DEBUFF_MOVE_SLOW`.
- **`CursedEnergyRecoverSlow`** — slows CE recovery; feels like **longer gaps** between tools.
- **`LinkComboCursedEnergyExpIncreaseItem`** — link-combo / economy (indirect pacing).

Character passives (`CP_*_Passive`) and domain buffs (`DomainExpansion_*`) live here too; editing them changes **how rules apply**, not just numbers in one place.

---

## 6. Binding Vows (equipment / vows) — `BindingVowsEffectDataTable.json`

**Row struct:** `EffectType` (`EGameBindingVowsEffectType::*`) + **`EffectValue`** + optional `Id_BattleText`.

Feel-relevant **`EffectType`** values seen in the export:

| EffectType | Notes |
|------------|-------|
| **`MoveSpeed`** / **`MoveSpeedEnemy`** | Direct movement scaling for you or foes. |
| **`DashGaugeMax`** | Larger pool = more dash freedom before “empty” sluggish neutral. |
| **`CursedEnergyWhenDash`** | Rewards CE on dash — pacing interaction. |
| **`StepRigidity`** | e.g. `STEP_RIGIDITY_01`–`05` with multipliers **1.1–1.5** — **higher likely = harsher step recovery** (more rigid). |
| **`GuardBreakRigidity`** | Guard-break related rigidity tuning. |
| **`StepCount`** | Caps or changes step usage (`STEP_COUNT_*`). |
| **`GuardCount`**, **`GuardDurabilityMax`** | Guard pressure and durability. |
| **`HitPointWhenJustGuard`** | Perfect guard rewards (doesn’t fix lag but changes risk/reward). |

For a **snappier step**, you’d look for systems that *reduce* step rigidity penalties or step count limits — depending on how the game applies these values (verify in-game).

---

## 7. Dash detail fields (beyond cancel windows) — `ActionDashDataTable*.json`

Already noted in the main map: **`NormalDash_CancelInput_Time`**, **`NormalDash_Minimum_Time`**, **`ActionDash` / `ActionJump` / `ActionStep`** equivalents across shards.

Additional fields worth tuning for **less “glue”**:

| Field | Typical role |
|--------|----------------|
| **`GaugeRecoverWaitTime`** | Delay before dash gauge refills; **`-1.0`** appears on some rows (special rule — confirm in-game). |
| **`NormalDash_Turn_DelayTime`** / **`NormalDashAir_Turn_DelayTime`** | Delay before direction changes fully apply mid-dash. |
| **`NormalDashAir_Gravity_Delay_Time`** | How long before gravity kicks in on air dash — affects **floaty vs snappy** air movement. |
| **`NormalDash_GaugeConsume_DelayTime`** | Delay before gauge is consumed — can affect **input rhythm**. |
| **`NormalDash_Inertia_Time`** / **`NormalDashAir_Inertia_Time`** | How long slide / carry lasts after dash — high values = **slippery** end to dash. |
| **`NormalDash_Lean_Rate`**, **`Lean_Max`** | Visual lean; small impact on feel. |

Search **all** `ActionDashDataTable1.json` … `5.json` for your character id.

---

## 8. Step and homing invalidate — `ActionStepDataTable.json`

Besides **`CoolTime`** and **`StepEnd_PlayRate`** (main map):

- **`Step_HomingInvalidateDistance`** / **`StepAir_HomingInvalidateDistance`** — distance at which homing / targeting behavior invalidates; can affect **how often step “whiffs” feel** or re-snaps.
- **`Step_Inertia_Time`**, **`StepAir_Inertia_Time`** — post-step slide duration.

---

## 9. Jump timing — `ActionJumpDataTable*.json`

Fields that change **air control and early cancel**:

- **`Jump_Minimum_Time`**, **`JumpAir_CancelInput_Time_Min`**
- Various **`Jump_*` / `RunJump_*` / `DashJump_*` / `JumpAir_*`** speeds and interpolation times
- **`Jump_Overtime`**, **`RunJump_Overtime`**, **`DashJump_Overtime`**, **`JumpAir_Overtime`** — small overtime windows (samples like **`0.067`**); can gate **when next action is allowed**.
- **`Fall_Gravity`**, various **`JumpAir_*` / `DashJump_*`** speeds — not “lag” but **heavy vs floaty** air.

**`Rigidity_JumpBegin`**, **`Rigidity_RunJumpBegin`**, etc. — same enum family as dash (`Light` / `Normal` / `Heavy`).

---

## 10. Ground movement and landing — `ActionMoveDataTable.json`

- **`Run_Rotation_Time`**, **`Run_Speed_Start` / End**, **`Run_InterpolateTime`**, **`Run_Inertia_Time`**
- **`Guard_Inertia_Rate`**, **`GuardAir_*`** — guard drift in air
- **`Landing_Inertia_Rate`**, **`Rigidity_Landing`** — **landing stiffness** (big for “sticky” landings after jump or hit)
- **`ParallelAttack_Speed_Rate`** — speed during parallel / linked attack contexts
- **`Target_Speed_Distance`**, **`Target_Speed_Rate`** — targeting-related speed scaling

---

## 11. Tech loss — `ActionBreakFallDataTable.json`

- **`Down_CancelInput_Time`**, **`Blow*_CancelInput_Time`** — when you regain meaningful control after knockdown / blow states
- **`Invincible_Time`**

Lowering blow cancel times (where safe for balance) reduces **long hit-reaction lockout**.

---

## 12. Camera shake — `CameraShakeDataTable.json`

**Row struct:** `GameDataTableRow_CameraShake`

Per shake id: **`OscillationBlendInTime`**, **`OscillationBlendOutTime`**, plus amplitude/frequency-style fields.

**Shorter blend-out** reduces how long the camera keeps moving after hits — often **feels** like faster return to control (even if gameplay state already unlocked).

---

## 13. Controller rumble — `ForceFeedbackDataTable.json`

**Row struct:** `GameDataTableRow_ForceFeedback`

**`Duration`** (e.g. **`0.25`** vs **`0.8`** on `NormalAttack_Down`) — long rumble can feel like **input lag** on pad. Trimming **`Duration`** / **`Power`** is a cheap QoL tweak for some players.

---

## 14. Presentation tables (minor)

- **`EffectColorCorrectDataTable.json`** — visual only.
- **`SoundEffectDataTable.json`** / **`SoundTextDataTable*.json`** — audio; no direct mechanics in the JSON schema reviewed.

---

## 15. Empty in this export but relevant if populated later

| File | Why it matters for feel |
|------|-------------------------|
| **`GlobalDataTable.json`** | Often holds global combat constants (hitstop, defaults, etc.) — **rows empty here**. |
| **`CameraDataTable.json`**, **`CharacterCameraDataTable.json`** | Battle camera lag, lock-on, offsets — **empty here**. |
| **`CharacterDataTable.json`** | Core character stats row — **empty here**. |
| **`ActionHomingDataTable*.json`** | Homing attack parameters — **empty** in several shards. |

If you re-export with fuller row data, scan these first for **global** responsiveness knobs.

---

## 16. What these JSON files do *not* show

- **Input buffer length** and **digital / analog deadzones** are usually **player settings** or **C++/Blueprint constants**, not DataTables.
- **Network rollback / delay** (if any) is outside this folder.
- **Per-hit recovery** is still most likely **`GameDataTableRow_Attack`** + **montages** (see main map).

---

## Quick lookup — files mentioned here

| File | Primary “less clunky” levers |
|------|----------------------------|
| `CharacterCursedEnergyDataTable.json` | CE `Recover_Wait`, `Recover_Speed` |
| `DomainExpansionRateDataTable.json` | `Dash_Cancel_Time_Rate`, dash speeds, `DownTime_*_Add` |
| `PvEGrowthDataTable.json` | `DashGaugeMaxRate`, CE recover rates |
| `BuffDebuffDataTable.json` | `MoveSlow*`, `CursedEnergyRecoverSlow` |
| `BindingVowsEffectDataTable.json` | `MoveSpeed`, `DashGaugeMax`, `StepRigidity`, `StepCount` |
| `ActionDashDataTable*.json` | Cancel/min times, inertia, gravity delay, gauge regen wait |
| `ActionStepDataTable.json` | Cooldown, end play rate, homing invalidate |
| `ActionJumpDataTable*.json` | Min jump time, cancel min, overtime, rigidity |
| `ActionMoveDataTable.json` | Run/landing inertia, `Rigidity_Landing` |
| `ActionBreakFallDataTable.json` | Blow/down cancel times |
| `CameraShakeDataTable.json` | Shake blend in/out |
| `ForceFeedbackDataTable.json` | Rumble duration / power |

---

*Same export caveats as the main map: verify in-game after edits; enum meanings and rate semantics are inferred from names and sample values.*

