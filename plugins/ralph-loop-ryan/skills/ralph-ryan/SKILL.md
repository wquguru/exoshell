---
name: ralph-ryan
description: "Ralph autonomous agent for iterative development with multi-PRD parallel support. Commands: 'ralph prd' (create PRD), 'ralph prep' (prepare), 'ralph run' (execute), 'ralph status' (overview). Triggers on: ralph prd, ralph prep, ralph run, ralph go, ralph status."
---

# Ralph Agent

Autonomous coding agent that implements user stories iteratively with **multi-PRD parallel development** support.

---

## Routing

Based on user intent, load the corresponding instruction file:

| Intent | Keywords | Action |
|--------|----------|--------|
| **PRD** | prd, create, generate, plan | Read `{baseDir}/prd.md` |
| **Prep** | prep, prepare, convert, setup | Read `{baseDir}/prep.md` |
| **Run** | run, execute, go, start | Read `{baseDir}/run.md` |
| **Status** | status, list, overview | Read `{baseDir}/status.md` |

---

## Directory Structure (Multi-PRD)

```
.claude/ralph-ryan/
├── prd-06-risk-management/          # PRD 子目录
│   ├── prd.md                       # PRD 文档
│   ├── prd.json                     # 结构化数据
│   ├── progress.txt                 # 进度日志
│   └── lock.json                    # 执行锁 (可选)
├── prd-07-model-governance/
│   ├── prd.md
│   ├── prd.json
│   ├── progress.txt
│   └── lock.json
└── ...

.claude/ralph-ryan-archived/         # 已完成的 PRD
└── 2026-01-29-prd-06-risk-management/
```

**命名规范**: `prd-<slug>` 或 `<descriptive-name>`，使用 kebab-case

---

## Shared Configuration

| Item | Path |
|------|------|
| Working directory | `.claude/ralph-ryan/` |
| PRD 子目录 | `.claude/ralph-ryan/<prd-slug>/` |
| PRD markdown | `.claude/ralph-ryan/<prd-slug>/prd.md` |
| PRD JSON | `.claude/ralph-ryan/<prd-slug>/prd.json` |
| Progress log | `.claude/ralph-ryan/<prd-slug>/progress.txt` |
| Lock file | `.claude/ralph-ryan/<prd-slug>/lock.json` |
| Archived runs | `.claude/ralph-ryan-archived/<date>-<prd-slug>/` |

---

## Quick Reference

```bash
# 查看所有 PRD 状态
/ralph-ryan status

# 创建新 PRD (会询问 slug 名称)
/ralph-ryan prd [describe your feature]

# 准备执行 (会列出可选 PRD)
/ralph-ryan prep

# 执行 (会列出可选 PRD)
/ralph-loop:ralph-loop "Load skill ralph-ryan and execute run mode." --max-iterations 10 --completion-promise COMPLETE
```

IMPORTANT NOTE: there are two `ralph-loop` in the command `/ralph-loop:ralph-loop`, don't trim it.

---

## Lock Mechanism

防止同一 PRD 被多个 agent 同时执行：

```json
// lock.json
{
  "lockedBy": "agent-session-id",
  "lockedAt": "2026-01-29T10:30:00Z",
  "storyId": "US-003"
}
```

- Run 模式开始时创建 lock
- 完成 story 后释放 lock
- 超过 30 分钟的 lock 视为过期，可被覆盖

---

## File Tracking

每个 story 完成后，在 prd.json 中记录修改的文件：

```json
{
  "id": "US-003",
  "passes": true,
  "filesChanged": [
    "app/risk/greeks/page.tsx",
    "components/charts/greeks-heatmap.tsx"
  ]
}
```

用于：
1. 精准 commit（只提交相关文件）
2. 冲突检测（多 PRD 修改同一文件时预警）
