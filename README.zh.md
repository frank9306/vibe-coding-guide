# Vibe Coding 指南

个人收集的 **vibe-coding** 相关资料合集 —— 文章、笔记、摘要、提示词与参考链接，来源包括个人总结和外部资料。

[English](./README.md)

## 文件

```
.
├── AGENTS.md
└── README.md
```

## [AGENTS.md](./AGENTS.md)

仓库主人的完整 opencode 全局提示词。把 **Karpathy 启发的 LLM 编码准则**（编码前思考、简洁优先、精准修改、目标驱动执行）与个人身份、语言、响应风格、工程工作流偏好合并而成。放到 `~/.config/opencode/AGENTS.md` 即可全局生效，也可以放在项目根目录作为单项目覆盖。

四条核心原则源头：[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)。

## [README.md](./README.md)

本 README 的英文版。

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
