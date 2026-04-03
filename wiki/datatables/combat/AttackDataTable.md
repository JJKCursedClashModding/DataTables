# AttackDataTable

**Indexed:** split across 5 JSON shards: `input_json/AttackDataTable1.json`, `input_json/AttackDataTable2.json`, `input_json/AttackDataTable3.json`, `input_json/AttackDataTable4.json`, `input_json/AttackDataTable5.json`.

**Row struct (from export):** `Class'GameDataTableRow_Attack'`

## Fields

Each line is a row field path (nested structs use dot notation; `[]` marks array-of-struct). The literal **Unknown** is the official description placeholder; the bracketed line is an AI guess from the field name only.

- **AttackActionType** — Unknown (AI - Possible description: High-level attack classification such as strike, grab, or projectile.)
- **AttackAvoidType** — Unknown (AI - Possible description: Evasion or clash behavior associated with this attack state.)
- **AttackTiming** — Unknown (AI - Possible description: Time offset or phase for active frames, cancels, or hit validation.)
- **AttackTransitionKind** — Unknown (AI - Possible description: Per-slot or per-route transition category for combo logic.)
- **AttackTransitionType** — Unknown (AI - Possible description: How this attack chains or transitions on hit, guard, or whiff.)
- **AutoComboFixedCursedEnergyLevel** — Unknown (AI - Possible description: Locks cursed-energy tier used by auto-combo extensions.)
- **AutoTransitionKind** — Unknown (AI - Possible description: Automatic follow-up route when auto-combos or CE auto routes fire.)
- **AutoTransitionKind_CursedEnergy** — Unknown (AI - Possible description: Auto follow-up route when using cursed-energy auto-combo paths.)
- **bChangeLastHitNotTargetEnabled** — Unknown (AI - Possible description: If true, adjusts behavior when the last hit lacked a valid target.)
- **bHyperArmorEnabled** — Unknown (AI - Possible description: If true, grants hyper armor against stronger interrupt attempts.)
- **BlendInTime_Fall** — Unknown (AI - Possible description: Seconds to blend this anim in from fall state; -1 may mean default.)
- **BlendInTime_Idle** — Unknown (AI - Possible description: Seconds to blend this anim in from idle state; -1 may mean default.)
- **bSuperArmorEnabled** — Unknown (AI - Possible description: If true, grants super armor so light hits do not flinch the attacker.)
- **bTargetOnlyHitAttackTransitionEnabled** — Unknown (AI - Possible description: If true, attack can transition only when the hit connects.)
- **bUpdateHomingLocation** — Unknown (AI - Possible description: If true, homing target position updates during the attack.)
- **CharacterAnimation** — Unknown (AI - Possible description: Character animation asset or montage slot name for this move.)
- **CharacterFacial** — Unknown (AI - Possible description: Facial expression preset during the attack.)
- **ContinuousUseAttackVoiceType** — Unknown (AI - Possible description: Voice set used when repeating or holding this attack input.)
- **CursedEnergy_Add** — Unknown (AI - Possible description: Flat change to attacker cursed-energy meter on this event.)
- **CursedEnergyCalcType** — Unknown (AI - Possible description: Rule for how CE gain or cost is computed for this action.)
- **DistanceDelayAttackTiming** — Unknown (AI - Possible description: Extra timing tied to spacing or delayed activation at range.)
- **ID** — Unknown (AI - Possible description: Primary identifier for this row; used as DataTable row name and for lookups.)
- **Id_ActionHoming** — Unknown (AI - Possible description: ActionHomingDataTable row for homing during this attack.)
- **Id_CancelAttackActionHoming** — Unknown (AI - Possible description: Homing profile used when canceling into this attack.)
- **Id_ParallelAttack** — Unknown (AI - Possible description: ParallelAttackDataTable row for simultaneous hit logic.)
- **SimpleDomainCounterReceiveDelayTime** — Unknown (AI - Possible description: Delay before domain-expansion counter response can register in simplified rules.)
- **SimpleDomainCounterReceiveType** — Unknown (AI - Possible description: Which counter or clash response type applies for simple domain interactions.)
- **TargetChangeType** — Unknown (AI - Possible description: How the current combat target may switch during this attack.)
- **WeaponAnimation** — Unknown (AI - Possible description: Weapon-specific animation layer or pose name.)
