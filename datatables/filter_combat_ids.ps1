$ErrorActionPreference = 'Stop'

$root = 'C:\Users\Ahmed\Downloads\6ff2cdb87e9e6f8ae1b9ff13ca859ff1da770360\Output\Exports\Jujutsu Kaisen CC\Content\DataTables'
$inFile = Join-Path $root 'POSSIBLE_FIELDS.md'
$outFile = Join-Path $root 'POSSIBLE_MOVE_IDS_NARROWED.md'

if(-not (Test-Path $inFile)) { throw "Missing input: $inFile" }
if(Test-Path $outFile) { Remove-Item $outFile -Force }

$wantedSections = @(
  'AttackDataTable1.json','AttackDataTable2.json','AttackDataTable3.json','AttackDataTable4.json','AttackDataTable5.json',
  'AttackSetDataTable.json',
  'DamageDataTable1.json','DamageDataTable2.json','DamageDataTable3.json','DamageDataTable4.json','DamageDataTable5.json',
  'CollisionModifyDataTable.json',
  'EffectMoveDataTable.json',
  'CharacterAnimationDataTable.json',
  'CharacterAnimationSetDataTable.json'
)

$combatHeader = @{}

$writer = New-Object System.IO.StreamWriter($outFile, $false, [System.Text.UTF8Encoding]::new($false))
$writer.WriteLine('# Narrowed “reasonable” combat IDs (from POSSIBLE_FIELDS.md)')
$writer.WriteLine('')
$writer.WriteLine('_Includes only CP_/CN_/AM_ row keys found in combat-relevant DataTable sections._')
$writer.WriteLine('')

$currentSection = ''
$includeThisSection = $false
$sectionSet = New-Object System.Collections.Generic.HashSet[string]

foreach($line in Get-Content -Path $inFile){
  # Section header lines look like: ## AttackDataTable1.json
  if($line -match '^##\s+(.+)$'){
    $currentSection = $matches[1].Trim()
    $includeThisSection = $wantedSections -contains $currentSection
    continue
  }

  if(-not $includeThisSection){ continue }

  # Only keep list items that look like IDs.
  # In POSSIBLE_FIELDS.md, IDs are stored as lines like: - CP_010_ATTACKA_01_01
  if($line -match '^\-\s+(CP_[A-Za-z0-9_]+|CN_[A-Za-z0-9_]+|AM_[A-Za-z0-9_]+)\s*$'){
    $sectionSet.Add($currentSection) | Out-Null
    $writer.WriteLine($line)
  }
}

$writer.Flush()
$writer.Close()

Write-Host ('Wrote: ' + $outFile)

