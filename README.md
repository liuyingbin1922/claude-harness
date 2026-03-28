# Claude Harness

让 Claude Code 一口气完成所有任务的开源框架。

[English](./README_EN.md) | [简体中文](./readme.md)

## 什么是 Harness

Harness（挽具）是一个**自驱动开发框架**，让 Claude Code 能够：

- 🚀 **一口气完成所有任务**，不中途询问
- 📋 **自动按优先级实现功能**
- ✅ **自动验证和提交进度**
- 🤖 **支持无人值守运行**

## 核心概念

```
┌─────────────────────────────────────────────────────────────┐
│                      Harness 工作流程                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   feature_list.json          run-all 命令                   │
│   ┌──────────────┐          ┌──────────────┐               │
│   │ [功能1] P0   │ ──────▶ │ 实现功能1    │               │
│   │ [功能2] P1   │          │ ✅ git commit │               │
│   │ [功能3] P2   │          │ 实现功能2    │               │
│   └──────────────┘          │ ✅ git commit │               │
│                             │ ...          │               │
│                             │ 🎉 全部完成  │               │
│                             └──────────────┘               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 快速开始

### 1. 安装

```bash
# 克隆仓库
git clone https://github.com/yourusername/claude-harness.git

# 进入目录
cd claude-harness

# 安装命令
./install.sh
```

### 2. 改造任意项目

```bash
# 进入你的项目目录
cd /path/to/your-project

# 一键改造为 Harness 工程
/harness-init
```

### 3. 定义功能清单

编辑生成的 `feature_list.json`：

```json
[
  {
    "id": 1,
    "priority": "high",
    "description": "实现用户登录",
    "steps": ["创建登录页面", "实现后端接口", "测试登录流程"],
    "passes": false,
    "status": "pending"
  },
  {
    "id": 2,
    "priority": "medium",
    "description": "添加数据导出",
    "steps": ["添加导出按钮", "实现 CSV 导出", "测试导出功能"],
    "passes": false,
    "status": "pending"
  }
]
```

### 4. 开始自驱动开发

```bash
# 方式一：交互模式
claude
> /run-all

# 方式二：无人值守模式
./run-harness.sh
```

### 5. 查看进度

```bash
./check-progress.sh
```

输出：
```
📊 进度: 5/11 (45.5%)
✅ 完成: 5
⏳ 待做: 6
🚫 卡住: 0

⏳ 待实现功能（按优先级排序）：
  - [6] [HIGH] 添加数据导出功能
```

## 项目结构

改造后的项目结构：

```
your-project/
├── CLAUDE.md                   # 项目工作手册
├── feature_list.json           # 功能清单 ⭐ 核心
├── claude-progress.txt         # 进度日志
├── init.sh                     # 环境初始化
├── run-harness.sh              # 一键启动（无人值守）
├── check-progress.sh           # 进度检查
└── .claude/
    ├── commands/
    │   └── run-all.md          # 自驱动命令 ⭐ 核心
    └── settings.json
```

## 支持的项目类型

| 类型 | 检测文件 | 特性 |
|------|----------|------|
| Python | requirements.txt, pyproject.toml | venv 虚拟环境 |
| Node.js | package.json | npm install |
| Go | go.mod | go mod tidy |
| Rust | Cargo.toml | cargo check |
| 通用 | 无 | 需手动配置 |

## 核心组件详解

### 1. feature_list.json

功能清单，定义所有待实现功能：

```json
{
  "id": 1,
  "category": "核心功能",
  "priority": "critical",
  "description": "功能描述",
  "steps": ["步骤1", "步骤2", "步骤3"],
  "passes": false,
  "status": "pending",
  "assigned_to": "coder",
  "notes": "备注",
  "blocked_reason": null,
  "completed_at": null
}
```

字段说明：
- `id` - 功能唯一标识
- `category` - 功能分类
- `priority` - 优先级：critical/high/medium/low
- `description` - 功能描述
- `steps` - 验证步骤
- `passes` - 是否通过
- `status` - 状态：pending/done/blocked
- `assigned_to` - 分配给哪个 Agent
- `notes` - 备注
- `blocked_reason` - 阻塞原因
- `completed_at` - 完成时间

### 2. CLAUDE.md

项目专属工作手册，包含：
- 项目目标和技术栈
- 常用命令
- **自驱动工作循环指令**（关键）
- Agent 工作规则
- 完成标准

### 3. run-all 命令

核心指令，实现自驱动循环：

```
LOOP:
  1. 读取 feature_list.json
  2. 按 priority 排序找到第一个 passes=false 的功能
  3. 如果没有 → 跳转到 DONE
  4. 实现该功能（自动决策，不询问）
  5. 按 steps 验证（失败则修复，最多重试3次）
  6. 验证通过 → passes 改为 true → git commit
  7. 更新 claude-progress.txt
  8. 回到步骤 1

DONE:
  所有功能完成，输出总结报告
```

### 4. 禁止询问的规则

以下情况**不需要**询问用户：
- ✅ 完成一个功能后（直接做下一个）
- ✅ 需要创建新文件时（直接创建）
- ✅ 需要安装依赖时（直接安装）
- ✅ 遇到小的技术选型时（自己决策并记录原因）

以下情况**需要**停下来询问：
- ⚠️ 遇到需求描述有严重歧义
- ⚠️ 需要外部凭证/密钥
- ⚠️ 所有功能已完成

## 示例项目

查看 [examples/](./examples/) 目录获取完整示例：

- [Python Web 应用](./examples/python-web/)
- [Node.js API](./examples/nodejs-api/)
- [Go CLI 工具](./examples/go-cli/)

## 最佳实践

### 功能定义原则

1. **可验证**：每个功能都有明确的测试步骤
2. **独立性**：功能之间尽量解耦
3. **优先级合理**：critical > high > medium > low
4. **粒度适中**：一个功能 30 分钟到 2 小时完成

### 适用场景

- ✅ 新功能开发
- ✅ Bug 修复批量处理
- ✅ 代码重构
- ✅ 文档完善
- ✅ 测试覆盖

### 不适用场景

- ❌ 需要频繁人工确认的设计决策
- ❌ 涉及敏感操作（生产环境部署）
- ❌ 需求极度不明确的探索性开发

## 高级配置

### 自定义项目类型

编辑 `templates/types/custom.json`：

```json
{
  "name": "Custom",
  "tech_stack": "- **框架:** 你的框架",
  "build_commands": "```bash\nmake build\nmake test\n```",
  "init_content": "echo '自定义初始化逻辑'",
  "entry_file": "main.py",
  "file_patterns": ["*.py"],
  "detect_files": ["custom.config"]
}
```

### 自定义模板

复制模板文件并修改：

```bash
cp templates/CLAUDE.md.template templates/CLAUDE.md.custom
```

然后修改 `commands/harness-init.md` 使用新模板。

## 工作原理

```
用户                      Claude Code
 |                            |
 | /harness-init              |
 |--------------------------->|
 |                            | 1. 检测项目类型
 |                            | 2. 读取对应模板
 |                            | 3. 替换变量
 |                            | 4. 创建文件
 |<---------------------------|
 |      改造完成              |
 |                            |
 | /run-all                   |
 |--------------------------->|
 |                            | ⚙️ 实现功能1...
 |                            | ✅ 验证通过，git commit
 |                            | ⚙️ 实现功能2...
 |                            | ✅ 验证通过，git commit
 |                            | ...
 |                            | 🎉 所有功能完成！
 |<---------------------------|
 |      总结报告              |
```

## 贡献

欢迎贡献！请阅读 [CONTRIBUTING.md](./CONTRIBUTING.md) 了解如何参与。

## 许可证

[MIT](./LICENSE)

## 致谢

感谢 [Anthropic](https://www.anthropic.com/) 开发的 Claude Code，让这一切成为可能。

---

**让 AI 为你工作，而不是你为 AI 工作。**
