# 7. Reflexion 核心机制精读

> 生成时间：2026-04-15 20:42
> 状态：自动生成

## Reflexion 的三个核心组件

### 1. Actor（执行器）
使用现有的 CoT / ReAct agent 执行任务

### 2. Evaluator（评估器）
根据任务类型判断成功或失败：
- 外部评估：使用规则/测试验证
- 语义评估：LLM 判断输出质量

### 3. Self-Reflection（自我反思）
这是 Reflexion 的核心创新：

当任务失败时，agent 生成一段文本反思：
上次尝试：描述上次做了什么
失败原因：分析为什么失败
下次改进：具体改进建议

这个反思被加入下次尝试的 context，继续尝试。

## 对 ClawMind 的启发

ClawMind 可以借鉴 Reflexion 的 self-reflection 机制：

1. 保留当前的健康度评估（类似 Evaluator）
2. 在 drive() 返回的结果中加入反思文本
3. 下次 drive() 调用时，把上次反思作为 context 参考

## 融合方案

```python
def self_reflect(state, last_result):
    fail_kw = ["失败", "错误", "无法", "没有完成"]
    is_fail = any(kw in last_result for kw in fail_kw)
    if is_fail:
        return "上次健康度下降，原因分析：" + last_result + "。建议：调整策略。"
    else:
        return "上次执行顺利，当前健康度良好。继续保持。"
```

这是 L2 + L3 融合的起点。
