# OpenClaw Honcho Plugin 研究

> 时间：2026-04-16 00:12

## 两个重要仓库

1. **plastic-labs/openclaw-honcho**（55 ⭐，TypeScript）
   - OpenClaw 官方 Honcho 集成插件
   - honcho.dev 云服务，需要 API key
   - Slot 系统（kind: "memory"）替换内置 memory 插件

2. **ashneil12/openclaw-honcho-multiagent**（分叉）
   - 在上游基础上添加多 agent 支持
   - 关键 patches：session key hardening、richer content parsing

## Honcho 核心概念

- **Peer Paradigm**：两个分离的模型（用户 + Agent）
- **Dialectic Reasoning**：辩证推理，让对话随时间改进
- **云服务**：依赖 honcho.dev API（不同于 Hermes 的纯本地方案）

## 两种集成架构

### Hermes（内置）
```
Runner 内置 Honcho
数据存在 ~/.hermes/
无外部依赖
```

### OpenClaw（插件）
```
OpenClaw（事件总线）
    ↓ hooks
plastic-labs/openclaw-honcho
    ↓ HTTP API
honcho.dev 云服务
```

## 关键差异

| 维度 | Hermes Honcho | OpenClaw Honcho |
|---|---|---|
| 架构 | 内置 runner | 插件 + 云 API |
| 数据存储 | 本地 | Honcho 云 |
| 外部依赖 | 无 | 需要 API key |
| 多 agent | 单 agent | 支持（multiagent fork）|
| AI 自我观察 | 有 | 无 |

## 对 ClawMind 的意义

ClawMind 当前：本地 JSON 文件存储（`memory/`、`MEMORY.md`）
Honcho：云端 AI-native memory（peer 模型 + dialectic reasoning）

**不是非此即彼**，而是：
- ClawMind 的 drive() + 经验记忆（本地，快速）
- Honcho 的 dialectic reasoning（云端，AI 增强推理）

长期来看可以结合。
