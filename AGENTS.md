# Exoshell Agent Instructions | Exoshell 代理指令

## Overview | 概述

**English:**
Exoshell is a Claude Code plugin marketplace that provides a collection of development skills and plugins. The name combines "exoskeleton" and "shell" — just as lobsters shed their shells to grow, developers using Exoshell continuously upgrade their capabilities by adopting new AI-assisted workflows and Claude plugins.

**中文：**
Exoshell 是一个 Claude Code 插件市场，提供开发技能和插件集合。名字结合了"外骨骼"和"命令行环境"——正如龙虾通过蜕壳实现成长，使用 Exoshell 的开发者通过采用新的 AI 辅助工作流和 Claude 插件来持续升级自己的能力。

---

## Project Structure | 项目结构

```
exoshell/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace registry 市场注册表
├── plugins/
│   └── <plugin-name>/
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin metadata 插件元数据
│       ├── commands/             # Command definitions 命令定义
│       ├── skills/               # Skill implementations 技能实现
│       ├── hooks/                # Hook configurations 钩子配置
│       ├── scripts/              # Helper scripts 辅助脚本
│       └── README.md             # Plugin documentation 插件文档
└── README.md                     # Project documentation 项目文档
```

---

## Adding a New Plugin | 新增插件

When adding a new plugin, update these files in order:

新增插件时，按顺序更新以下文件：

### 1. Create plugin directory | 创建插件目录

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json
├── commands/
├── skills/
└── README.md
```

### 2. `plugins/<name>/.claude-plugin/plugin.json`

```json
{
  "name": "<plugin-name>",
  "description": "Plugin description",
  "author": {
    "name": "author-name",
    "email": "author@email.com"
  },
  "homepage": "https://github.com/...",
  "version": "1.0.0"
}
```

### 3. `.claude-plugin/marketplace.json`

Add entry to `plugins` array:

```json
{
  "name": "<plugin-name>",
  "description": "Plugin description with commands list",
  "version": "1.0.0",
  "author": {
    "name": "author-name",
    "email": "author@email.com"
  },
  "source": "./plugins/<plugin-name>",
  "category": "development",
  "strict": false
}
```

### 4. `README.md`

Add row to plugins table:

```markdown
| **<plugin-name>** | `wip` | Description | [README](./plugins/<plugin-name>/README.md) |
```

### 5. `plugins/<name>/README.md`

Document the plugin with:
- Overview and features
- Installation instructions
- Usage examples
- Directory structure

---

## Updating a Plugin | 更新插件

When updating an existing plugin:

更新现有插件时：

| Change 变更 | Files to Update 需更新的文件 |
|-------------|------------------------------|
| Version bump 版本更新 | `plugin.json`, `marketplace.json` |
| Description change 描述变更 | `plugin.json`, `marketplace.json`, `README.md` (root) |
| Status change 状态变更 | `README.md` (root) - update status column |
| Feature addition 功能新增 | `plugins/<name>/README.md`, possibly `marketplace.json` description |

---

## Plugin Status Values | 插件状态值

| Status | Meaning |
|--------|---------|
| `planned` | Planned, not yet started 已规划，尚未开始 |
| `wip` | Work in Progress 开发中 |
| `ready` | Ready to use 可以使用 |

---

## Commands | 命令

### Marketplace Management | 市场管理

```bash
# Add marketplace | 添加市场
/plugin marketplace add wquguru/exoshell

# Install plugin | 安装插件
/plugin install <plugin-name>@exoshell
```

---

## Patterns | 模式

**English:**
- Keep descriptions in sync across `plugin.json`, `marketplace.json`, and root `README.md`
- Use bilingual format: "English | 中文" for user-facing content
- Version numbers should match between `plugin.json` and `marketplace.json`
- Plugin `source` path in `marketplace.json` is relative to repo root

**中文：**
- 保持 `plugin.json`、`marketplace.json` 和根目录 `README.md` 中的描述同步
- 所有面向用户的内容使用双语格式："English | 中文"
- `plugin.json` 和 `marketplace.json` 中的版本号应保持一致
- `marketplace.json` 中的插件 `source` 路径相对于仓库根目录
