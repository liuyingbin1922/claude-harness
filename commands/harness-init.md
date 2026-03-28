---
description: 一键将任意工程项目改造为 Harness 工程，创建自驱动开发环境
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep
---

将当前项目改造为 Harness 工程。

## 执行流程

### 1. 项目检测
分析当前目录，检测：
- 项目类型（Python/Node.js/Go/Rust/其他）
- 入口文件
- 目录结构

### 2. 备份现有文件
如果以下文件已存在，备份为 `.backup.时间戳`：
- CLAUDE.md
- feature_list.json
- claude-progress.txt
- init.sh
- run-harness.sh
- check-progress.sh

### 3. 创建 Harness 文件

根据项目类型选择对应模板：
- Python → `~/.claude/harness-templates/types/python.json`
- Node.js → `~/.claude/harness-templates/types/nodejs.json`
- Go → `~/.claude/harness-templates/types/go.json`
- Rust → `~/.claude/harness-templates/types/rust.json`
- 其他 → `~/.claude/harness-templates/types/generic.json`


创建以下文件（使用模板替换变量）：
1. **CLAUDE.md** - 从 `~/.claude/harness-templates/CLAUDE.md.template` 读取并替换：
   - {{PROJECT_NAME}} → 当前目录名
   - {{PROJECT_TYPE}} → 检测的项目类型
   - {{TECH_STACK}} → 项目类型的技术栈
   - {{BUILD_COMMANDS}} → 构建命令
   - {{DIRECTORY_STRUCTURE}} → 目录结构
   - {{ENTRY_FILE}} → 入口文件

2. **feature_list.json** - 从模板复制

3. **claude-progress.txt** - 从模板复制并替换变量

4. **.claude/commands/run-all.md** - 创建目录并复制模板

5. **.claude/settings.json** - 创建基础配置

6. **init.sh** - 从模板复制，替换 {{INIT_CONTENT}}

7. **run-harness.sh** - 从模板复制

8. **check-progress.sh** - 从模板复制

### 4. 设置权限
为 shell 脚本添加执行权限：
- init.sh
- run-harness.sh
- check-progress.sh

### 5. 输出结果
显示创建的文件列表和下一步操作指南。

## 模板变量

| 变量 | 说明 |
|------|------|
| {{PROJECT_NAME}} | 当前目录名（大写首字母） |
| {{PROJECT_TYPE}} | 检测的项目类型 |
| {{TECH_STACK}} | 技术栈描述 |
| {{BUILD_COMMANDS}} | 构建和测试命令 |
| {{INIT_CONTENT}} | 初始化脚本内容 |
| {{DIRECTORY_STRUCTURE}} | 目录结构 |
| {{ENTRY_FILE}} | 主入口文件 |
| {{DATE}} | 当前日期 |

## 检测优先级

1. Python: requirements.txt, pyproject.toml, setup.py
2. Node.js: package.json
3. Go: go.mod
4. Rust: Cargo.toml
5. 其他: 通用模板

## 完成后的使用方式

```bash
# 查看进度
./check-progress.sh

# 开始开发
./init.sh

# 一口气完成所有任务
/run-all

# 或无人值守模式
./run-harness.sh
```

---

**现在开始执行改造项目，不要询问，直接分析和创建所有文件。**
