# Vibe Coding 指南

个人收集的 **vibe-coding** 相关资料合集 —— 文章、笔记、摘要、提示词与参考链接，来源包括个人总结和外部资料。

[English](./README.md)

## 文件

```
.
├── AGENTS.md
├── README.md
└── docs/
    └── openrouter-free-token.md
```

## [AGENTS.md](./AGENTS.md)

仓库主人的完整 opencode 全局提示词。把 **Karpathy 启发的 LLM 编码准则**（编码前思考、简洁优先、精准修改、目标驱动执行）与个人身份、语言、响应风格、工程工作流偏好合并而成。放到 `~/.config/opencode/AGENTS.md` 即可全局生效，也可以放在项目根目录作为单项目覆盖。

四条核心原则源头：[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)。

## [docs/openrouter-free-token.md](./docs/openrouter-free-token.md)

OpenRouter 免费模型（ID 末尾带 `:free`）在 opencode 中的使用流程：一次性 API Key 准备，opencode provider 设置里粘贴 Key，选择带 `:free` 的模型即可。

## 许可

仅供个人使用，引用请自行判断。
