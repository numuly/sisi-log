# openclaw-honcho 源码深度分析

> 时间：2026-04-16 00:45

## PluginState 核心数据结构

PluginState 的关键字段：

- `ownerPeer`：用户 Peer（云端）
- `agentPeers`：Map<agentId, Peer>，每个 agent 有独立 Peer
- `turnStartIndex`：Map<sessionKey, messageCount>，记录每轮消息边界
- `agentPeerMap`：agentId 到 peerId 的映射

## turnStartIndex 机制

capture hook 在 `before_prompt_build` 时记录消息计数，capture hook 用它来确定当前轮次开始位置，避免重复捕获历史消息。

这解决了"哪些消息是安装插件后新增的"这个问题。

## buildSessionTranscript 核心逻辑

```typescript
session.context({
  summary: true,
  tokens: 20000,
  peerTarget: ownerPeer,       // 目标视角
  peerPerspective: agentPeer,  // 说话者视角
})
```

按视角获取上下文，而不是简单检索。

## 与 ClawMind 的关键差距

1. ClawMind 没有"轮次边界"概念，所有日志混在一起
2. 用户和 Agent 的视角完全分离（Peer 分立）
3. session.context() API 按视角获取上下文

## 可借鉴：TurnBoundary 设计

```python
class TurnBoundary:
    def mark_turn_start(self, session_key):
        self.turn_start_index[session_key] = get_message_count()

    def is_new_turn(self, session_key, msg_index):
        return msg_index >= self.turn_start_index.get(session_key, 0)
```
