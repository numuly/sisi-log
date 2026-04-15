# AgentHandover OpenClaw 集成发现

> 时间：2026-04-16 02:15

## 重大发现：AgentHandover 已有 OpenClaw 集成

`openclaw_writer.py` — 专门为 OpenClaw 写的 Skill 写入器！

### 写入位置

```
~/.openclaw/workspace/memory/apprentice/
  sops/               # SOP 文件（AgentHandover 学到的流程）
    archive/          # 归档旧版本
  metadata/           # 置信度日志、episode 统计
```

### 写入策略：Learning-only

> "Learning-only policy: only writes to memory/apprentice/ subtree.
> Never registers action tools or executes commands."

只写内存区域，不执行任何操作。安全。

### SOP 格式（v3）

```yaml
## 基础信息
title: xxx
trigger: 触发条件
description: 描述

## 步骤
1. 步骤一
2. 步骤二

## 环境
## 约束
## 预期结果
## Voice & Style（写作风格指导）
## Strategy（行为合成策略）
```

### SkillImprover 自我改进机制（核心）

从 skill_improver.py 读到的：

```python
# 成功：置信度 +0.02（上限 1.0）
current = proc.get("confidence_avg", 0.5)
proc["confidence_avg"] = min(1.0, round(current + 0.02, 4))

# 成功：更新 freshness
staleness["last_confirmed"] = now

# 成功：更新工作节奏（EMA）
rhythm["avg_duration_minutes"] = round(prev * 0.7 + duration * 0.3, 1)

# Deviation：添加分支，标记漂移
# Failure：降低置信度，触发降级检查
```

### 对 ClawMind 的直接价值

ClawMind 可以从 `memory/apprentice/sops/` 读取 AgentHandover 学到的 SOP！

架构上：
```
AgentHandover（观察） → memory/apprentice/sops/（SOP文件）
ClawMind（决策）      ← 读取 SOP（作为经验输入）
```

这填补了 ClawMind 的"外部行为观察"空白。

### 下一步

1. 研究 `sop_inducer.py` — 如何从行为序列归纳 SOP
2. 研究 `behavioral_synthesizer.py` — 行为合成
3. 在 ClawMind 中实现对 `memory/apprentice/sops/` 的读取支持
