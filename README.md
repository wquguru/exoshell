# Exoshell🦞🐚

**Exoshell** (exoskeleton + shell) draws inspiration from Moltbot's origin story — the project that evolved from "Clawdbot" (a claw-wielding chatbot) to "Moltbot" (referencing a lobster's molting process). Just as lobsters shed their shells to grow, developers using Exoshell continuously upgrade their capabilities by adopting new AI-assisted workflows and Claude plugins. The name captures both the biological metaphor of growth through transformation and the technical reality of building a pluggable "shell" of development skills.

**Exoshell**（外骨骼 + 命令行环境）的灵感源自 Moltbot 的起源故事——这个项目从"Clawdbot"（挥舞钳子的聊天机器人）演化为"Moltbot"（指代龙虾的蜕壳过程）。正如龙虾通过蜕壳实现成长，使用 Exoshell 的开发者通过采用新的 AI 辅助工作流和 Claude 插件来持续升级自己的能力。这个名字既捕捉了"通过转变实现成长"的生物学隐喻，也体现了构建可插拔的开发技能"外壳"的技术现实。

---

## Methodology | 方法论

- [100+ Commits/Day, Solo Dev: How Moltbot(Prev. ClawdBot) Balances Product Roadmap & Development Speed](https://x.com/wquguru/status/2016909319154127282?s=20)
- [日均上百commit：Moltbot（Clawdbot）如何兼顾产品路线图和开发速度](https://x.com/wquguru/status/2016685995090153800?s=20)

---

## Installation | 安装

### Prerequisites | 前置条件

- [Claude Code CLI](https://claude.ai/code) installed | 已安装 Claude Code CLI

### Add Marketplace | 添加市场

```bash
/plugin marketplace add wquguru/exoshell
```

### Install Plugins | 安装插件

```bash
/plugin install <plugin-name>@exoshell
```

---

## Plugin Status | 插件状态

| Status | Description |
|--------|-------------|
| `planned` | Planned, not yet started ｜ 已规划，尚未开始 |
| `wip` | Work in Progress ｜ 开发中 |
| `ready` | Ready to use ｜ 可以使用 |

## Plugins | 插件列表

| Plugin | Status | Description | Docs |
|--------|--------|-------------|------|
| **ralph-loop-ryan** | `wip` | Ralph autonomous agent for iterative development with multi-PRD parallel support. Commands: `ralph prd`, `ralph prep`, `ralph run`, `ralph status`. | [README](./plugins/ralph-loop-ryan/README.md) |

---

## License | 许可证

MIT
