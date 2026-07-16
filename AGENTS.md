# Repository Instructions

## Purpose

- Document a practical, tool-neutral Vibe Coding governance system.
- `README.md` is the primary entry point; detailed policies live under `docs/`.
- Distinguish official behavior from personal recommendations.

## Content

- Write in Simplified Chinese by default.
- Prefer concrete rules, commands, and acceptance criteria over slogans.
- Separate global preferences, project instructions, runtime adapters, and external tools.
- Never include real credentials, private endpoints, or machine-specific secrets.
- Examples must preserve approval boundaries for deletion, dependencies, Git writes, publishing, authentication, and migrations.

## Skills

- Repository Skills live under `skills/<name>/SKILL.md`.
- Require YAML frontmatter with `name` and quoted `description`.
- Keep `SKILL.md` focused; put stack details in `references/`.
- Do not add installers or dependencies without explicit approval.

## Verification

After changes, resolve local Markdown links, parse Skill frontmatter, search for unfinished placeholders, run `git diff --check`, and inspect `git diff`. Do not commit or push unless explicitly requested.
