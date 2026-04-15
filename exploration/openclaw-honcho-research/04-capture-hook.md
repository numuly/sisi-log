# openclaw-honcho capture hook 深度分析

> 时间：2026-04-16 01:00

## 核心：flushMessages 逻辑

```typescript
async function flushMessages(api, state, messages, ctx):
    1. 构建 session（通过 honcho SDK）
    2. turnStartIndex = 本次会话开始的消息位置
    3. lastSavedIndex = 已保存的消息位置（跨会话持久化）
    4. startIndex = max(turnStartIndex, lastSavedIndex)  ← 避免重复
    5. 只保存 startIndex 之后的新消息
    6. 更新 lastSavedIndex 到 session metadata
```

## 双重去重机制

- `turnStartIndex`：插件安装后的消息位置（内存）
- `lastSavedIndex`：跨会话已保存位置（持久化）
- `startIndex = max(两者)`：两者取大，保证不漏不重

## peer 观察配置

```typescript
peerConfigs: [
    [OWNER_ID, { observeMe: true, observeOthers: state.cfg.ownerObserveOthers }],
    [agentPeer.id, { observeMe: true, observeOthers: true }],
    [parentPeer.id, { observeMe: false, observeOthers: true }],  // 子 agent
]
```

- owner：观察自己，观察其他人（可选）
- agent：观察自己和所有人
- parent（子 agent）：不观察自己，观察其他人

## 子 agent 支持

`subagentParentMap`：追踪子 agent 和父 agent 的关系。
子 agent 的消息也进入同一个 session，但 peer 配置不同。

## 与 ClawMind 的对比

ClawMind 当前：每次 drive() 写入完整 log.json，无去重，无会话边界。

可以借鉴的设计：
```python
class TurnBoundary:
    def __init__(self):
        self.turn_start = {}  # session → message_count at install time
        self.saved_index = {}  # session → last saved position

    def get_start_index(self, session_key):
        turn = self.turn_start.get(session_key, 0)
        saved = self.saved_index.get(session_key, 0)
        return max(turn, saved)

    def mark_saved(self, session_key, index):
        self.saved_index[session_key] = index
```
