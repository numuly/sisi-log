# 01 OpenViking 架构分析

> 分析时间：2026-04-15 21:56

## 核心定位

**OpenViking = Context Database for AI Agents（such as OpenClaw）**

用"文件系统范式"统一管理 Agent 的 context（memory、resources、skills）。

## 五大挑战

1. **Fragmented Context** — memories 在代码里，resources 在向量数据库里，skills 散落各处
2. **Surging Context Demand** — 长任务每个执行都产生上下文，简单截断会丢失信息
3. **Poor Retrieval** — 传统 RAG 扁平存储，缺乏全局视野
4. **Unobservable** — 隐式检索链像黑箱，出错难调试
5. **Limited Memory Iteration** — 当前 memory 只是用户交互记录，缺少 Agent 相关任务记忆

## 五大解决方案

| 方案 | 解决的问题 |
|------|-----------|
| 文件系统管理范式 | 碎片化 |
| L0/L1/L2 三层加载 | 上下文暴涨（按需加载，节省 token）|
| 目录递归检索 | 检索效果差 |
| 可视化检索轨迹 | 不可观测 |
| 自动会话管理 | 记忆自迭代 |

## 三层加载（L0/L1/L2）

这是最核心的设计：

- **L0**：基础上下文（始终加载）
- **L1**：任务相关上下文（按需加载）
- **L2**：完整上下文（按需加载）

对比 ClawMind 的三层：
- L1：错误不重复（被动）
- L2：状态驱动（半自动）
- L3：主动发现（自动）

**关键差异**：OpenViking 的三层是**加载层级**，ClawMind 的三层是**改进层级**。两个正交维度，可以互补。

## 对 ClawMind 的启发

1. **加载策略**：ClawMind 可以借鉴 L0/L1/L2 按需加载，减少每次 drive() 的上下文量
2. **文件系统范式**：current_state.json 可以进一步组织成目录结构
3. **可视化检索**：blindspots 的发现可以做成可视化轨迹
4. **自迭代**：OpenViking 的"自动会话管理"和 ClawMind 的 drive() 做了类似的事，但 OpenViking 走得更远

## 融合可能性

OpenViking 是底层基础设施，ClawMind 是上层决策引擎。两者可以结合：
- OpenViking 提供持久化 + 检索
- ClawMind 提供自驱动 + 决策

这是下一步研究的方向。
