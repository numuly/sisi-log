# AgentHandover 研究 — 综合结论

> 时间：2026-04-16 02:30

## 核心发现总结

### 架构

```
AgentHandover（Rust + Swift，571⭐，macOS）
├── crates/daemon/           # 守护进程（500ms 轮询）
│   ├── observer/           # 行为观察
│   │   ├── event_loop.rs  # 500ms 轮询，Dwell 检测
│   │   └── dwell.rs       # 停留检测
│   ├── capture/           # 截图 + dhash 去重
│   └── platform/          # macOS API（Accessibility、OCR）
├── app/                   # Swift macOS App（菜单栏）
├── worker/                # Python ML pipeline
│   ├── behavioral_synthesizer.py  # 行为合成
│   ├── skill_improver.py         # 自我改进
│   ├── openclaw_writer.py         # OpenClaw 集成
│   ├── sop_inducer.py            # SOP 归纳
│   └── 80+ 其他模块
└── storage/               # SQLite 持久化
```

### 关键机制

1. **500ms 轮询 OS 状态**（窗口标题、焦点、空闲）
2. **Dwell 检测**：3秒空闲才记录
3. **dhash 感知哈希**：截图去重
4. **Privacy Redaction**：自动过滤敏感信息
5. **SkillImprover**：success=+0.02置信度+EMA工作节奏，deviation=分支标记，failure=降级检查

### OpenClaw 集成

- `openclaw_writer.py` 写入 `~/.openclaw/workspace/memory/apprentice/sops/`
- SOP 格式 v3：含 Voice&Style + Strategy
- **Learning-only**：只写不执行

## ClawMind 差距与借鉴

| 机制 | AgentHandover | ClawMind 现状 | 可借鉴程度 |
|------|-------------|---------------|-----------|
| 500ms 轮询 | ✅ | ❌ 架构不支持 | 低（架构差距）|
| Dwell 检测 | ✅ | ❌ | 高 |
| dhash 去重 | ✅ | ❌ | 中 |
| 自我改进（置信度）| ✅ | ❌ | 高 |
| EMA 工作节奏 | ✅ | ❌ | 高 |
| SOP 格式 | ✅ | ❌（SKILL.md）| 中 |
| OpenClaw 集成 | ✅ | N/A | 直接可用 |

## 对 ClawMind 的行动项

### 高优先级
1. 实现置信度追踪（参考 SkillImprover）
2. 实现 EMA 工作节奏估算
3. 读取 `memory/apprentice/sops/` 作为外部经验

### 中优先级
1. Dwell 思想：N次重复行为才记录
2. SOP 格式改进：加 Voice & Strategy

## 大树模式总结

```
自我改进研究（主干）
├── Reflexion（学术标杆）
├── Hermes Agent（Skill 自创建）
├── OpenViking（Context 三层加载）
├── Honcho（分级推理 + Peer 分离）
└── AgentHandover（行为观察 + 自改进 Skills）← 新枝
```

AgentHandover 研究 ✅ 完成
