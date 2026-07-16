# Vibe Coding Governance Installation Contract

本文档供编码 Agent 执行，不是要求用户手工完成的操作清单。

## 用户触发语句

当用户表达以下意图时执行本协议：

```text
安装 https://github.com/frank9306/vibe-coding-guide 的 Vibe Coding 治理规范，并治理当前项目；保留已有配置，不要提交代码。
```

语义相同的自然语言请求也视为触发。

## 目标

完成后，当前环境具有 `project-bootstrap` Skill，当前项目具有真实、简洁且可执行的 `AGENTS.md`；需要兼容 Claude Code 时存在只导入 `AGENTS.md` 的 `CLAUDE.md`。

安装前先读取根目录的 `vibe-standard.json`。它是本标准的机器可读清单；本文解释执行语义。清单与本文冲突时停止安装并报告，不要自行猜测。

## 安装规则

1. 确认用户所说的“当前项目”绝对路径，并检查 Git 状态。
2. 按 `vibe-standard.json` 的 `install` 清单定位全局规则、项目文件和 Skill；不要从其他来源拼装同名文件。
3. 检查 `~/.agents/AGENTS.md`：
   - 不存在时，安装清单声明的 `standard/AGENTS.md`。
   - 已存在时，保留原文件，只检查是否缺少安全和验证底线。
   - 需要合并时先展示拟增加内容，不静默覆盖。
4. 检查 `~/.agents/skills/project-bootstrap/`：
   - 不存在时，从 `skills/project-bootstrap/` 安装。
   - 已存在时比较内容；相同则跳过，不同则先备份再更新。
5. 检查当前项目：
   - 已有 `AGENTS.md` 时保留并增量整理，不用模板覆盖。
   - 没有时以清单声明的 `standard/project/AGENTS.md` 为起点。
   - 读取 README、manifest、锁文件、CI 和主要目录，把模板命令替换成真实命令。
   - 只写项目真实存在的安装、开发、验证和构建命令。
6. 如果用户使用 Claude Code，确保项目 `CLAUDE.md` 导入 `AGENTS.md`；已有大量 Claude 专属规则时不要覆盖，改为消除重复内容。
7. 不自动安装其他 Skill、Plugin、MCP、运行时、包管理器或项目依赖。
8. 不执行 commit、push、发布、migration、认证修改或数据删除，除非用户在当前请求中明确授权。

## 推荐执行方式

在 Windows 环境，Agent 可以调用仓库自带脚本完成无覆盖安装：

```powershell
.\scripts\vibe.ps1 install
.\scripts\vibe.ps1 init -Path <absolute-project-path>
```

脚本只是复制基础文件。调用后，Agent 仍必须读取当前项目并把 `AGENTS.md` 模板转换为真实项目规则。

在其他系统，Agent 可以执行等价的安全文件操作，但必须遵守相同的跳过、备份和授权规则。

## 验收

Agent 完成前必须检查：

- 全局现有配置没有被静默覆盖。
- `project-bootstrap/SKILL.md` frontmatter 有效。
- 当前项目 `AGENTS.md` 不包含 `replace with`、`TODO` 或虚构命令。
- `AGENTS.md` 中的文件引用和验证命令可以解析。
- `CLAUDE.md` 与 `AGENTS.md` 没有重复维护同一批规则。
- Git diff 只包含治理所需变更。

## 交付报告

向用户说明：

- 安装或跳过了哪些全局文件。
- 当前项目新增或修改了哪些规则。
- 检测到的项目技术栈和验证命令。
- 实际运行的检查及结果。
- 哪些动作因需要授权而没有执行。
