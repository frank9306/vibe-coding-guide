---
name: project-bootstrap
description: "Initialize governed Python CLI, Python backend, Go, or frontend projects from a product request."
---

# Project Bootstrap

Create the smallest maintainable project satisfying the request. Preserve existing repositories; never overwrite non-empty targets without explicit approval.

## Workflow

1. Inspect the target directory, Git status, instructions, manifests, lock files, and CI.
2. Restate the goal, non-goals, stack, inputs, outputs, and acceptance criteria.
3. Select a profile from `references/stack-profiles.md`; existing conventions override defaults.
4. List dependency, credential, database, external-service, and deployment decisions requiring approval.
5. Create the minimum skeleton, one representative feature, tests, and a stable verification command.
6. Add a concise `AGENTS.md` with real commands, boundaries, and Definition of Done.
7. Add CI only when requested or already used; CI must reuse the local verification path.
8. Run verification and report exact evidence and unverified areas.

## Safety

- Do not install global Skills, Plugins, MCP servers, runtimes, or package managers.
- Do not change package manager in an existing project.
- Ask before deleting, installing dependencies, migrating data, changing authentication, committing, pushing, or deploying.
- Never place credentials in tracked files, prompts, examples, or logs.
- Stop after three identical failures, two no-progress checkpoints, a budget limit, or an external blocker.

## Output

Report the selected profile, changed files, verification command and result, approvals still required, and the next smallest milestone.
