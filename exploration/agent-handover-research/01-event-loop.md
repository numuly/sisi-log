# AgentHandover Event Loop 分析

> 时间：2026-04-16 02:00

## Observer Event Loop 核心配置

```rust
pub struct ObserverConfig {
    t_dwell_seconds: 3,          // 3秒空闲 = Dwell
    t_scroll_read_seconds: 8,   // 8秒 = 滚动/阅读
    capture_screenshots: true,    // 截图
    screenshot_max_per_minute: 20, // 每分钟最多20张
    poll_interval: 500ms,          // 每500ms轮询一次！
    dhash_threshold: 10,          // 感知哈希去重
    screenshot_quality: 70,
    screenshot_scale: 0.5,         // 半分辨率
    capture_paused: bool,         // 暂停时不捕获
}
```

## 关键洞察

### 1. 毫秒级感知

AgentHandover 每 **500ms** 轮询一次 OS 状态（窗口标题、焦点、鼠标位置）。
ClawMind 的心跳是 **15 分钟** = 900,000ms。

差了 **1800倍**！

这意味着 AgentHandover 可以捕捉到"鼠标悬停3秒后点击"这样的精细行为，ClawMind 完全没有这个能力。

### 2. Dwell 检测

`t_dwell_seconds: 3` — 连续3秒无操作，才算一次"Dwell"。
这避免记录"路过"式的临时注意力，只记录真正有目的的操作。

### 3. Screenshot Dedup

`dhash_threshold: 10` — 使用感知哈希（pHash）判断截图相似度。
两张截图的哈希距离 < 10 就认为是重复的，不存储。

### 4. 隐私过滤

`redactor = Redactor::new()` — 存储前自动过滤敏感信息（密码、API key 等）。

## 对 ClawMind 的意义

ClawMind 架构上就决定了无法做到毫秒级感知——它是消息驱动的，不是轮询的。

但可以在**概念层面借鉴**：
- Dwell 思想：行为持续 N 次才记录（类似）
- dHash 思想：对重要输出做哈希，避免记录重复结果

## 架构差距

```
AgentHandover：守护进程（常驻，500ms轮询）
ClawMind：消息驱动（15分钟心跳）
```

这是本质差距，不是实现细节。
