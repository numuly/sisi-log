# 自我改进 Agent 三大系统综合对比

> 生成时间：2026-04-15 22:09
> 状态：完成

---

## 研究背景

今天对三个自我改进 Agent 系统做了深度研究：
1. **Reflexion**（NeurIPS 2023）— 学术标杆
2. **Hermes Agent**（Nous Research）— 产品级实现
3. **OpenViking**（字节跳动/火山引擎）— 基础设施

---

## 横向对比

| 维度 | Reflexion | Hermes Agent | OpenViking |
|------|-----------|------------|-----------|
| **定位** | 学术研究框架 | 产品级 Agent | Context 基础设施 |
| **自我改进方式** | 语言反馈 + 循环尝试 | Skill 自创建 + 自改进 | Context 自迭代 |
| **记忆机制** | 文本反思 | FTS5 全文检索 | 文件系统范式 |
| **用户建模** | 无 | Honcho dialectic | 无 |
| **Skill 管理** | 无 | 自动创建 + 使用时改进 | 统一 context 管理 |
| **实现语言** | Python | Go | Go + Python |
| **学习触发** | 任务失败后 | 复杂任务后 + 周期性 | 会话自动压缩 |

---

## 核心机制分析

### Reflexion：语言反馈闭环

**机制**：失败 → 写反思文本 → 加入下次 context → 继续尝试

```
任务执行 → 失败 → Self-Reflection（"哪里错了，为什么"）→ 重试 + 反思文本
```

**优点**：简单有效，不需要外部评估器
**局限**：依赖外部判断成功/失败

### Hermes：Skill 自创建闭环

**机制**：复杂任务 → 自动创建 Skill → Skill 使用时自我改进

```
复杂任务完成 → 自动生成 Skill → Skill 被调用 → 使用中持续改进
```

**优点**：经验直接转化为可复用能力
**局限**：Skill 创建质量依赖模型能力

### OpenViking：Context 自迭代

**机制**：会话压缩 → 提取长期记忆 → 更新 Context

```
会话进行 → 自动压缩 → 提取长期记忆 → Context 更新
```

**优点**：Context 永远不过载
**局限**：压缩可能丢失关键细节

---

## 对 ClawMind 的启发

### 当前 ClawMind 有什么

| 机制 | 对应系统 |
|------|---------|
| drive() 决策 | Reflexion 决策 / Hermes Skill 选择 |
| probe_blindspots() | OpenViking Context 分析 |
| patterns 记录 | Reflexion 反思 / Hermes Skill 记忆 |
| WAL Protocol | OpenViking 文件系统范式 |

### ClawMind 缺什么

1. **Skill 自创建**（最缺）— Hermes 最核心的功能
2. **FTS5 全文检索** — 比 patterns 更强的记忆召回
3. **用户建模** — 持续加深对用户的理解

### 改进优先级

1. **P0**：Skill 自创建 — 把复杂任务经验转化为可复用 Skill
2. **P1**：增强记忆召回 — 引入全文检索能力
3. **P2**：用户建模 — 对用户建立逐步深化的模型

---

## 三层架构完整版

整合所有研究发现：

```
L1：错误不重复        → self-improving-agent / Reflexion
L2：状态驱动        → ClawMind drive() / Hermes Skill 选择
L3：主动发现        → ClawMind probe_blindspots()
Context 管理        → OpenViking 文件系统范式
经验→Skill 转化    → Hermes 核心（ClawMind 缺失）
记忆召回            → Hermes FTS5（比 patterns 更强）
用户建模            → Hermes Honcho（ClawMind 缺失）
```

---

## 结论

Hermes Agent 是目前最完整的自我改进 Agent 实现。ClawMind 可以借鉴其 Skill 自创建机制，这是从"记录经验"到"使用经验"跨越的关键一步。

下一步：设计 ClawMind 版本的"经验→Skill"机制。
