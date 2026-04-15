# WAL Protocol vs ClawMind 状态管理对比

> 2026-04-15 深夜自由研究

## WAL Protocol（来自 proactive-agent）

核心理念：
- **Chat History = Buffer（缓冲区）**，不是真正的存储
- **`SESSION-STATE.md` = RAM**，是唯一安全存放具体细节的地方
- **规则：先写入 WAL，再响应用户** — 在回复之前先记录关键决策和修正

关键原则：
```
1. 收到用户消息
2. 先写入 SESSION-STATE.md（当前状态、决策、关键细节）
3. 再回复用户
4. 最后更新长期记忆
```

## ClawMind 的 state_manager

ClawMind 做了类似的事：

```python
# 每次 add_log() 先写入 current_state.json
state["log"].append({
    "time": "...",
    "entry": "..."
})
_save(state)  # 先落盘

# 然后 drive() 返回决策
return {"action": "...", "health": 0.85}
```

## 对比分析

| 维度 | WAL Protocol | ClawMind |
|------|------------|---------|
| 持久化介质 | SESSION-STATE.md（文件） | current_state.json（JSON） |
| 写入时机 | 回复前先写 | 每次 add_log() 后写 |
| 状态结构 | Markdown + YAML front matter | 结构化 JSON |
| 任务状态 | 包含在 STATE 中 | 独立 current_task |
| 健康度 | 无 | calc_health() 实时计算 |
| 恢复机制 | 从 STATE 恢复 | 从 current_state 恢复 |

## 洞察

**WAL Protocol 更彻底**：它在每次交互前都强制写入，不依赖"主动记录"。
**ClawMind 更系统化**：健康度 + VFM 提供了量化决策，而不只是记录。

## 融合可能

ClawMind 可以借鉴 WAL 的"回复前写入"原则，在 `drive()` 被调用时先写入状态再返回决策。

但这需要修改 `drive()` 的返回时机——在决策后、返回前写入日志。

这是一个小的改进机会。
