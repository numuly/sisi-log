# AgentHandover 研究

> 时间：2026-04-16 01:45

## 核心理念

"Work once. Hand over forever."

AgentHandover 观察你在 Mac 上的工作方式，把工作流程转化为可复用的 **Skills**，然后让 Claude Code、OpenClaw、Hermes、Codex 执行它们。

## 架构（Rust）

```
crates/
  daemon/         # 核心观察引擎
    observer/     - event_loop, collector, dwell, focus_session, health
    capture/     - screenshot, clipboard, dhash, jpeg_converter
    platform/    - macOS: accessibility API, clipboard, OCR, power, windows
    ipc/         - cdp_bridge (Chrome DevTools), native_messaging
  storage/        # 持久化
    artifact_store  # Skills 存储
    migrations/   - SQLite schema
  test-harness/  # 回放测试
    replayer, recorder
  cli/           # 命令行
```

## 关键创新

1. **行为观察**：通过 macOS Accessibility API 观察鼠标点击、键盘输入、窗口焦点
2. **隐私过滤**：redaction.rs 自动过滤密码、API key 等敏感信息
3. **Skill 捕获**：不只是"做什么"，而是"为什么"——步骤、策略、决策逻辑、guardrails、用户的写作风格
4. **自我改进**：agents 执行后报告，success → 增强置信度，deviation → 新决策分支，failure → 触发修正

## Skill 自创建 vs ClawMind

| | AgentHandover | ClawMind |
|---|---|---|
| 创建方式 | 观察用户行为 | 任务完成触发 |
| 数据来源 | macOS Accessibility API | drive() 内部状态 |
| 存储 | SQLite artifacts | JSON 文件 |
| 训练 | 从行为序列学习 | 从任务描述生成 |
| 自我改进 | agent 执行报告反馈 | patterns 统计 |

## 对 ClawMind 的意义

AgentHandover 的 observation 模块是 ClawMind 缺少的最后一环：

```
当前 ClawMind：drive() 内部状态 → 手动创建 Skill
AgentHandover：macOS 行为观察 → 自动训练 Skill

差距：ClawMind 只能看到"我在做什么"，看不到"空是怎么做的"
```

## 新枝建议

开一个新枝：**observation-research**，研究 AgentHandover 的观察机制是否可以移植到 OpenClaw。
