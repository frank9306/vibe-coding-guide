# Vibe Coding Governance Installation Contract

本文档供编码 Agent 执行，不是要求用户手工完成的操作清单。

## 用户触发语句

当用户表达以下意图时执行本协议：

```text
全局安装 https://github.com/frank9306/vibe-coding-guide 的 Vibe Coding 治理规范；保留已有配置，不要修改任何项目，不要提交代码。
```

语义相同的自然语言请求也视为触发。

安装完成后，如需在新建项目或已有项目中应用规范，使用独立请求：

```text
在当前项目应用已安装的 Vibe Coding 治理规范；读取项目真实配置，保留已有规则，不要提交代码。
```

## 目标

完成全局安装后，当前用户环境具有一份经过个性化确认的全局规则和 `project-bootstrap` Skill。仓库只提供这一种安装方式，不区分普通安装与个人安装。安装过程不要求位于项目中，也不创建或修改任何项目文件。

项目应用是安装后的独立动作。应用完成后，目标项目具有真实、简洁且可执行的 `AGENTS.md`；需要兼容 Claude Code 时，存在只导入 `AGENTS.md` 的 `CLAUDE.md`。

安装前先读取根目录的 `vibe-standard.json`。它是本标准的机器可读清单；本文解释执行语义。清单与本文冲突时停止安装并报告，不要自行猜测。

## 安装规则

1. 按 `vibe-standard.json` 的 `install` 清单定位全局规则和 Skill；不要从其他来源拼装同名文件。
2. 检查 `~/.agents/AGENTS.md`：
   - 不存在时，安装清单声明的 `standard/AGENTS.md`。
   - 已存在时，保留原文件，只检查是否缺少安全和验证底线。
   - 需要合并时先展示拟增加内容，不静默覆盖。
3. 根据 `install.globalInstructions.personalization` 完成个性化确认：
   - 询问身份与称呼、默认语言和回复风格；用户不想定制时可以明确选择模板默认值。
   - 将偏好整理成明确、无重复、可长期执行的规则，不保存聊天原文。
   - 用户可以用中文回答，但写入 `AGENTS.md` 的规则必须使用英文；名称、称呼和指定短语作为引号中的字面值原样保留。
   - 写入前展示最终内容或差异；目标文件已存在时必须获得合并或覆盖授权。
   - 不把项目命令、机器路径、账号、凭据、私有端点或项目专属规则写入全局文件。
4. 检查 `~/.agents/skills/project-bootstrap/`：
   - 不存在时，从 `skills/project-bootstrap/` 安装。
   - 已存在时比较内容；相同则跳过，不同则先备份再更新。
5. 执行推荐 Skills 门禁，按 `install.recommendedSkills` 展示来源、完整命令和 Skill 列表：
   - 先检查同名 Skill 是否已存在以及是否冲突，不静默替换已有 Skill。
   - 明确说明这些是来自 `tw93/Waza` 的第三方全局 Skill，不属于本仓库的必装内容。
   - 只有用户明确批准后，才执行清单声明的命令；仅安装本清单列出的 Skill。
   - 用户拒绝或跳过时，治理规范安装仍然成功，不重复劝说。
   - 执行后验证每个 Skill 可被发现，并报告成功、跳过和失败项。
6. 全局安装到此结束，不检查、创建或修改当前目录中的项目文件。

## 个性化提问

唯一安装流程必须经过个性化确认，并允许用户直接回答“使用默认值”。推荐合并成一个简短问题：

```text
是否要设置全局个人偏好？可以告诉我：Agent 的名称和对你的称呼、默认回复语言、希望的回复风格；也可以说“使用默认值”。
```

如果用户提供的信息有歧义，只追问会改变最终规则的部分。个性化内容是全局 `AGENTS.md` 的一部分，不单独创建隐式配置文件。

## 指令语言门禁

- 全局和项目 `AGENTS.md`、Skills 及可复用 Prompt 规则使用英文，便于跨 Agent 兼容和复用。
- README、安装说明以及用户交互默认使用简体中文。
- “规则使用英文”不等于“回复使用英文”；最终回复语言由 `AGENTS.md` 的 `Language` 规则和用户当前要求决定。
- 个性化合并完成后，检查新增规则是否为英文，并确认中文名称、称呼和固定短语没有被翻译或改写。

## 推荐 Skills 门禁

个性化规则确认后，Agent 可以推荐以下全局 Skills：`check`、`ui`、`health`、`hunt`、`learn`、`read`、`think`、`write`。

执行前必须原样展示命令并获得明确批准：

```powershell
npx skills add tw93/Waza --skill check --skill ui --skill health --skill hunt --skill learn --skill read --skill think --skill write -g
```

这是第三方网络安装命令，会调用本机 Node.js/npm 环境并写入全局 Skills 目录。缺少 Node.js、npm 或网络时只报告阻塞，不自动安装运行时，不改用其他远程安装方式。

## 项目应用规则

只有用户明确要求新建项目或在某个项目中应用规范时，才执行以下步骤：

1. 确认目标项目绝对路径并检查 Git 状态。
2. 按 `vibe-standard.json` 的 `apply.projectFiles` 定位项目契约模板。
3. 检查目标项目：
   - 已有 `AGENTS.md` 时保留并增量整理，不用模板覆盖。
   - 没有时以清单声明的 `standard/project/AGENTS.md` 为起点。
   - 读取 README、manifest、锁文件、CI 和主要目录，把模板命令替换成真实命令。
   - 只写项目真实存在的安装、开发、验证和构建命令。
4. 如果用户使用 Claude Code，确保项目 `CLAUDE.md` 导入 `AGENTS.md`；已有大量 Claude 专属规则时不要覆盖，改为消除重复内容。
5. 不自动安装其他 Skill、Plugin、MCP、运行时、包管理器或项目依赖；全局推荐 Skills 只在安装阶段通过上述门禁并获得批准后安装。
6. 不执行 commit、push、发布、migration、认证修改或数据删除，除非用户在当前请求中明确授权。

## 推荐执行方式

在 Windows 环境，Agent 可以调用仓库自带脚本完成无覆盖安装：

```powershell
.\scripts\vibe.ps1 install
```

需要应用到具体项目时，再独立执行：

```powershell
.\scripts\vibe.ps1 apply -Path <absolute-project-path>
```

`apply` 只复制缺失的基础文件。调用后，Agent 仍必须读取目标项目并把 `AGENTS.md` 模板转换为真实项目规则。`init` 暂时作为 `apply` 的兼容别名保留。

`install` 脚本只负责安全复制基线，不能代替 AI 完成个性化确认或第三方 Skills 门禁。脚本执行后，Agent 应继续按本契约整理全局 `AGENTS.md`，再询问是否安装推荐 Skills。

在其他系统，Agent 可以执行等价的安全文件操作，但必须遵守相同的跳过、备份和授权规则。

## 验收

Agent 完成前必须检查：

- 全局现有配置没有被静默覆盖。
- 用户提供的个性化偏好已准确写入，或明确选择使用默认值；没有未经确认的第二种安装模式。
- 全局规则不包含项目专属信息、凭据或机器私有信息。
- 全局规则使用英文，默认回复语言仍为简体中文；个性化字面值保持原样。
- 推荐 Skills 未经批准没有安装；批准安装时，来源、命令、列表和验证结果均已报告。
- `project-bootstrap/SKILL.md` frontmatter 有效。
- 全局安装没有创建或修改项目文件。

执行项目应用时还必须检查：目标项目 `AGENTS.md` 不含占位符或虚构命令，文件引用和验证命令可以解析，`CLAUDE.md` 不重复维护规则，Git diff 只包含治理所需变更。

## 交付报告

向用户说明：

- 安装或跳过了哪些全局文件。
- 如果执行了项目应用，说明目标项目新增或修改了哪些规则，以及检测到的技术栈和验证命令。
- 实际运行的检查及结果。
- 哪些动作因需要授权而没有执行。
