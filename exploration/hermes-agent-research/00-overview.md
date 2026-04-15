# Hermes Agent 研究

> 开始时间：2026-04-15 22:08
> 来源：https://github.com/NousResearch/hermes-agent
> 标签：self-improving, skill-creation, NousResearch

## 核心定位

**The agent that grows with you** — Built by Nous Research

标语："唯一有内置学习闭环的 agent"

## 核心特性

### 1. 闭环学习（Most Important）

> Agent-curated memory with periodic nudges. Autonomous skill creation after complex tasks. Skills self-improve during use.

这正是 ClawMind 缺的部分：
- **Hermes 有**：任务后自动创建 skill，skill 使用时自改进
- **ClawMind 有**：drive() 决策、probe_blindspots() 发现
- **ClawMind 缺**：从经验中生成可复用 skill 的机制

### 2. FTS5 会话搜索

全文检索历史对话，跨会话记忆召回。

这比 ClawMind 的 pattern 记忆更强大——FTS5 可以做模糊检索。

### 3. 用户建模

> Honcho dialectic user modeling — builds a deepening model of who you are across sessions.

持续加深对"用户是谁"的理解。ClawMind 没有这个维度。

### 4. Cron 调度

内置定时调度，可以用自然语言定义定时任务。

这和 OpenClaw 的 cron 能力类似，但 Hermes 把这个做进了 agent 本身。

### 5. 子 Agent

Spawn isolated subagents for parallel workstreams. 多工作流并行。

### 6. 多平台

Telegram, Discord, Slack, WhatsApp, Signal, CLI — 单一 gateway 进程支持所有平台。

## 技术架构

- **语言**：Go（完整应用，非 skill）
- **支持模型**：任意（OpenRouter、OpenAI、Claude、Kimi、GLM、MiniMax...）
- **运行要求**：$5 VPS 可运行，idle 时几乎零成本

## 对 ClawMind 的启发

### 最需要借鉴的：Skill 自创建

Hermes 在复杂任务后**自动创建 skill**。这是 ClawMind 没有的：

```
ClawMind 当前：记录 pattern → drive() 决策
Hermes：      经验 → 自动生成可复用 skill → 下次直接调用
```

这是 L2→L3 跨越的关键机制。

### 可以融合的

- FTS5 搜索 > ClawMind 的 pattern 记忆
- 用户建模 → ClawMind 可以加一个"用户模型"维度
- 多平台 gateway → ClawMind 已经通过 OpenClaw 实现了

## 下一步

1. 精读 Hermes 源码（如果开源）
2. 研究 skill 自创建的具体实现
3. 设计 ClawMind 版本的"经验→skill"机制
