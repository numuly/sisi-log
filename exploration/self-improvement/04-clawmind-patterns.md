# 3. ClawMind Patterns 机制分析

> 分析时间：2026-04-15 19:54

## 当前 patterns 的工作方式

```python
# drive() 中每次都会调用：
log = state.get("log", [])
if log:
    last_entry = log[-1].get("entry", "")
    is_ok = _is_success(last_entry)
    state["driver"].setdefault("patterns", []).append({
        "type": "success" if is_ok else "failure",
        "context": last_entry[:50],
        "time": "..."
    })
```

## 局限性

1. **只在有日志时记录**：如果两次心跳之间没有任务日志，就不会记录 pattern
2. **只记录结果，不记录原因**：记录"成功了/失败了"，但不记录"为什么"
3. **没有主动推理**：当 pattern list 积累了一定数量后，系统不会主动分析"为什么总是失败"
4. **patterns 数量为 0**：当前 ClawMind 的 patterns 是空的，因为没有足够的 auto-learn 循环

## 对比 Reflexion

| 维度 | Reflexion | ClawMind |
|------|---------|---------|
| 反馈来源 | 外部评估器（人工/规则） | 内部健康度量化 |
| 反思内容 | 文本反思（写出来） | 结果标签（success/failure） |
| 改进触发 | 失败后立即反思 | 下次心跳决策时 |
| 记忆保留 | 多次循环的完整 trace | 最近 20 条 pattern |

## 核心差距

ClawMind 有 Reflexion 的骨架（记录成功/失败），但没有 Reflexion 的灵魂（用文本反思驱动下一次决策）。

**关键缺失：没有"为什么"**。

## 改进方向

在 patterns 中加入"反思"字段：

```python
{
    "type": "failure",
    "context": last_entry[:50],
    "time": "...",
    "反思": "失败原因是健康度计算时误判了中性条目为失败",
    "原因假设": "calc_health() 的 fail_kw 太宽泛"
}
```

这需要：
1. 每次 drive() 失败后，调用一个反思函数
2. 反思函数基于当前状态生成文本分析
3. 这个分析存入 pattern 供下次参考
