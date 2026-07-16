[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$errors = [System.Collections.Generic.List[string]]::new()

function Add-Error([string]$Message) {
    $errors.Add($Message)
}

try {
    $manifestPath = Join-Path $root 'vibe-standard.json'
    $manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding utf8 | ConvertFrom-Json
    $null = Get-Content -LiteralPath (Join-Path $root 'vibe-standard.schema.json') -Raw -Encoding utf8 | ConvertFrom-Json
} catch {
    Add-Error "JSON parse failed: $($_.Exception.Message)"
}

if ($null -ne $manifest) {
    $declaredPaths = @($manifest.entrypoint, $manifest.install.globalInstructions.source)
    $declaredPaths += @($manifest.install.skills | ForEach-Object { $_.source })
    $declaredPaths += @($manifest.install.projectFiles | ForEach-Object { $_.source })
    $declaredPaths += @($manifest.policies)
    foreach ($relative in $declaredPaths) {
        if (-not (Test-Path -LiteralPath (Join-Path $root $relative))) {
            Add-Error "Manifest path is missing: $relative"
        }
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $root -Recurse -Filter '*.md' -File
foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8
    foreach ($match in [regex]::Matches($content, '\[[^\]]+\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value
        if ($target -match '://' -or $target.StartsWith('#')) { continue }
        $localTarget = ($target -split '#', 2)[0]
        if ($localTarget -and -not (Test-Path -LiteralPath (Join-Path $file.DirectoryName $localTarget))) {
            Add-Error "Broken Markdown link: $($file.FullName) -> $target"
        }
    }
}

$skillFiles = Get-ChildItem -LiteralPath (Join-Path $root 'skills') -Recurse -Filter 'SKILL.md' -File
foreach ($file in $skillFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8
    if (-not $content.StartsWith("---`n") -or $content -notmatch '(?m)^name:\s*\S+' -or $content -notmatch '(?m)^description:\s*"[^"]+"') {
        Add-Error "Invalid Skill frontmatter: $($file.FullName)"
    }
}

foreach ($script in Get-ChildItem -LiteralPath (Join-Path $root 'scripts') -Filter '*.ps1' -File) {
    $tokens = $null
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$parseErrors)
    foreach ($parseError in $parseErrors) {
        Add-Error "PowerShell parse error in $($script.Name): $($parseError.Message)"
    }
}

$rootAgents = Get-Content -LiteralPath (Join-Path $root 'AGENTS.md') -Raw -Encoding utf8
if ($rootAgents -match 'replace with|TODO|TBD') {
    Add-Error 'Root AGENTS.md contains an unfinished placeholder'
}

Push-Location $root
try {
    $previousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $diffCheck = & git diff --check 2>&1
    $diffExitCode = $LASTEXITCODE
    $ErrorActionPreference = $previousErrorAction
    if ($diffExitCode -ne 0) {
        Add-Error "git diff --check failed: $($diffCheck -join ' ')"
    }
} finally {
    $ErrorActionPreference = 'Stop'
    Pop-Location
}

if ($errors.Count -gt 0) {
    foreach ($message in $errors) { Write-Host "[FAIL] $message" }
    Write-Host "[RESULT] $($errors.Count) verification error(s)"
    exit 1
}

Write-Host '[PASS] JSON manifest and schema parse'
Write-Host '[PASS] Manifest paths exist'
Write-Host '[PASS] Markdown links resolve'
Write-Host '[PASS] Skill frontmatter is valid'
Write-Host '[PASS] PowerShell scripts parse'
Write-Host '[PASS] Root project instructions are complete'
Write-Host '[PASS] git diff --check'
Write-Host '[RESULT] Repository verification passed'
