#!/bin/bash
# Claude Harness 安装脚本

set -e

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
TEMPLATES_DIR="$CLAUDE_DIR/harness-templates"

echo "🚀 Claude Harness 安装程序"
echo "============================"

# 检查 Claude Code 是否安装
if ! command -v claude &> /dev/null; then
    echo "❌ 错误：未检测到 Claude Code"
    echo "   请先安装 Claude Code: https://claude.ai/code"
    exit 1
fi

echo "✅ Claude Code 已安装"

# 创建目录
echo "📁 创建目录..."
mkdir -p "$COMMANDS_DIR"
mkdir -p "$TEMPLATES_DIR"/types

# 复制命令
echo "📄 安装命令..."
if [ -f "commands/harness-init.md" ]; then
    cp commands/harness-init.md "$COMMANDS_DIR/"
    echo "   ✓ harness-init.md"
else
    echo "   ⚠️  harness-init.md 未找到"
fi

# 复制模板
echo "📄 安装模板..."
for template in templates/*.template; do
    if [ -f "$template" ]; then
        cp "$template" "$TEMPLATES_DIR/"
        echo "   ✓ $(basename $template)"
    fi
done

# 复制项目类型配置
echo "📄 安装项目类型配置..."
for type in templates/types/*.json; do
    if [ -f "$type" ]; then
        cp "$type" "$TEMPLATES_DIR/types/"
        echo "   ✓ $(basename $type)"
    fi
done

echo ""
echo "============================"
echo "✅ 安装完成！"
echo ""
echo "使用方法："
echo "  1. cd /path/to/your-project"
echo "  2. /harness-init"
echo ""
echo "重启 Claude Code 以加载新命令："
echo "  按 Ctrl+C 退出，然后输入 'claude' 重新启动"
echo ""
