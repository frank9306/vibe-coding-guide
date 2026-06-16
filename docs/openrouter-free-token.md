---
title: OpenRouter 免费模型使用指南
added: 2026-06-15
tags: [vibe-coding, llm, api, free-tier]
---

# OpenRouter 免费模型使用指南

OpenRouter 是统一的 LLM API 网关。大部分模型按 token 计费，但有部分模型对所有用户**完全免费** —— 模型 ID 末尾带 `:free` 后缀（例如 `google/gemini-2.0-flash-exp:free`、`deepseek/deepseek-chat-v3.1:free`）。

免费模型列表经常变动，以 [openrouter.ai/models](https://openrouter.ai/models) 的实时筛选结果为准。

## 一次性准备

1. 打开 [openrouter.ai](https://openrouter.ai)，注册并登录
2. 进入 [openrouter.ai/keys](https://openrouter.ai/keys)，点击 **Create Key** 生成 API Key
3. **复制并妥善保存 Key** —— 创建后只显示一次

## 在 opencode 中使用

1. 打开 opencode，进入 provider 设置
2. 选择 **OpenRouter** 作为 provider，把上一步的 API Key 粘进去
3. 模型列表中挑选带 `:free` 后缀的模型即可开始用

不需要手动调 API、构造 curl 或设置 Base URL，opencode 帮你处理。

## 注意事项

- 免费模型通常限速较低（RPM / RPD），生产场景不适合，**仅适合个人调试和 vibe coding**
- 部分免费模型可能要求账户里有少量余额（通常 1 美元左右），以 OpenRouter 当前策略为准
- 不要在免费模型调用中发送敏感数据
