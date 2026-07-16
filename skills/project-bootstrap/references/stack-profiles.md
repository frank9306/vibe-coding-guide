# Stack Profiles

Defaults reduce unnecessary questions; they are not mandatory standards. Existing repositories keep their runtime, package manager, frameworks, and lock files.

## Python CLI

- Environment: `uv`
- CLI: `Typer`; prefer standard `argparse` when dependencies add no value
- Output: `Rich` only when formatting is required
- Tests: `pytest`
- Lint and format: `ruff`

## Python Backend

- Environment: `uv`
- HTTP: `FastAPI` for an async typed API
- Tests: `pytest`
- Lint and format: `ruff`
- Database and migrations require an explicit product decision

## Go

- Standard library before frameworks
- Normal Go package boundaries
- Table-driven tests where useful
- Verify with `go test ./...`
- No dependency injection framework without demonstrated need

## Frontend

- Package manager: `pnpm`
- Build tool: `Vite` for a new standalone SPA unless full stack is required
- Reuse the project's design system before adding a component library
- Select unit, component, or browser tests according to risk
- Do not add Tailwind, shadcn, state libraries, or routing without a requirement

## Cross-stack

- Generate a minimal vertical slice, not speculative architecture.
- Keep configuration explicit and documented.
- Add `.env.example` only when variables are required; never include values.
- Prefer one verification entry point reusable by CI.
