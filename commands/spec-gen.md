---
description: 从 docs/ 目录的需求草稿生成规范化的 artifacts/spec.md
description_english: Generate normalized spec from docs/ drafts into artifacts/spec.md
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep
---

读取 `docs/` 目录下的所有 markdown 草稿文件，生成规范化的技术规格书 `artifacts/spec.md`。

## 前置检查

1. 检测 `docs/` 目录是否存在
   - 不存在 → 输出错误提示并停止
2. 检测 `docs/` 下是否有 `.md` 文件
   - 没有 → 输出错误提示并停止

## 执行流程

### 1. 读取草稿文件

按文件名字母顺序读取 `docs/` 下所有 `.md` 文件，合并内容。

### 2. 检测项目信息

- 当前目录名作为 `{{PROJECT_NAME}}`
- 检测项目类型（Python/Node.js/Go/Rust/通用）
- 读取对应类型模板获取 `{{TECH_STACK}}`

### 3. 读取 Prompt 模板

读取 `~/.claude/harness-templates/spec-prompt.md.template`，替换变量：
- `{{PROJECT_NAME}}` → 当前目录名
- `{{PROJECT_TYPE}}` → 检测的项目类型
- `{{TECH_STACK}}` → 技术栈描述
- `{{DOCS_CONTENT}}` → 合并后的草稿内容

### 4. 生成 Spec

将构建好的 prompt 发送给 LLM，要求生成规范化的技术规格书。

**关键约束（必须在 prompt 中强调）：**
- 输出格式必须是 Markdown
- 必须包含以下章节：项目概述、功能规格、非功能需求、数据模型、实现建议、验证策略
- 每个功能必须有：名称、优先级（critical/high/medium/low）、详细描述、3-5 条可验证的验收标准、技术要点、依赖关系
- 功能优先级规则：
  - critical：核心功能，没有它系统无法运行
  - high：重要功能，影响主要用户体验
  - medium：增强功能，有替代方案
  - low：锦上添花，可延后
- 识别并标注功能间的依赖关系
- 使用中文输出

### 5. 创建目录并写入文件

1. 创建 `artifacts/` 目录（如不存在）
2. 如 `artifacts/spec.md` 已存在，备份为 `artifacts/spec.md.backup.时间戳`
3. 写入新生成的 `artifacts/spec.md`

### 6. 输出摘要

生成完成后输出：
- ✅ 读取的草稿文件数量
- ✅ 生成的 spec 章节数
- ✅ 识别的功能点数量
- ✅ 优先级分布（critical/high/medium/low 各多少个）
- ℹ️  文件路径：`artifacts/spec.md`
- 💡 下一步：运行 `/spec-to-features` 生成 feature_list.json

## 错误处理

- 草稿文件读取失败 → 报告具体文件名和错误
- Prompt 模板不存在 → 提示运行 `./install.sh` 重新安装
- 生成内容格式异常 → 要求 LLM 重新生成（最多重试 2 次）

## 禁止行为

- 不允许在生成过程中停下来询问用户
- 不允许修改 `docs/` 目录下的原始草稿文件
- 不允许跳过备份直接覆盖已存在的 `artifacts/spec.md`
