---
description: 从 artifacts/spec.md 生成 feature_list.json，支持合并已有数据
description_english: Generate feature_list.json from artifacts/spec.md, with merge support for existing data
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep
---

读取 `artifacts/spec.md`，解析其中的功能规格，生成 `feature_list.json`。

## 前置检查

1. 检测 `artifacts/spec.md` 是否存在
   - 不存在 → 输出错误提示并建议先运行 `/spec-gen`
2. 检测 `artifacts/spec.md` 内容是否非空
   - 为空 → 输出错误提示

## 执行流程

### 1. 读取 Spec 文件

读取 `artifacts/spec.md` 的完整内容。

### 2. 读取 Prompt 模板

读取 `~/.claude/harness-templates/spec-to-features-prompt.md.template`，替换变量：
- `{{SPEC_CONTENT}}` → spec.md 的完整内容

### 3. 生成 Feature List

将构建好的 prompt 发送给 LLM，要求生成 `feature_list.json` 格式的内容。

**关键约束（必须在 prompt 中强调）：**
- 输出必须是合法的 JSON 数组，不要包含任何其他文字
- 每个功能对象必须包含以下字段：
  - `id`: 数字，从 1 开始递增
  - `category`: 功能分类（从 Spec 的章节提取，如"核心功能"、"API接口"、"数据层"等）
  - `priority`: 优先级，值为 critical/high/medium/low 之一
  - `description`: 一句话功能描述
  - `steps`: 字符串数组，从 spec 的验收标准转换而来，必须具体可执行（3-5 步）
  - `passes`: false
  - `status`: "pending"
  - `assigned_to`: "coder"
  - `notes`: 技术要点摘要，如有依赖关系标注 "依赖: #id"
  - `blocked_reason`: null
  - `completed_at`: null
- 转换规则：
  - 每个 Spec 中的功能点对应一个 feature_list 条目
  - steps 必须具体可执行，避免模糊描述如"确保正常工作"
  - 按优先级排序：critical 在前，low 在后
  - 如果 spec 中有依赖关系标注，在 notes 中保留

### 4. 校验 JSON

对 LLM 返回的内容进行校验：
- JSON 语法合法性
- 必要字段完整性（id, priority, description, steps）
- 优先级值合法性（必须为 critical/high/medium/low 之一）
- steps 数组非空
- id 唯一性

**校验失败时：**
- 输出具体错误信息
- 要求 LLM 修正并重新生成
- 最多重试 2 次
- 重试均失败后输出错误并停止

### 5. 合并策略

检查是否已存在 `feature_list.json`：

**情况 A：不存在或仅含示例项**
- 直接写入生成的 feature_list

**情况 B：已存在且有数据**
- 保留所有 `passes=true` 的已有项
- 对新生成的每项，检查是否与已有项（包括保留的已完成项）重复
  - 重复判断标准：`description` 字段相似度（简单字符串包含或完全匹配）
  - 不重复 → 分配新 id 并追加
  - 重复 → 跳过
- 重新排序所有项，确保 id 连续递增

### 6. 写入文件并更新进度

1. 写入 `feature_list.json`
2. 更新 `claude-progress.txt`，追加记录："[时间] Spec 已转换为 Feature List，共 X 个功能"

### 7. 输出摘要

- ✅ 成功生成功能数
- ✅ 优先级分布（critical/high/medium/low 各多少个）
- ℹ️  合并时跳过的重复项数量（如有）
- ℹ️  保留的已完成功能数量（如有）
- 💡 下一步：运行 `/run-all` 开始自动实现

## 错误处理

- Spec 文件不存在 → 提示先运行 `/spec-gen`
- JSON 校验失败 → 重试 2 次，仍失败则输出错误详情
- feature_list.json 写入失败 → 报告具体错误

## 禁止行为

- 不允许删除已有 `passes=true` 的功能项
- 不允许修改 `docs/` 或 `artifacts/spec.md`
- 不允许在合并过程中停下来询问用户
