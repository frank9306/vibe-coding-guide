# Vibe Coding 指南

个人收集的 **vibe-coding** 相关资料合集 —— 文章、笔记、摘要、提示词与参考链接，来源包括个人总结和外部资料。

目的：把那些让 AI 辅助编程真正在实践中起作用的思路、工具、工作流和提示词，集中放在一个可检索的地方。

[English](./README.md)

## 目录结构

```
.
├── README.md          # 英文版
├── README.zh.md       # 本文件（中文）
└── AGENTS.md          # Karpathy 启发的 LLM 编码准则
```

## 内容

- [Karpathy 启发的 LLM 编码准则](./AGENTS.md) — 四条行为准则（编码前思考 / 简洁优先 / 精准修改 / 目标驱动执行），源自 Andrej Karpathy 对 LLM 编码陷阱的观察。[源头项目](https://github.com/multica-ai/andrej-karpathy-skills)

## 跨 Agent 适配

同一份 `AGENTS.md` 内容可通过软链接或复制，适配到不同编码 agent 的约定路径：

| Agent | 配置文件 | 备注 |
|---|---|---|
| **opencode**（主用） | `AGENTS.md` | 全局：`~/.config/opencode/AGENTS.md`；项目级：仓库根 |
| **Claude Code** | `CLAUDE.md` | 或通过上游 Claude Code 插件市场安装 |
| **Cursor** | `.cursor/rules/karpathy-guidelines.mdc` | 上游已提供带 `alwaysApply: true` 的规则文件 |
| **Codex CLI** | `AGENTS.md` | 与 opencode 同名同位置，可直接共用同一份文件 |

> 源头有更新时记得同步本仓库的 `AGENTS.md`。

## 许可

仅供个人使用，引用请自行判断。
