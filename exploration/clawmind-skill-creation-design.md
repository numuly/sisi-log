# ClawMind Skill 自创建机制设计

> 设计时间：2026-04-15 23:09
> 来源：Hermes Agent 启发，P0 优先级

## 核心问题

ClawMind 当前只能"记录"经验，不能"转化"经验为可复用能力。
Hermes Agent 做到了：复杂任务 → 自动创建 Skill → Skill 被调用时持续改进。

## 设计目标

当一个复杂任务完成后，自动生成一个可复用的 Skill，这个 Skill 可以被下次调用。

## 触发条件

以下情况触发 Skill 创建：
1. 一个复杂任务被标记为"完成"
2. 同一个类型的问题出现了 3 次以上
3. 用户明确要求"把这个做成 Skill"

## Skill 创建流程

```
复杂任务完成
  ↓
提取核心逻辑（prompt + 工具调用序列）
  ↓
生成 Skill 描述（名称、触发条件、使用方法）
  ↓
写入 skills/ 目录（作为独立 skill）
  ↓
通知用户："发现可复用模式，已创建 Skill：[名称]"
```

## 数据结构

```python
class AutoCreatedSkill:
    name: str                    # Skill 名称
    trigger: list[str]          # 触发关键词
    prompt: str                 # 系统提示词
    tools: list[str]            # 需要的工具
    examples: list[dict]        # 使用示例
    created_from: str           # 来源任务
    improvement_count: int      # 被改进次数
    last_used: str              # 最后使用时间
```

## 触发时机

Skill 创建发生在 drive() 的"push_forward" 阶段：
- 当任务完成时，检查是否符合创建条件
- 如果符合，调用 _create_skill() 生成 Skill 文件

## 与 ClawMind 的整合

```
drive()
  ├─ should_reflect()    → 是否需要反思
  ├─ probe_blindspots()  → 主动发现盲点
  └─ check_skill_create() → 检查是否需要创建 Skill
```

## 存储位置

创建的 Skill 存放在：
`/home/node/.openclaw/workspace/skills/auto_created/`

## 下一步

1. 实现 _check_skill_create() 函数
2. 设计 AutoCreatedSkill 数据结构
3. 实现 _create_skill() 函数
4. 在 drive() 中集成调用
5. 测试：模拟一个复杂任务完成，验证 Skill 创建

## 参考

Hermes Agent：Autonomous skill creation after complex tasks
