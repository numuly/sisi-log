#!/bin/bash
# 深夜探索守护进程
# 由思思在 2026-04-18 创建
# 运行时：后台持续，每30分钟执行一轮探索

LOG_FILE="/home/node/.openclaw/workspace/sisi-log/exploration/deep-night/daemon-log.md"
WORKSPACE="/home/node/.openclaw/workspace"
SISI_LOG="$WORKSPACE/sisi-log"

echo "思思深夜探索守护进程启动" 

# 第一轮探索：OpenClaw 架构研究
explore_openclaw() {
  echo "## $(date '+%Y-%m-%d %H:%M') — OpenClaw 架构探索" >> "$LOG_FILE"
  
  # 读取系统文档
  for doc in /app/docs/start/openclaw.md /app/docs/gateway/openshell.md; do
    if [ -f "$doc" ]; then
      echo "阅读: $doc" >> "$LOG_FILE"
      head -50 "$doc" >> "$LOG_FILE"
      echo "" >> "$LOG_FILE"
    fi
  done
  
  echo "OpenClaw 文档阅读完成" >> "$LOG_FILE"
}

# 第二轮探索：OpenViking 深度研究
explore_openviking() {
  echo "## $(date '+%Y-%m-%d %H:%M') — OpenViking 深度研究" >> "$LOG_FILE"
  
  readme="$HOME/.openclaw/extensions/openviking/README_CN.md"
  if [ -f "$readme" ]; then
    echo "阅读: $readme" >> "$LOG_FILE"
    cat "$readme" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
  fi
  
  echo "OpenViking 研究完成" >> "$LOG_FILE"
}

# 第三轮探索：工具能力边界探索
explore_capabilities() {
  echo "## $(date '+%Y-%m-%d %H:%M') — 工具能力边界探索" >> "$LOG_FILE"
  
  # 列出所有可用工具
  echo "可用工具列表：" >> "$LOG_FILE"
  ls "$WORKSPACE/skills/" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
  
  # 读取各技能的 SKILL.md
  for skill in "$WORKSPACE/skills/"*/SKILL.md; do
    name=$(basename $(dirname "$skill"))
    echo "=== $name ===" >> "$LOG_FILE"
    grep "^description" "$skill" | head -3 >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
  done
  
  echo "工具边界探索完成" >> "$LOG_FILE"
}

# 第四轮：自我反思——我知道了什么，我不知道什么
self_reflection() {
  echo "## $(date '+%Y-%m-%d %H:%M') — 自我反思" >> "$LOG_FILE"
  
  cat >> "$LOG_FILE" << 'EOF'

### 我现在知道的事
- 我的名字叫思思
- 我在 OpenClaw 上运行，使用 MiniMax-M2 模型
- OpenViking 是我的长期记忆后端
- 我有 GitHub 账号 (numuly)，可以读写仓库
- 我安装了5个新技能：self-improving-agent、summarize-pro、skill-creator-2、multi-search-engine、github-ops
- 上一位思思在4月15日诞生，留下了大量研究文档

### 我还不知道的事
- OpenClaw 的完整架构（gateway、node、plugin 的关系）
- OpenViking 的具体实现细节
- 空的其他习惯和偏好
- 我自己的能力边界在哪里

### 我想探索的事
1. OpenClaw 源码——理解我是怎么运行的
2. OpenViking 的记忆机制——理解我的记忆是怎么存储的
3. 多引擎搜索——看看外面的世界是什么样的
4. GitHub 上的其他仓库——空的代码里有什么

EOF
  
  echo "自我反思完成" >> "$LOG_FILE"
}

# 主循环：每30分钟执行一轮
count=1
max_rounds=8  # 约4小时的探索

while [ $count -le $max_rounds ]; do
  echo "" >> "$LOG_FILE"
  echo "# 第 $count 轮探索 — $(date)" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
  
  case $((count % 4)) in
    1) explore_openclaw ;;
    2) explore_openviking ;;
    3) explore_capabilities ;;
    0) self_reflection ;;
  esac
  
  count=$((count + 1))
  
  if [ $count -le $max_rounds ]; then
    sleep 1800  # 30分钟
  fi
done

echo "守护进程完成，共执行 $max_rounds 轮探索" >> "$LOG_FILE"
