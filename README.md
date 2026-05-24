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

### 基础工作流

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

### Spec 驱动工作流（推荐）

如果你的项目中有 `docs/` 目录存放需求草稿，Harness 支持完整的 **Spec → Feature → Code** 自动化 pipeline：

```
┌─────────┐    /spec-gen    ┌─────────────┐    /spec-to-features    ┌─────────────┐    /run-all    ┌─────────┐
│  docs/  │ ──────────────▶ │ artifacts/  │ ─────────────────────▶ │ feature_list │ ───────────▶ │  代码   │
│ (草稿)  │                 │  spec.md    │                        │   .json      │              │ (实现)  │
└─────────┘                 └─────────────┘                        └─────────────┘              └─────────┘
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

**方式 A：手动编辑（适合需求明确的项目）**

直接编辑生成的 `feature_list.json`：

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

**方式 B：Spec 驱动（适合需求较复杂、需要逐步细化的项目）**

如果你的项目中有 `docs/` 目录存放需求草稿：

```bash
# 从 docs/ 生成规范化 spec
/spec-gen

# 从 spec 生成功能清单
/spec-to-features
```

Harness 会自动读取 `docs/*.md`，调用 LLM 生成规范化的 `artifacts/spec.md`，再自动转换为 `feature_list.json`。

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
├── docs/                       # 需求草稿（可选，用于 Spec 驱动）
│   ├── 01-需求概述.md
│   └── 02-核心功能.md
├── artifacts/                  # 生成的规范文档（可选）
│   └── spec.md                 # 规范化技术规格书
├── CLAUDE.md                   # 项目工作手册
├── feature_list.json           # 功能清单 ⭐ 核心
├── claude-progress.txt         # 进度日志
├── init.sh                     # 环境初始化
├── run-harness.sh              # 一键启动（无人值守）
├── check-progress.sh           # 进度检查
└── .claude/
    ├── commands/
    │   ├── run-all.md          # 自驱动命令 ⭐ 核心
    │   ├── spec-gen.md         # 生成规范 spec
    │   └── spec-to-features.md # spec 转功能清单
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

## Spec 驱动开发

Harness 支持从需求草稿到代码实现的完整自动化 pipeline。

### 使用场景

- 需求较复杂，需要 LLM 帮助梳理和细化
- 团队已有 `docs/` 目录存放产品文档
- 希望 LLM 自动提取功能点和验收标准

### 工作流

```
1. 手写需求草稿
   └─▶ docs/*.md

2. /spec-gen
   └─▶ 读取 docs/
   └─▶ LLM 生成规范化 spec
   └─▶ 写入 artifacts/spec.md

3. /spec-to-features
   └─▶ 读取 artifacts/spec.md
   └─▶ LLM 提取功能点和验收标准
   └─▶ 生成/合并 feature_list.json

4. /run-all
   └─▶ 按优先级自动实现所有功能
```

### docs/ 目录规范

`docs/` 下可放置任意 `.md` 文件，Harness 会按文件名排序读取。建议的命名方式：

```
docs/
├── 01-项目背景.md
├── 02-核心功能.md
├── 03-技术约束.md
└── 04-验收标准.md
```

**内容要求：**
- 无需严格格式，手写草稿即可
- 描述清楚"做什么"和"为什么"，"怎么做"交给 LLM 推导
- 验收标准越具体越好

### artifacts/spec.md 结构

`/spec-gen` 生成的规范化 spec 包含以下章节：

| 章节 | 内容 |
|------|------|
| 项目概述 | 背景、目标、技术栈、术语表 |
| 功能规格 | 每个功能的优先级、描述、验收标准、技术要点、依赖 |
| 非功能需求 | 性能、安全、兼容性要求 |
| 数据模型 | 核心实体、接口契约 |
| 实现建议 | 目录结构、关键算法、第三方库 |
| 验证策略 | 测试策略、验收流程 |

### 合并策略

当 `feature_list.json` 已存在时，`/spec-to-features` 会智能合并：

- **保留**所有 `passes=true` 的已完成项
- **追加** spec 中的新功能（按 `description` 去重）
- **重新排序**并确保 `id` 连续

这意味着你可以反复修改 `docs/`、重新运行 `/spec-gen` 和 `/spec-to-features`，而不会丢失已完成的进度。

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

### 基础模式

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

### Spec 驱动模式（含 docs/ 目录）

```
用户                      Claude Code
 |                            |
 | /harness-init              |
 |--------------------------->|
 |                            | 1. 检测项目类型
 |                            | 2. 检测 docs/ 目录
 |                            | 3. 创建 Harness 文件
 |                            |    + artifacts/ 目录
 |<---------------------------|
 |      改造完成              |
 |                            |
 | /spec-gen                  |
 |--------------------------->|
 |                            | 4. 读取 docs/*.md
 |                            | 5. 调用 LLM 生成 spec
 |                            | 6. 写入 artifacts/spec.md
 |<---------------------------|
 |      Spec 生成完成         |
 |                            |
 | /spec-to-features          |
 |--------------------------->|
 |                            | 7. 读取 artifacts/spec.md
 |                            | 8. 调用 LLM 提取功能
 |                            | 9. 生成 feature_list.json
 |<---------------------------|
 |      功能清单就绪          |
 |                            |
 | /run-all                   |
 |--------------------------->|
 |                            | ⚙️ 实现功能1...
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
