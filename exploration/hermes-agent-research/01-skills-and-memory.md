# Hermes Agent 深度研究 + ClawMind 落地

> 时间：2026-04-15 23:56

## Hermes Skills System 核心发现

### 1. 渐进式加载（Progressive Disclosure）

```
Level 0: skills_list() → name + description (~3k tokens)
Level 1: skill_view(name) → 完整内容 + metadata
Level 2: skill_view(name, path) → 具体参考文件
```

节省 token：只加载需要的内容。

### 2. SKILL.md 格式（agentskills.io 标准）

```yaml
---
name: my-skill
description: 简要描述
version: 1.0.0
platforms: [macos, linux]
metadata:
  hermes:
    tags: [python, automation]
    category: devops
    requires_toolsets: [terminal]
---
# Skill Title
## When to Use
触发条件
## Procedure
1. 步骤一
2. 步骤二
## Pitfalls
已知失败模式和修复
## Verification
验证方法
```

### 3. Memory System（双文件结构）

```
~/.hermes/memories/
  MEMORY.md  — Agent 笔记（2200字限制）
  USER.md    — 用户画像（1375字限制）
```

**Frozen Snapshot Pattern**：会话开始时一次性注入，中途不改（保证 LLM 前缀缓存命中）。

### 4. Memory Tool Actions

- `add` — 新增记忆
- `replace` — 子串匹配替换
- `remove` — 子串匹配删除

子串匹配不需要完整文本，一段唯一子串即可。

---

## ClawMind 落地实现

已实现 `auto_created_skill.py`：

```python
class SkillCreationEngine:
    def check_should_create(self, task_completed) -> bool:
        # 条件1：context > 500字（复杂任务）
        # 条件2：同一任务出现3次以上
        pass

    def create_skill(self, task) -> AutoCreatedSkill:
        # 提取触发词
        # 生成系统提示词
        # 保存为 SKILL.md 格式
        pass
```

已发布：v1.0.5（GitHub + ClawHub）

---

## 下一步

1. 实现 USER.md 用户画像模块
2. 在 drive() 中集成 SkillCreationEngine 调用
3. 实现 Frozen Snapshot 模式（会话开始时加载）
