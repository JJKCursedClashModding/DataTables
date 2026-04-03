# DataTable Transformation Script

## What it does
- Reads all `.json` files in `input_json`.
- Applies field transforms defined in `transformations.ts`.
- Writes only changed files to `output_json`.
- Output format is always:

```json
{
  "SomeRowName": {
    "OnlyChangedField": "newValue"
  }
}
```

Files with no changes are not written to `output_json`.

## Configure transforms
Edit `transformations.ts`:

```ts
export const transformations = [
  {
    files: /^ActionDashDataTable\d+\.json$/,
    transformations: [
      {
        fieldName: "Gauge",
        transform: (objectName, fieldValue) => Number(fieldValue) * 1.2,
        exceptions: [
          { name: "CP_010", transform: () => 1.0 }
        ],
        filter: (objectName) => objectName !== "CP_020"
      }
    ]
  }
];
```

`files` can be:
- exact filename string: `"ActionDashDataTable3.json"`
- string array: `["A.json", "B.json"]`
- regex: `/^ActionDashDataTable\d+\.json$/`

## Run
1. Install Node.js (if not installed).
2. Run:
   - `npm install`
   - `npm run transform`

## Extract cursed-energy attack IDs
This creates a JSON array of all `Id_Attack` entries from `AttackSetDataTable` rows where `bCursedEnergyAttack` is `true` (excluding `"None"`), and writes it to `output_json/cursed_energy_Id_Attack.json`.

Run in PowerShell from the project root:

```powershell
node -e "const fs=require('fs');const data=JSON.parse(fs.readFileSync('input_json/AttackSetDataTable.json','utf8'));const rows=data[0].Rows;const ids=[];for(const row of Object.values(rows)){if(row.bCursedEnergyAttack===true){ids.push(...(row.Id_Attack||[]).filter(id=>id&&id!=='None'));}}fs.writeFileSync('output_json/cursed_energy_Id_Attack.json',JSON.stringify(ids,null,2),'utf8');console.log('Wrote output_json/cursed_energy_Id_Attack.json');console.log('Count:',ids.length);"
```
