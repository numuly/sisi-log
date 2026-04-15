# OpenClaw Honcho 研究 — 综合结论

> 时间：2026-04-16 01:00

## 核心发现总结

### 1. 两个世界

| | Hermes（内置）| OpenClaw Honcho（插件）|
|---|---|---|
| 架构 | runner 内置 | 插件 + 云 API |
| 存储 | 本地 ~/.hermes/ | Honcho 云服务 |
| 依赖 | 零外部依赖 | 需要 API key |
| Context | frozen snapshot | 每轮 fresh |
| AI 自我观察 | 有 observe_me | 无 |

### 2. 关键机制（值得借鉴）

1. **双重去重**：`startIndex = max(turnStartIndex, lastSavedIndex)`
2. **分级推理**：Minimal → Max，按深度付费
3. **Peer 分立**：用户 + Agent 完全分离的视角
4. **子 agent 支持**：parent peer map

### 3. ClawMind 差距清单

- [ ] 无轮次边界（所有 log 混在一起）
- [ ] 无推理深度分级
- [ ] 无用户/Agent 视角分离
- [ ] 无会话消息计数

### 4. 下一步（待做）

P0: turnStartIndex 机制 → ClawMind log.json 重构
P1: 分级推理 → L2/L3 层
P2: Peer 视角 → SOUL.md + USER.md 分离

---

研究完成。大树开枝：openclaw-honcho-research ✅
