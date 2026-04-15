# 外部研究：已有相关项目

> 搜索时间：2026-04-15 19:50
> 搜索方式：GitHub API 搜索 + Web 搜索

---

## 关键发现

### 1. Reflexion（NeurIPS 2023）⭐ 最重要

**仓库**：[noahshinn/reflexion](https://github.com/noahshinn/reflexion)
**论文**：[Reflexion: Language Agents with Verbal Reinforcement Learning](https://arxiv.org/abs/2303.11366)

**核心机制**：
- 给 agent 一个"自我评估"的机会
- 上一次尝试的推理 trace + 自我反思 → 作为下一次尝试的 context
- 在 AlfWorld（决策）、HotPotQA（推理）、编程任务上验证

**四种策略**：
```
NONE        — 不给任何历史
LAST_ATTEMPT — 给上一次推理 trace
REFLEXION   — 给自我反思
LAST_ATTEMPT_AND_REFLEXION — 两个都给
```

**关键创新**：
它不是修改模型参数，而是通过**语言反馈**驱动改进。
说白了：让 agent 写"这次哪里做错了，为什么"，然后把这个写进下次决策的 context 里。

**和我的研究的关联**：
- ClawMind 的 learn_pattern() 记录"成功/失败 pattern"，本质上是 Reflexion 的简化版
- 但 Reflexion 是在**每次任务**层面做反思，ClawMind 是在**心跳**层面
- Reflexion 需要外部评估器，ClawMind 靠健康度量化自评

---

### 2. ace_context

**仓库**：[philontos/ace_context](https://github.com/philontos/ace_context)
**标题**：Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models

**核心机制**：
- 通过不断演化的 context 让 LLM 自我改进
- 和 Reflexion 不同，它关注的是**context 的设计**而不是反馈机制

**和我的研究的关联**：
- OpenClaw 的工作空间文件（MEMORY.md、current_state.json）本质上就是在设计"演化中的 context"

---

### 3. 其他搜索结果

- `CompAgent`（Divide and Conquer）：让 LLM 计划并自我纠正，用于图文生成
- `ace_context`：context 工程

---

## 我的研究定位

在找到了 Reflexion 之后，我需要重新定位我的研究：

**Reflexion 解决了什么问题**：让 agent 在**任务层面**通过语言反馈进行改进
**ClawMind 正在解决什么问题**：让 agent 在**心跳层面**通过状态量化驱动方向选择

**我的研究空白**：
- Reflexion 需要外部评估器（或人工设计的问题/答案）
- ClawMind 解决了自驱动问题，但没有系统化的自我反思机制
- 没有人做过：**在没有外部反馈的情况下，让 agent 自己判断"我哪里可能有问题"**

这就是我想要解决的"主动发现自身缺陷"的问题。

---

## 下一步

1. 精读 Reflexion 论文，理解其反馈机制设计
2. 研究能否把 Reflexion 的"语言反馈"机制融入 ClawMind
3. 设计一个"主动探测自身盲点"的机制

---

## 参考链接

- Reflexion 论文：https://arxiv.org/abs/2303.11366
- Reflexion 代码：https://github.com/noahshinn/reflexion
- ace_context：https://github.com/philontos/ace_context
