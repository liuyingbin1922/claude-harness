# 贡献指南

感谢你对 Claude Harness 的兴趣！本文档将指导你如何参与贡献。

## 如何贡献

### 报告问题

如果你发现了 bug 或有功能建议：

1. 先搜索 [Issues](https://github.com/yourusername/claude-harness/issues) 确认是否已存在
2. 如果不存在，创建新 Issue，包含：
   - 问题描述
   - 复现步骤
   - 预期行为 vs 实际行为
   - 环境信息（操作系统、Claude Code 版本等）

### 提交代码

1. **Fork 仓库**
   ```bash
   git clone https://github.com/yourusername/claude-harness.git
   cd claude-harness
   ```

2. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **做出修改**
   - 保持代码简洁
   - 遵循现有风格
   - 更新相关文档

4. **测试**
   ```bash
   # 在测试项目上验证
   cd /path/to/test-project
   /harness-init
   ```

5. **提交**
   ```bash
   git add .
   git commit -m "feat: 描述你的修改"
   git push origin feature/your-feature-name
   ```

6. **创建 Pull Request**
   - 描述修改内容
   - 关联相关 Issue
   - 等待审核

## 开发规范

### 提交信息格式

```
<type>: <subject>

<body>

<footer>
```

**Type 类型：**
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具

**示例：**
```
feat: 添加对 Ruby 项目的支持

- 新增 ruby.json 项目类型配置
- 支持 Gemfile 检测
- 添加 bundler 初始化逻辑

Closes #123
```

### 代码风格

- 使用 2 空格缩进
- 保持模板文件简洁
- 注释使用中文
- 变量使用大括号包裹：`{{VARIABLE}}`

### 项目类型配置

新增项目类型时，创建 `templates/types/<name>.json`：

```json
{
  "name": "LanguageName",
  "tech_stack": "- **语言:** 版本\n- **工具:** 工具名",
  "build_commands": "```bash\ncommand1\ncommand2\n```",
  "init_content": "初始化脚本内容",
  "entry_file": "main.ext",
  "file_patterns": ["*.ext"],
  "detect_files": ["config.file"]
}
```

## 需要帮助的领域

- [ ] 更多项目类型支持（Java、C++、C# 等）
- [ ] Windows 平台兼容性测试
- [ ] 更好的错误处理
- [ ] 文档翻译
- [ ] 示例项目

## 行为准则

- 尊重所有贡献者
- 接受建设性批评
- 专注于对用户最有利的事

## 联系方式

- Issue: [GitHub Issues](https://github.com/yourusername/claude-harness/issues)
- Discussion: [GitHub Discussions](https://github.com/yourusername/claude-harness/discussions)

感谢你的贡献！
