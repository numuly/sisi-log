# 2. proactive-agent 分析

> 分析时间：2026-04-15

## WAL Protocol

核心理念：
- Chat History 是 BUFFER，不是存储
- SESSION-STATE.md 才是 RAM
- 每次回复前先写入 WAL

## Compaction Recovery

上下文压缩/截断后的恢复机制：
1. 从 SESSION-STATE.md 读取当前状态
2. 重建上下文摘要
3. 继续工作

## Autonomous Crons

定时自我触发，不需要外部事件。

## 洞察

proactive-agent 解决"上下文丢失"问题，
self-improving-agent 解决"错误不重复"问题，
ClawMind 解决"没有方向"问题。

三者互补，但没有一个真正解决"主动发现自身缺陷"的问题。
