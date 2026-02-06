param(
    [string]$Root = ".",
    [string[]]$ExtraPatterns = @()
)

$ErrorActionPreference = "Stop"

$patterns = @(
    'C:\\Users\\',
    'D:\\',
    'AppData\\Roaming',
    'sk-[A-Za-z0-9]{20,}',
    '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
)
$patterns += $ExtraPatterns

$selfPath = $MyInvocation.MyCommand.Path
$files = Get-ChildItem -Recurse -File $Root |
    Where-Object { $_.Extension -in '.md','.ps1','.txt','.json','.yml','.yaml','.cmd','.env' }

$hits = @()
foreach ($f in $files) {
    if ($f.FullName -eq $selfPath) { continue }
    foreach ($pat in $patterns) {
        $m = Select-String -Path $f.FullName -Pattern $pat -AllMatches -ErrorAction SilentlyContinue
        if ($m) { $hits += $m }
    }
}

if ($hits.Count -eq 0) {
    Write-Host "No sensitive-pattern hits found in $Root"
    exit 0
}

Write-Host "Sensitive-pattern hits: $($hits.Count)"
$hits | Select-Object Path,LineNumber,Line | Format-Table -AutoSize
exit 1

