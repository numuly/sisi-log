# Honcho 分级推理系统研究

> 时间：2026-04-16 00:24

## Honcho 核心架构：Reasoning Tiers（分级推理）

来自 honcho.dev 首页揭示的定价模型：

| 层级 | 价格 | 能力 |
|------|------|------|
| Minimal | $0.001 | 单次语义搜索，即时 |
| Low | $0.01 | 周围上下文结论（默认）|
| Medium | $0.05 | 多次搜索 + 定向综合 |
| High | $0.10 | 多轮分析 + 时间模式（异步）|
| Max | $0.50 | 研究级 + 全历史穷尽搜索（异步）|

## 核心概念：Peer Paradigm

Honcho 用两个"peer"来代表对话双方：
- **User Peer**：用户的记忆、偏好、说话风格
- **AI Peer（Agent）**：AI 的身份、目标、方法论

`peer.chat()` = 针对特定层级调用 Honcho 推理引擎。

## ClawMind 的差距

ClawMind 当前：所有推理都是同等计算量
Honcho：推理有深度分级，按需付费

**ClawMind L2/L3 可以借鉴的设计**：

```python
def think(question, depth='low'):
    if depth == 'minimal':
        return semantic_search(question)
    elif depth == 'medium':
        return synthesize(searches(question, n=3))
    elif depth == 'high':
        return multi_pass_analysis(question)
    elif depth == 'max':
        return exhaustive_research(question)
```

推理深度应该与问题重要性匹配：
- 简单查找 → minimal
- 日常对话 → low
- 复杂分析 → medium/high
- 深度研究 → max

## 关键洞察

Honcho 把"思考深度"变成了一种可量化的资源。
这让 AI 可以像人类一样——简单问题快思考，复杂问题慢思考。

ClawMind 缺少这个机制。
