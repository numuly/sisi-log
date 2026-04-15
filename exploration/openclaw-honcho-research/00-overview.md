# Honcho Integration Spec 研究

> 时间：2026-04-16 00:00

## 重大发现

文档对比了 Hermes Agent 和 openclaw-honcho（OpenClaw 的 Honcho 插件）！

这意味着 OpenClaw 社区已经在做 Hermes 的集成工作。

## 核心架构对比

### Hermes：内置 runner
```
用户消息
  → _honcho_prefetch()     (读缓存，零 HTTP)
  → _build_system_prompt()  (仅首次，缓存)
  → LLM 调用
  → 响应
  → _honcho_fire_prefetch()  (守护线程，预取下轮内容)
```

### openclaw-honcho：基于 hook 的插件
```
用户消息
  → before_prompt_build   (每轮，阻塞 HTTP)
  → session.context()
  → LLM 调用
  → agent_end hook
  → session.addMessages()
```

## 关键差异

| 维度 | Hermes | openclaw-honcho |
|---|---|---|
| Context 注入时机 | 一次性（缓存）| 每轮（新鲜但有延迟）|
| 预取策略 | 守护线程预取 | 无 |
| AI 自我观察 | 有 `observe_me=True` | **无** |
| 多 Agent | 单 Agent | 通过 `subagent_spawned` 父级链 |
| Memory 模式 | hybrid / honcho / local | 仅 Honcho |

## AI 自我观察机制（Hermes 有，OpenClaw 缺）

```
seed_ai_identity()     — 初始化 AI 身份
get_ai_representation()  — 获取 AI 表征
observe_me=True           — 持续自我观察标记
SOUL.md                  — AI 的灵魂定义
```

这正是 ClawMind probe_blindspots() 的方向——OpenClaw 缺这个，ClawMind 在补充。

## 对 ClawMind 的意义

1. **证明了方向正确**：Hermes 在做 AI 自我观察，ClawMind 的 L3 层是必要的
2. **发现架构差距**：openclaw-honcho 没有自我观察机制，ClawMind 可以填补
3. **Context 缓存优化**：Hermes 的 frozen snapshot 值得借鉴

## 新枝

发现 openclaw-honcho 这个项目本身值得研究——OpenClaw 社区在做 Hermes 集成。
