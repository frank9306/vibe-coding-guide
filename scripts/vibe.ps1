[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('install', 'apply', 'init', 'doctor', 'uninstall')]
    [string]$Command = 'doctor',
    [string]$Path = (Get-Location).Path,
    [string]$HomePath = $HOME,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$script:RepoRoot = Split-Path -Parent $PSScriptRoot
$script:Manifest = Get-Content -LiteralPath (Join-Path $script:RepoRoot 'vibe-standard.json') -Raw -Encoding utf8 | ConvertFrom-Json
$script:AgentRoot = Join-Path $HomePath '.agents'
$script:InstalledSkill = Join-Path $HomePath $script:Manifest.install.skills[0].target

function Write-Status([string]$State, [string]$Message) {
    Write-Host ("[{0}] {1}" -f $State, $Message)
}

function Backup-Target([string]$Target) {
    if (-not (Test-Path -LiteralPath $Target)) { return }
    $backup = "$Target.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item -LiteralPath $Target -Destination $backup -Recurse
    Write-Status 'BACKUP' $backup
}

function Copy-GovernedItem([string]$Source, [string]$Target) {
    if (Test-Path -LiteralPath $Target) {
        if (-not $Force) {
            Write-Status 'SKIP' "$Target already exists; use -Force to replace it"
            return
        }
        Backup-Target $Target
        Remove-Item -LiteralPath $Target -Recurse -Force
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $Target) -Force | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Target -Recurse
    Write-Status 'WRITE' $Target
}

function Install-Governance {
    foreach ($skill in $script:Manifest.install.skills) {
        Copy-GovernedItem (Join-Path $script:RepoRoot $skill.source) (Join-Path $HomePath $skill.target)
    }
    $global = $script:Manifest.install.globalInstructions
    Copy-GovernedItem (Join-Path $script:RepoRoot $global.source) (Join-Path $HomePath $global.target)
    Write-Status 'NEXT' 'Confirm identity, language, and response style; write rules in English and preserve literal names or phrases.'
    Write-Status 'RECOMMEND' $script:Manifest.install.recommendedSkills.command
    Write-Status 'GATE' 'Recommend the manifest-declared Waza Skills, but run the command only after explicit user approval.'
    Write-Status 'READY' 'Global governance is installed. Apply it to a project only when needed.'
}

function Initialize-Project {
    $project = [System.IO.Path]::GetFullPath($Path)
    if (-not (Test-Path -LiteralPath $project -PathType Container)) {
        throw "Project directory does not exist: $project"
    }
    foreach ($file in $script:Manifest.apply.projectFiles) {
        Copy-GovernedItem (Join-Path $script:RepoRoot $file.source) (Join-Path $project $file.target)
    }
    Write-Status 'NEXT' 'Ask your agent to replace template commands with commands detected from this project.'
    Write-Status 'NEXT' 'Then run doctor for this project.'
}

function Test-Governance {
    $project = [System.IO.Path]::GetFullPath($Path)
    $checks = @(
        @{ Name = 'global AGENTS.md'; Path = (Join-Path $script:AgentRoot 'AGENTS.md') },
        @{ Name = 'project-bootstrap skill'; Path = (Join-Path $script:InstalledSkill 'SKILL.md') },
        @{ Name = 'project AGENTS.md'; Path = (Join-Path $project 'AGENTS.md') },
        @{ Name = 'Claude adapter'; Path = (Join-Path $project 'CLAUDE.md') }
    )
    $failed = $false
    foreach ($check in $checks) {
        if (Test-Path -LiteralPath $check.Path) {
            Write-Status 'PASS' "$($check.Name): $($check.Path)"
        } else {
            Write-Status 'MISS' "$($check.Name): $($check.Path)"
            $failed = $true
        }
    }
    $projectAgents = Join-Path $project 'AGENTS.md'
    if (Test-Path -LiteralPath $projectAgents) {
        $content = Get-Content -LiteralPath $projectAgents -Raw -Encoding utf8
        if ($content -match 'replace with') {
            Write-Status 'WARN' 'Project AGENTS.md still contains template placeholders'
            $failed = $true
        }
    }
    if ($failed) {
        Write-Status 'RESULT' 'Governance setup is incomplete'
        exit 1
    }
    Write-Status 'RESULT' 'Governance setup is ready'
}

function Uninstall-Governance {
    if (Test-Path -LiteralPath $script:InstalledSkill) {
        Remove-Item -LiteralPath $script:InstalledSkill -Recurse -Force
        Write-Status 'REMOVE' $script:InstalledSkill
    } else {
        Write-Status 'SKIP' 'project-bootstrap skill is not installed'
    }
    Write-Status 'KEEP' 'Global and project AGENTS.md files were preserved'
}

switch ($Command) {
    'install' { Install-Governance }
    'apply' { Initialize-Project }
    'init' { Initialize-Project }
    'doctor' { Test-Governance }
    'uninstall' { Uninstall-Governance }
}
