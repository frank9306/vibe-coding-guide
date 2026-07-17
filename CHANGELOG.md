# Changelog

本项目的重要变更记录在此文件中。

## Unreleased

## [1.1.1] - 2026-07-17

### Changed

- 将推荐的 Waza 界面设计 Skill 从 `design` 更新为其正式继任名称 `ui`。

## [1.1.0] - 2026-07-16

### Added

- 增加一句自然语言触发的 AI 安装协议与机器可读标准清单。
- 增加可分发的全局、项目和 Claude Code 标准配置。
- 增加清单驱动的 Windows 安装器和统一仓库验证入口。
- 增加身份与称呼、回复语言和回复风格的全局个性化确认流程。
- 增加指令语言、第三方 Skills 授权和安装结果验证门禁。
- 推荐经过白名单约束的 `tw93/Waza` 核心 Skills 组合。

### Changed

- 让仓库自身遵循项目模板，根 `AGENTS.md` 只保存本项目规则。
- 将手工命令安装降级为 AI 安装失败时的故障排查方式。
- 将全局安装与项目应用拆分为独立生命周期，安装不再修改当前项目。
- 统一使用一个带个性化确认的全局安装流程。
- 统一以英文编写 Agent 指令，以简体中文进行用户交互和文档说明。
- 扩大全局规则的编码、工作区保护、Git 安全和验证边界。

## [1.0.0] - 2026-07-16

### Added

- 建立全局、项目、执行器和外部能力四层 Vibe Coding 治理模型。
- 增加 Skill 组合、MCP/Plugin、安全维护和项目接入指南。
- 增加全局 `AGENTS.md`、项目 `AGENTS.md` 与 Claude Code 适配模板。
- 增加受控的 `project-bootstrap` Skill 和 Python、Go、前端技术栈参考。

### Changed

- 将仓库从零散资料集合重构为中文 Vibe Coding 治理指南。
- 精简仓库自身的 Agent 指令，补充内容和 Skill 验证规则。

### Removed

- 移除重复的中文 README 和旧 OpenRouter 免费模型单篇资料。
