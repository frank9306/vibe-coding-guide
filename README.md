# Vibe Coding Governance

一套面向个人开发者的 Vibe Coding 治理仓库。目标不是继续收集 Agent、Plugin、Skill 和 MCP，而是让 Codex、Claude Code、OpenCode 等工具在同一套规则、权限和验证闭环中稳定工作。

适用技术栈：Python CLI、Python 后端、Go 和前端。这里提供治理原则、可复制模板以及一个受控的 `project-bootstrap` Skill，不绑定具体模型或 IDE。

## 为什么需要治理

Vibe Coding 失控通常不是模型不够强，而是配置层混乱：

- 个人偏好和项目约束全部塞进全局 Prompt。
- 同一规则分别复制到 `AGENTS.md`、`CLAUDE.md` 和工具设置，最终互相冲突。
- Skill 越装越多，却没有明确触发条件、来源和退役机制。
- MCP、Plugin 与 Agent 自带的文件、终端和浏览器能力重复。
- Agent 能生成代码，却没有稳定的验证入口和停止条件。
- 第三方 Skill 跟随上游最新版本更新，未经 diff 审查。

## 核心模型

```text
个人层        全局偏好、安全底线、通用工作流
项目层        架构、业务约束、真实命令、完成定义
执行层        Codex / Claude Code / OpenCode
外部能力层    MCP / Plugin / Connector，仅按需接入
```

### 1. 一个项目事实源

项目根目录的 `AGENTS.md` 是项目规则唯一事实源。构建命令、测试方式、目录边界、发布规则和 Definition of Done 都写在这里。

其他工具只使用薄适配层。例如 Claude Code 的 `CLAUDE.md`：

```md
@AGENTS.md
```

不要复制完整内容，否则两份规则迟早漂移。

### 2. 按作用域放置规则

- 所有项目都成立的个人偏好放全局。
- 与仓库结构、团队和发布方式有关的规则放项目。
- 只对某类文件或目录成立的规则按路径加载。
- 密钥、个人账号和机器路径不进入版本控制。

推荐优先级：

```text
用户当前明确要求
  > 当前目录最近的项目规则
  > 项目根规则
  > 个人全局规则
  > Skill 默认建议
```

安全权限不只依靠 Prompt；能够由 sandbox、审批、hook 和 CI 强制的约束，应交给这些机制。

### 3. Workflow 优先于工具

日常开发围绕闭环，而不是围绕某个 Plugin：

```text
明确目标 → 读取项目 → 制定计划 → 最小修改 → 验证 → Review → 交付
```

工具只是执行手段。已有文件、终端或浏览器能力时，不重复安装同类 MCP。

### 4. 自动化保留权限边界

一句话启动项目不代表 Agent 可以无条件操作。以下动作默认需要明确授权：

- 安装或升级依赖
- 删除文件或数据
- 数据库 migration
- 修改认证和权限
- `git commit`、`git push`、部署和发布
- 调用付费服务或向第三方发送私有数据

### 5. 验证结果比生成速度重要

每个项目提供一个稳定验证入口，例如 `pnpm check`、`uv run pytest` 或 `go test ./...`。Agent 交付时必须说明实际运行的命令、结果和未验证部分，不能把“看起来正确”写成“测试通过”。

## 仓库结构

```text
.
├── AGENTS.md
├── README.md
├── docs/
│   ├── mcp-plugin-policy.md
│   ├── project-onboarding.md
│   ├── security-and-maintenance.md
│   └── skill-portfolio.md
├── skills/project-bootstrap/
│   ├── SKILL.md
│   └── references/stack-profiles.md
└── templates/
    ├── AGENTS.global.example.md
    ├── AGENTS.project.example.md
    └── CLAUDE.md
```

## 快速开始

### 建立个人全局规则

从 [`templates/AGENTS.global.example.md`](templates/AGENTS.global.example.md) 选择真正适合你的内容放入全局 Agent 指令。不要整份照搬。全局层只保留回复偏好、Git 与文件安全、修改原则和验证诚实性。

### 给项目添加规则

将 [`templates/AGENTS.project.example.md`](templates/AGENTS.project.example.md) 复制到目标仓库根目录并命名为 `AGENTS.md`，替换其中所有示例命令。Agent 指令里的每条验证命令都必须真实可执行。

需要 Claude Code 时，再复制 [`templates/CLAUDE.md`](templates/CLAUDE.md)。它只导入 `AGENTS.md`。

### 只保留核心 Skill 心智模型

日常只需要记住：

| 意图 | Skill |
|---|---|
| 需求与方案 | `think` |
| Bug 根因 | `hunt` |
| 测试驱动 | `tdd` |
| 代码和发布审查 | `check` |
| Agent 环境审计 | `health` |
| 调研 | `learn`、`read` |
| 文案 | `write` |

专业 Skill 按真实任务启用。详细治理方法见 [`docs/skill-portfolio.md`](docs/skill-portfolio.md)。

### 按需安装 MCP 和 Plugin

接入前必须回答：Agent 原生能力为什么不够、谁会使用、数据发往哪里、权限多大、如何测试、如何卸载。答不出来就不安装。详见 [`docs/mcp-plugin-policy.md`](docs/mcp-plugin-policy.md)。

### 使用项目启动器

[`skills/project-bootstrap/SKILL.md`](skills/project-bootstrap/SKILL.md) 把一句需求转成受控初始化流程。它生成最小项目结构、项目规则、测试、验证入口和 CI 建议，但不会自行安装全局工具或执行 Git 发布动作。

示例：

```text
创建一个使用 Typer、Rich、pytest 和 uv 的 Python CLI 项目，
命令名为 taskbox，支持导入 CSV 并输出 JSON。
```

## 日常任务写法

不要只说“帮我写完”。一句话包含目标、边界和验收条件：

```text
给用户列表增加按状态筛选，只改前端，不调整 API；
补充空状态和筛选测试，完成后运行项目规定的验证命令。
```

标准闭环：

1. Agent 读取 `AGENTS.md` 和相关代码。
2. 复述目标、非目标和验收条件。
3. 大改动先给出带验证步骤的计划。
4. 做最小范围修改。
5. 运行项目规定的验证命令。
6. 使用 Review Skill 检查 diff。
7. 用户确认后再 commit、push 或发布。

## 项目接入完成标准

- 根目录有简洁且真实的 `AGENTS.md`。
- 每个重要约束只有一个事实源。
- 有一个稳定、可执行的验证入口。
- CI 使用相同或等价的验证入口。
- 第三方 Skill、MCP 和 Plugin 有来源与作用域记录。
- 敏感信息不进入 Prompt、日志和 Git。
- 自主循环有超时、失败次数和外部阻塞停止条件。
- commit、push、发布和数据变更有明确授权边界。

## 治理节奏

每次任务只加载相关 Skill，并检查修改范围和验证证据。每月清理未使用能力、逐个审查第三方更新、验证 `AGENTS.md` 命令并消除重复规则。每次发布运行完整验证、审查依赖和生成产物、更新项目 changelog，并确认回滚方式。

## 明确不做

- 不提供适合所有项目的巨大 Prompt。
- 不要求统一使用 `.ai/` 目录。
- 不批量安装第三方 Skill、MCP 或 Plugin。
- 不把全部开发权限交给 Agent。
- 不用文档代替测试、lint、构建和安全检查。
- 不强制所有语言采用同一种目录结构。

## 详细指南

- [Skill 组合与生命周期](docs/skill-portfolio.md)
- [MCP 与 Plugin 策略](docs/mcp-plugin-policy.md)
- [新项目接入流程](docs/project-onboarding.md)
- [安全与维护](docs/security-and-maintenance.md)

## License

供个人学习和项目治理使用。引入第三方 Skill、模板或工具时，请分别检查其许可证与安全边界。
