$ErrorActionPreference = 'Stop'

$root = 'C:\Users\Ahmed\Downloads\6ff2cdb87e9e6f8ae1b9ff13ca859ff1da770360\Output\Exports\Jujutsu Kaisen CC\Content\DataTables'
$inFile = Join-Path $root 'POSSIBLE_FIELDS.md'
$outFile = Join-Path $root 'POSSIBLE_FIELDS_RELEVANT_ENDLAG_CANCEL_WITH_SOURCES.md'

if(-not (Test-Path $inFile)){ throw "Missing input: $inFile" }
if(Test-Path $outFile){ Remove-Item $outFile -Force }

$keywords = @(
  'Cancel',
  'Transition',
  'Timing',
  'BlendInTime',
  'BlendInTime',
  'BlendInTime_Idle',
  'BlendInTime_Fall',
  'RestraintTime',
  'HitSlow',
  'Rigidity',
  'Guard_Rigidity',
  'Knockback_',
  'Guard_',
  'StepEnd_',
  'Inertia_Time',
  'PlayRate',
  'Minimum_Time',
  'Overtime',
  'Gravity_Delay',
  'Guard_Minimum_Time',
  'JustGuard'
)

# Map: field name -> HashSet of DataTable filenames that contain it.
$fieldToSources = @{}

$jsonFiles = Get-ChildItem -Path $root -Filter '*.json' | Sort-Object Name

$idxToken = '"Rows"'

foreach($f in $jsonFiles){
  $content = Get-Content -Path $f.FullName -Raw
  $posRows = $content.IndexOf($idxToken)
  if($posRows -ge 0){
    $contentSub = $content.Substring($posRows)
  } else {
    $contentSub = $content
  }

  $matches = [regex]::Matches($contentSub, '"([A-Za-z0-9_]+)"\s*:')
  foreach($m in $matches){
    $key = $m.Groups[1].Value
    if([string]::IsNullOrWhiteSpace($key)){ continue }

    # Exclude row keys/ids captured inside the Rows object
    if($key -match '^(CP_|CN_|AM_)'){ continue }

    # Exclude enum-ish/all-caps identifiers to avoid huge noise
    if($key -cmatch '^[A-Z0-9_]+$'){ continue }

    # Filter by heuristic keywords
    $hit = $false
    foreach($kw in $keywords){
      if($key -like "*$kw*"){
        $hit = $true
        break
      }
    }
    if(-not $hit){ continue }

    if(-not $fieldToSources.ContainsKey($key)){
      $fieldToSources[$key] = New-Object System.Collections.Generic.HashSet[string]
    }
    $null = $fieldToSources[$key].Add($f.Name)
  }
}

$sortedKeys = @($fieldToSources.Keys) | Sort-Object

$writer = New-Object System.IO.StreamWriter($outFile, $false, [System.Text.UTF8Encoding]::new($false))
$writer.WriteLine('# Field -> DataTable sources (end-lag/cancel/response related fields)')
$writer.WriteLine('')
$writer.WriteLine('_Built from your exported JSON DataTables; filtered via field-name heuristics (Cancel/Timing/Blend/Restraint/HitSlow/Rigidity/etc.)._')
$writer.WriteLine('')

foreach($k in $sortedKeys){
  $sources = @($fieldToSources[$k]) | Sort-Object
  $writer.WriteLine('- ' + $k + ' — ' + ($sources -join ', '))
}

$writer.Flush()
$writer.Close()

Write-Host ('Wrote: ' + $outFile)

