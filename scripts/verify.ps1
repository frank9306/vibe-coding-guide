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
    $declaredPaths += @($manifest.apply.projectFiles | ForEach-Object { $_.source })
    $declaredPaths += @($manifest.policies)
    foreach ($relative in $declaredPaths) {
        if (-not (Test-Path -LiteralPath (Join-Path $root $relative))) {
            Add-Error "Manifest path is missing: $relative"
        }
    }

    $personalization = $manifest.install.globalInstructions.personalization
    $targetResolution = $manifest.install.globalInstructions.targetResolution
    $expectedFields = @('identity-and-addressing', 'language', 'response-style')
    if ($manifest.instructionLanguage -ne 'en' -or $null -eq $personalization -or $personalization.required -ne $true -or $personalization.allowDefaults -ne $true -or $personalization.mode -ne 'agent-guided-review-merge' -or $personalization.writeLanguage -ne 'en' -or $personalization.preserveLiteralValues -ne $true -or $targetResolution.preferredEnvironmentVariable -ne 'CODEX_HOME' -or $targetResolution.preferredRelativePath -ne 'AGENTS.md' -or $targetResolution.fallbackBase -ne 'user-home' -or $targetResolution.fallbackRelativePath -ne '.agents/AGENTS.md') {
        Add-Error 'Manifest global personalization contract is invalid'
    } else {
        $actualFields = @($personalization.fields)
        foreach ($field in $expectedFields) {
            if ($field -notin $actualFields) {
                Add-Error "Manifest personalization field is missing: $field"
            }
        }
    }

    $recommended = $manifest.install.recommendedSkills
    $expectedRecommendedSkills = @('check', 'ui', 'health', 'hunt', 'learn', 'read', 'think', 'write')
    $expectedCommand = 'npx skills add tw93/Waza --skill check --skill ui --skill health --skill hunt --skill learn --skill read --skill think --skill write -g'
    if ($null -eq $recommended -or $recommended.installByDefault -ne $false -or $recommended.requiresExplicitApproval -ne $true -or $recommended.command -ne $expectedCommand) {
        Add-Error 'Recommended Skills installation contract is invalid'
    } else {
        foreach ($skill in $expectedRecommendedSkills) {
            if ($skill -notin @($recommended.skills)) {
                Add-Error "Recommended Skill is missing: $skill"
            }
        }
        foreach ($gate in @('show-source-command-and-skill-list', 'check-existing-skills-and-conflicts', 'explicit-user-approval', 'verify-installed-skills')) {
            if ($gate -notin @($recommended.gates)) {
                Add-Error "Recommended Skills gate is missing: $gate"
            }
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

$distributedGlobalAgents = Get-Content -LiteralPath (Join-Path $root $manifest.install.globalInstructions.source) -Raw -Encoding utf8
if ($distributedGlobalAgents -notmatch '^# Global Agent Instructions' -or $distributedGlobalAgents -notmatch 'Respond in Simplified Chinese by default\.') {
    Add-Error 'Distributed global instructions do not follow the English-rules/Chinese-response language contract'
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
Write-Host '[PASS] Global personalization contract is valid'
Write-Host '[PASS] Instruction language contract is valid'
Write-Host '[PASS] Recommended Skills gates are valid'
Write-Host '[PASS] Markdown links resolve'
Write-Host '[PASS] Skill frontmatter is valid'
Write-Host '[PASS] PowerShell scripts parse'
Write-Host '[PASS] Root project instructions are complete'
Write-Host '[PASS] git diff --check'
Write-Host '[RESULT] Repository verification passed'
