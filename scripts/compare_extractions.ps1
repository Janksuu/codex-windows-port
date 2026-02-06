param(
    [Parameter(Mandatory = $true)]
    [string]$OldDir,
    [Parameter(Mandatory = $true)]
    [string]$NewDir,
    [string]$OutFile = ".\version_compare.md"
)

$ErrorActionPreference = "Stop"

function Get-JsonValue {
    param([string]$Path, [string]$Field)
    if (-not (Test-Path $Path)) { return "N/A" }
    $json = Get-Content $Path -Raw | ConvertFrom-Json
    return $json.$Field
}

if (-not (Test-Path $OldDir)) { throw "OldDir not found: $OldDir" }
if (-not (Test-Path $NewDir)) { throw "NewDir not found: $NewDir" }

$oldPkg = Join-Path $OldDir "package.json"
$newPkg = Join-Path $NewDir "package.json"

$oldVersion = Get-JsonValue -Path $oldPkg -Field "version"
$newVersion = Get-JsonValue -Path $newPkg -Field "version"
$oldBuild = Get-JsonValue -Path $oldPkg -Field "codexBuildNumber"
$newBuild = Get-JsonValue -Path $newPkg -Field "codexBuildNumber"

$oldFileCount = (Get-ChildItem -Recurse -File $OldDir | Measure-Object).Count
$newFileCount = (Get-ChildItem -Recurse -File $NewDir | Measure-Object).Count

$oldMain = Get-ChildItem (Join-Path $OldDir ".vite\build") -Filter "main-*.js" -ErrorAction SilentlyContinue | Select-Object -First 1
$newMain = Get-ChildItem (Join-Path $NewDir ".vite\build") -Filter "main-*.js" -ErrorAction SilentlyContinue | Select-Object -First 1

$report = @"
# Version Compare

- Old version: $oldVersion (build $oldBuild)
- New version: $newVersion (build $newBuild)
- Old file count: $oldFileCount
- New file count: $newFileCount

## Main Bundle

- Old: $($oldMain.Name)
- New: $($newMain.Name)

## Notes

- Re-apply Windows patches on the new main bundle and preload.
- Re-validate native modules for Windows runtime.
"@

$report | Set-Content -Path $OutFile -Encoding UTF8
Write-Host "Wrote $OutFile"

