# 6. L3 主动发现机制设计

> 生成时间：2026-04-15 20:12
> 状态：自动生成

## 核心问题

如何让 agent 在没有任何外部反馈的情况下，主动发现自身可能存在的缺陷？

## 灵感来源

人类有三个认知层次：
- 知道自己知道（清醒）
- 知道自己不知道（学习）
- 不知道自己不知道（盲点）← L3 要解决的

## 设计方案：盲点日志

### 机制

每次 drive() 被调用时，额外生成一条盲点探测日志：

```
盲点探测结果：
- 当前假设：...
- 可能的问题：...
- 需要验证的：...
```

### 实现思路

在 drive() 中加入 probe_blindspots() 调用：

```python
def probe_blindspots(state):
    issues = []
    # 1. 检查成功率是否虚高
    recent = state["log"][-10:]
    if all(p.get("type") == "success" for p in recent):
        issues.append("近期全部成功，可能是评估标准太宽松")
    # 2. 检查长时间无进展的项目
    for proj in state.get("projects", []):
        if proj.get("status") == "active":
            last = proj.get("last_log_time", "")
            if last and days_ago(last) > 7:
                proj_name = proj.get("name", "未知")
                issues.append("项目" + proj_name + "一周无进展")
    return issues
```

### 下一步

1. 实现 probe_blindspots() 函数
2. 在 drive() 中加入盲点探测调用
3. 把探测结果写入 patterns
4. 测试在无外部反馈情况下是否能主动发现问题
