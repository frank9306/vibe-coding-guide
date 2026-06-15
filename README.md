# Vibe Coding Guide

A personal collection of useful **vibe-coding** resources — articles, notes, summaries, prompts, and references gathered from personal summaries and external sources.

The goal is to keep a single, searchable place for the ideas, tools, workflows, and prompts that make AI-assisted coding actually work in practice.

[简体中文](./README.zh.md)

## Repository Layout

```
.
├── README.md          # this file (English)
├── README.zh.md       # Chinese version
└── AGENTS.md          # Karpathy-inspired LLM coding guidelines
```

## Contents

- [Karpathy-Inspired LLM Coding Guidelines](./AGENTS.md) — Four behavioral principles (think before coding, simplicity first, surgical changes, goal-driven execution) derived from Andrej Karpathy's observations on LLM coding pitfalls. [Source](https://github.com/multica-ai/andrej-karpathy-skills).

## Cross-Agent Usage

The same `AGENTS.md` content is compatible with multiple coding agents — symlink or copy it to the path each agent expects:

| Agent | Config File | Notes |
|---|---|---|
| **opencode** (primary) | `AGENTS.md` | Global: `~/.config/opencode/AGENTS.md`; project: repo root |
| **Claude Code** | `CLAUDE.md` | Or install via the upstream Claude Code plugin marketplace |
| **Cursor** | `.cursor/rules/karpathy-guidelines.mdc` | Upstream ships a rule with `alwaysApply: true` |
| **Codex CLI** | `AGENTS.md` | Same filename and location as opencode — share the file directly |

> Keep this file in sync with the upstream source when changes are published.

## License

Personal use. Reuse at your own discretion.
