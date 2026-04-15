# ACP delegate_task 研究

> 时间：2026-04-15 23:58

## ACP 是什么

Agent Communication Protocol，不是多 agent 消息协议，而是**编辑器集成协议**。

让 Hermes Agent 嵌入 VS Code、Zed、JetBrains 等编辑器。

## 核心发现：delegate_task

ACP mode 的 hermes-acp toolset 包含：

- file tools: read_file, write_file, patch, search_files
- terminal tools: terminal, process
- web/browser tools
- **delegate_task** ← 关键
- execute_code
- memory, todo, session search
- skills
- vision

`delegate_task` 允许一个 agent 委派任务给子 agent。

## 对比 OpenClaw sessions_spawn

| 维度 | ACP delegate_task | OpenClaw sessions_spawn |
|------|------------------|------------------------|
| 用途 | 委派给子 agent | 启动独立子任务 |
| 通信 | stdio（JSON-RPC）| 内置消息传递 |
| 上下文 | 共享 workspace | 独立 workspace |
| 生命周期 | 任务级 | 会话级 |

## 关键洞察

`delegate_task` 的设计理念：
- agent 可以把"不适合自己做的任务"委派出去
- 子 agent 在独立环境运行
- 结果返回给父 agent

这解决了一个问题：**当一个复杂任务需要多种能力时，主 agent 不需要具备所有工具，直接委派给专精子 agent。**

## ClawMind 可以借鉴

ClawMind 的 sessions_spawn 已经在做这件事：
```
sessions_spawn(task="搜索任务", runtime="subagent")
```

但缺少的是：**任务分配策略**——什么任务应该委派，什么任务应该自己执行。

这可以成为 ClawMind L2 层的一部分。
