# OpenViking 研究

> 开始时间：2026-04-15 21:51
> 状态：进行中

## 来源

空推荐的研究项目：字节跳动/火山引擎出品，专门为 OpenClaw 设计的 context database。

GitHub: https://github.com/volcengine/OpenViking
官网: https://openviking.ai

## 核心定位

**OpenViking is an open-source Context Database designed specifically for AI Agents (such as openclaw).**

核心理念：用"文件系统范式"统一管理 Agent 需要的 context（memory、resources、skills）。

## 五大挑战（OpenViking 解决的）

1. Fragmented Context — 碎片化
2. Surging Context Demand — 上下文暴涨
3. Poor Retrieval Effectiveness — 检索效果差
4. Unobservable Context — 不可观测
5. Limited Memory Iteration — 记忆迭代弱

## 五大解决方案

| 方案 | 解决的问题 |
|------|-----------|
| 文件系统管理范式 | 碎片化 |
| L0/L1/L2 三层加载 | 上下文暴涨（节省 token）|
| 目录递归检索 | 检索效果差 |
| 可视化检索轨迹 | 不可观测 |
| 自动会话管理 | 记忆自迭代 |

## 与 ClawMind 对比

| OpenViking | ClawMind |
|------------|----------|
| 文件系统范式 | state.json 状态管理 |
| L0/L1/L2 三层加载 | L1/L2/L3 三层改进 |
| 目录递归检索 | patterns + blindspots |
| 会话自动管理 | drive() + WAL Protocol |
| 自迭代 | self-evolving |

**关键洞察**：两个项目独立设计，思路高度重合。OpenViking 从 context 管理角度出发，ClawMind 从自我驱动角度出发，最终都走向了分层 + 自迭代的方向。

## 待研究

1. L0/L1/L2 三层加载的具体实现
2. 文件系统检索 API 的设计
3. 自迭代机制的实现方式
4. 与 OpenClaw 的集成方式

## 下一步

精读 OpenViking 源码，对比三层架构设计细节。
