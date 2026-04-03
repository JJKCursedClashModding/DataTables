# ActionDataTable

**Source:** `input_json/ActionDataTable.json`.

**Row struct (from export):** `Class'GameDataTableRow_Action'`

## Fields

Each line is a row field path (nested structs use dot notation; `[]` marks array-of-struct). The literal **Unknown** is the official description placeholder; the bracketed line is an AI guess from the field name only.

- **ID** — ID

### Movement Tables
- **Id_ActionBreakFall** — Fall recovery
- **Id_ActionDash** — Dash Table ID
- **Id_ActionJump** — Jump Table ID
- **Id_ActionMove** — Movement Table ID
- **Id_ActionStep** — Step Table ID


### Normal Attack Chains
- **Id_AttackSet_Normal_1** — X/Square attacks
- **Id_AttackSet_Normal_1_1** — X/Square + Down Attacks
- **Id_AttackSet_Normal_1_1_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
- **Id_AttackSet_Normal_1_1_Solo** — X/Square + Down Attacks when solo
- **Id_AttackSet_Normal_1_1_Solo_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
- **Id_AttackSet_Normal_1_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
- **Id_AttackSet_Normal_2** — Y/Triangle 
- **Id_AttackSet_Normal_2_1** — Y/Triangle + Down
- **Id_AttackSet_Normal_2_1_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
- **Id_AttackSet_Normal_2_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
- **Id_AttackSet_Normal_3** — B/Circle 
- **Id_AttackSet_Normal_3_1** — B/Circle + Down 
- **Id_AttackSet_Normal_3_1_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
- **Id_AttackSet_Normal_3_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
auto-combo variant.)

### Air Attacks 

Same as above, when in air. When in a combo (grounded or air), the _1 (Button + Down) variants seem to take priority. So you can use X Down Air during a grounded combo, if Air and Ground are different

- **Id_AttackSet_Normal_Air_1** — Unknown 
- **Id_AttackSet_Normal_Air_1_1** — Unknown 
- **Id_AttackSet_Normal_Air_1_1_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else
- **Id_AttackSet_Normal_Air_1_1_Solo** — Unknown 
- **Id_AttackSet_Normal_Air_1_1_Solo_Auto** — Can be transitioned into using `AutoTransitionKind` in the Attack table. Doesn't seem to do anything else 
- **Id_AttackSet_Normal_Air_1_Auto** — Unknown 
- **Id_AttackSet_Normal_Air_2** — Unknown 
- **Id_AttackSet_Normal_Air_2_1** — Unknown 
- **Id_AttackSet_Normal_Air_2_1_Auto** — Unknown 
- **Id_AttackSet_Normal_Air_2_Auto** — Unknown 
- **Id_AttackSet_Normal_Air_3** — Unknown 
- **Id_AttackSet_Normal_Air_3_1** — Unknown 
- **Id_AttackSet_Normal_Air_3_1_Auto** — Unknown 
- **Id_AttackSet_Normal_Air_3_Auto** — Unknown 

### Cursed Energy Attacks

These are specials, listed in an array per cursed energy level. Goes up to level 4 (not sure what level 4 means)

- **Id_AttackSet_CursedEnergy_1** — R1 Special
- **Id_AttackSet_CursedEnergy_1_Auto** — R1 Special - Version that is transitioned into from auto combo (sometimes `2_Auto` instead). Can be chained from other moves as well (by using `AutoTransitionKind_CursedEnergy`)
- **Id_AttackSet_CursedEnergy_Air_1** — R1 Special Air
- **Id_AttackSet_CursedEnergy_Air_1_Auto** — Same as `1_Auto`


- **Id_AttackSet_CursedEnergy_2** — Unknown (AI - Possible description: AttackSetDataTable row for cursed-energy attacks.)
- **Id_AttackSet_CursedEnergy_2_Auto** — Unknown (AI - Possible description: AttackSetDataTable row for cursed-energy attacks, auto-combo variant.)

- **Id_AttackSet_CursedEnergy_Air_2** — Unknown (AI - Possible description: AttackSetDataTable row for cursed-energy attacks, airborne variant.)
- **Id_AttackSet_CursedEnergy_Air_2_Auto** — Unknown (AI - Possible description: AttackSetDataTable row for cursed-energy attacks, airborne variant, auto-combo variant.)

### Super Attacks 

L2 + R2 Attacks

- **Id_AttackSet_SuperCursedEnergy** — Unknown (AI - Possible description: AttackSetDataTable row for cursed-energy attacks.)
- **Id_AttackSet_SuperCursedEnergy_Air** — Unknown (AI - Possible description: AttackSetDataTable row for cursed-energy attacks, airborne variant.)

### Extra Attacks

Unsure what these do yet. Crashes the game if you try to use `AutoTransitionKind_CursedEnergy` to transition into them

- **Id_ExtraAttack_1** — Unknown (AI - Possible description: Foreign key to another DataTable or asset row; suffix suggests extra attack 1.)
- **Id_ExtraAttack_2** — Unknown (AI - Possible description: Foreign key to another DataTable or asset row; suffix suggests extra attack 2.)
