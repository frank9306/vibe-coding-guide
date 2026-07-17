# Vibe Coding Governance

一套面向个人开发者的 Vibe Coding 治理标准与可安装配置。它先全局安装到用户的 Agent 环境；新建项目或在已有项目中应用时，Agent 再按照这套约定建立项目契约。

适用技术栈：Python CLI、Python 后端、Go 和前端。仓库提供治理原则、机器可读清单、标准规则、项目模板以及受控的 `project-bootstrap` Skill，不绑定具体模型或 IDE。

其中 [`vibe-standard.json`](vibe-standard.json) 是配置包清单，[`INSTALL.md`](INSTALL.md) 是 AI 安装契约。用户不需要逐篇阅读文档后再手工拼配置。

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
├── CLAUDE.md
├── INSTALL.md
├── README.md
├── vibe-standard.json
├── vibe-standard.schema.json
├── scripts/
│   ├── vibe.ps1
│   └── verify.ps1
├── docs/
│   ├── mcp-plugin-policy.md
│   ├── project-onboarding.md
│   ├── security-and-maintenance.md
│   └── skill-portfolio.md
├── skills/project-bootstrap/
│   ├── SKILL.md
│   └── references/stack-profiles.md
└── standard/
    ├── AGENTS.md
    └── project/
        ├── AGENTS.md
        └── CLAUDE.md
```

## 快速开始

### 推荐：对 AI 说一句话

在 Codex、Claude Code、OpenCode 或其他能够访问 Git 和本地文件的编码 Agent 中直接说：

```text
全局安装 https://github.com/frank9306/vibe-coding-guide 的 Vibe Coding 治理规范；
保留已有配置，不要修改任何项目，不要提交代码。
```

Agent 应先读取 [`vibe-standard.json`](vibe-standard.json)，再按照 [`INSTALL.md`](INSTALL.md) 的安装语义自动完成：

1. 检查当前用户环境。
2. 保留已有全局规则，缺少时才安装基础模板。
3. 用中文确认身份与称呼、默认语言和回复风格；用户也可以明确选择默认值。
4. 安装或安全更新 `project-bootstrap` Skill。
5. 通过门禁推荐 `tw93/Waza` 的核心 Skills，只有用户明确批准后才安装。
6. 报告全局安装结果，不读取或修改任何项目。

用户不需要先理解目录结构，也不需要手工执行安装命令。`vibe-standard.json` 分别声明全局 `install` 和项目 `apply`，`INSTALL.md` 定义两者的安全语义，`scripts/vibe.ps1` 是 AI 在 Windows 中可以选择调用的底层实现。

全局安装完成后，在新建项目或已有项目中明确告诉 Agent：

```text
在当前项目应用已安装的 Vibe Coding 治理规范；读取项目真实配置，
保留已有规则，不要安装依赖，不要提交代码。
```

### 手工安装与故障排查

只有 AI 无法访问 Git 或自动安装失败时，才需要在 Windows PowerShell 中执行：

```powershell
git clone https://github.com/frank9306/vibe-coding-guide.git
Set-Location vibe-coding-guide
.\scripts\vibe.ps1 install
```

`install` 会把 `project-bootstrap` 安装到 `~/.agents/skills/`。全局规则位置按当前 Agent 环境解析：存在 `CODEX_HOME` 时写入 `$CODEX_HOME/AGENTS.md`，否则回退到 `~/.agents/AGENTS.md`。仅当目标文件不存在时才安装精简模板；脚本不会安装依赖、Plugin 或 MCP，也不会覆盖已有文件。确实需要替换时使用 `-Force`，脚本会先创建带时间戳的备份。脚本完成后，AI 必须确认身份与称呼、默认语言和回复风格，展示差异并经确认后写入同一份全局 `AGENTS.md`。

个性化确认后，AI 会推荐以下第三方全局 Skills，但不会自动安装：

```powershell
npx skills add tw93/Waza --skill check --skill ui --skill health --skill hunt --skill learn --skill read --skill think --skill write -g
```

执行前必须展示来源、命令、Skill 列表和已有冲突，并获得用户明确批准。用户跳过不影响治理规范安装完成。

在需要治理的项目中执行：

```powershell
.\scripts\vibe.ps1 apply -Path E:\path\to\your-project
```

这会在目标项目缺少对应文件时添加 `AGENTS.md` 项目模板和只导入它的 `CLAUDE.md`。`init` 暂时作为兼容别名保留。然后在目标项目中告诉 Agent：

```text
使用 project-bootstrap 治理当前项目。读取现有代码、manifest、锁文件和 CI，
把 AGENTS.md 中的模板命令替换为真实命令；不要安装依赖，不要 commit。
```

完成后检查：

```powershell
.\scripts\vibe.ps1 doctor -Path E:\path\to\your-project
```

卸载只移除本仓库安装的 Skill，不删除全局或项目规则：

```powershell
.\scripts\vibe.ps1 uninstall
```

脚本面向当前 Windows 环境。其他系统仍可按照 `vibe-standard.json` 复制 `standard/` 和 `skills/project-bootstrap/`，有真实需求后再增加跨平台脚本。

### 建立个人全局规则

[`standard/AGENTS.md`](standard/AGENTS.md) 是唯一安装方式使用的英文全局基线。AI 安装时可以用中文访谈，但写入文件的规则统一整理成英文，中文名称、称呼和固定短语保持原样。用户必须确认以下个人偏好，也可以直接选择默认值：

- Agent 的身份、自称以及对用户的称呼。
- 默认回复语言和语言切换条件。
- 回复长度、语气、结构和不希望出现的表达。

个性化内容经用户确认后直接写入全局 `AGENTS.md`。全局层只保存跨项目长期成立的偏好、Git 与文件安全、修改原则和验证诚实性，不保存项目命令、机器路径、凭据或项目专属规则。

语言约定：全局和项目 `AGENTS.md`、Skills 以及可复用 Prompt 规则使用英文；README、安装说明和日常对话默认使用简体中文。规则文件使用英文不会改变最终回复语言，回复语言仍由全局规则和用户当前要求决定。

### 给项目添加规则

将 [`standard/project/AGENTS.md`](standard/project/AGENTS.md) 复制到目标仓库根目录并命名为 `AGENTS.md`，替换其中所有示例命令。Agent 指令里的每条验证命令都必须真实可执行。

需要 Claude Code 时，再复制 [`standard/project/CLAUDE.md`](standard/project/CLAUDE.md)。它只导入 `AGENTS.md`。

### 只保留核心 Skill 心智模型

日常只需要记住：

| 意图 | Skill |
|---|---|
| 需求与方案 | `think` |
| 界面设计 | `ui` |
| Bug 根因 | `hunt` |
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
- 不安装清单之外的第三方 Skill，不绕过来源、冲突、授权和验证门禁批量安装。
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
