# Project Instructions

## Project

- Purpose: distribute a practical Vibe Coding governance standard that a coding Agent can install from one natural-language request.
- Primary human entry point: `README.md`.
- Machine-readable distribution manifest: `vibe-standard.json`.
- Agent installation contract: `INSTALL.md`.

## Project Map

- `standard/`: installable global and project instruction files.
- `skills/project-bootstrap/`: governed project initialization Skill and stack references.
- `docs/`: detailed governance policies shared by people and Agents.
- `scripts/vibe.ps1`: manifest-driven Windows installer used by an Agent or for manual recovery.
- `scripts/verify.ps1`: stable repository verification entry point.
- `vibe-standard.schema.json`: schema for the distribution manifest.

## Commands

- Verify: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1`
- Test installer manually: run `scripts/vibe.ps1` with an isolated `-HomePath` and temporary project directory.

This documentation repository has no dependency installation, development server, build, or generated output.

## Content Rules

- Write user-facing documentation in Simplified Chinese.
- Keep guidance tool-neutral unless a section is explicitly runtime-specific.
- Distinguish official tool behavior from this repository's recommendations.
- Prefer concrete rules, commands, and acceptance criteria over slogans.
- Never include real credentials, private endpoints, or machine-specific secrets.
- Installation examples must preserve approval boundaries for overwrites, dependencies, Git writes, publishing, authentication, migrations, and data deletion.

## Distribution Boundaries

- `vibe-standard.json` is the source of truth for files distributed by this standard.
- `INSTALL.md` defines how an Agent interprets the manifest safely.
- `scripts/vibe.ps1` must read the manifest instead of maintaining a second hard-coded file list.
- Installable project rules belong in `standard/project/`; repository-specific rules belong only in this root `AGENTS.md`.
- Do not put this repository's paths or release process into the distributed global rules.
- Do not add dependencies, Plugins, MCP servers, runtimes, or remote installers without explicit approval.

## Skill Rules

- Skills live under `skills/<name>/SKILL.md`.
- Every Skill requires YAML frontmatter with `name` and a quoted `description`.
- Keep the main Skill workflow focused; move stack details into `references/`.
- Preserve explicit approval and stop conditions in installation or autonomous workflows.

## Definition of Done

- Human instructions, manifest, installation contract, standard files, and installer behavior remain consistent.
- Every path declared by `vibe-standard.json` exists.
- Local Markdown links resolve.
- Skill frontmatter and JSON files parse successfully.
- PowerShell scripts parse without syntax errors.
- `scripts/verify.ps1` passes.
- The final report names changed files, verification evidence, and remaining risk.

## Git and Release

- Keep `CHANGELOG.md` updated when preparing a commit.
- Confirm the exact version before changing versioned release records.
- Do not commit, push, publish, or create a release unless explicitly requested.
