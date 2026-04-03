$ErrorActionPreference = 'Stop'

$root = 'C:\Users\Ahmed\Downloads\6ff2cdb87e9e6f8ae1b9ff13ca859ff1da770360\Output\Exports\Jujutsu Kaisen CC\Content\DataTables'
$inFile = Join-Path $root 'POSSIBLE_FIELDS.md'
$outFile = Join-Path $root 'POSSIBLE_FIELDS_RELEVANT_ENDLAG_CANCEL.md'

if(-not (Test-Path $inFile)) { throw "Missing input: $inFile" }
if(Test-Path $outFile){ Remove-Item $outFile -Force }

$keywords = @(
  'Cancel',            # Cancel windows / inputs
  'Transition',        # Attack transitions / chaining
  'Timing',            # AttackTiming, Delay, etc.
  'BlendInTime',       # blend-out into idle/fall
  'RestraintTime',     # common “stuck” timer
  'HitSlow',           # hit slow / freeze feel
  'Rigidity',          # rigidity / lockout
  'Guard_Rigidity',    # explicit defender rigidity
  'Knockback_',        # knockback times
  'Guard_',            # guard-specific slowdown/rigidity
  'StepEnd_',         # step end play rates
  'Inertia_Time',     # inertia after action
  'PlayRate',         # end play rates
  'Minimum_Time',    # dash minimum time
  'Overtime',         # jump overtime windows
  'Gravity_Delay'     # air-dash / gravity delay
)

$keySet = New-Object System.Collections.Generic.HashSet[string]

foreach($line in Get-Content -Path $inFile){
  # Expect lines like: - SomeFieldName
  if($line -match '^\-\s+([A-Za-z0-9_]+)\s*$'){
    $key = $matches[1]
    if(-not [string]::IsNullOrWhiteSpace($key)){
      # Exclude row keys/ids (the scan also captures the keys inside the "Rows" object)
      if($key -match '^(CP_|CN_|AM_)'){ continue }
      # Also exclude keys that are entirely uppercase (almost certainly row IDs/enums, not property names)
      if($key -cmatch '^[A-Z0-9_]+$'){ continue }

      $hit = $false
      foreach($kw in $keywords){
        if($key -like "*$kw*"){
          $hit = $true
          break
        }
      }
      if($hit){
        $null = $keySet.Add($key)
      }
    }
  }
}

$sorted = @($keySet) | Sort-Object

$writer = New-Object System.IO.StreamWriter($outFile, $false, [System.Text.UTF8Encoding]::new($false))
$writer.WriteLine('# Possible “end-lag / cancel / responsiveness” fields (filtered from POSSIBLE_FIELDS.md)')
$writer.WriteLine('')
$writer.WriteLine('_Heuristic filter: keeps keys whose names contain common timing/cancel/rigidity/freeze/inertia substrings._')
$writer.WriteLine('')

foreach($k in $sorted){
  $writer.WriteLine('- ' + $k)
}

$writer.Flush()
$writer.Close()

Write-Host ('Wrote: ' + $outFile)

