# Claude Harness

An open-source framework that empowers Claude Code to complete all tasks in one go.

[简体中文](./readme.md) | English

## What is Harness

Harness is a **self-driven development framework** that enables Claude Code to:

- 🚀 **Complete all tasks in one go** without interruptions
- 📋 **Automatically implement features by priority**
- ✅ **Self-verify and commit progress**
- 🤖 **Support unattended execution**

## Core Concepts

### Basic Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                      Harness Workflow                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   feature_list.json          run-all command                │
│   ┌──────────────┐          ┌──────────────┐               │
│   │ [Feature1]   │ ──────▶ │ Implement    │               │
│   │ [Feature2]   │          │ ✅ git commit │               │
│   │ [Feature3]   │          │ Implement    │               │
│   └──────────────┘          │ ✅ git commit │               │
│                             │ ...          │               │
│                             │ 🎉 All done! │               │
│                             └──────────────┘               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Spec-Driven Workflow (Recommended)

If your project has a `docs/` directory containing requirement drafts, Harness supports a complete **Spec → Feature → Code** automation pipeline:

```
┌─────────┐    /spec-gen    ┌─────────────┐    /spec-to-features    ┌─────────────┐    /run-all    ┌─────────┐
│  docs/  │ ──────────────▶ │ artifacts/  │ ─────────────────────▶ │ feature_list │ ───────────▶ │  Code   │
│ (draft) │                 │  spec.md    │                        │   .json      │              │(impl)   │
└─────────┘                 └─────────────┘                        └─────────────┘              └─────────┘
```

## Quick Start

### 1. Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/claude-harness.git

# Enter the directory
cd claude-harness

# Install commands
./install.sh
```

### 2. Transform Any Project

```bash
# Enter your project directory
cd /path/to/your-project

# One-click transformation into a Harness project
/harness-init
```

### 3. Define Feature List

**Method A: Manual Editing (for projects with clear requirements)**

Edit the generated `feature_list.json` directly:

```json
[
  {
    "id": 1,
    "priority": "high",
    "description": "Implement user login",
    "steps": ["Create login page", "Implement backend API", "Test login flow"],
    "passes": false,
    "status": "pending"
  },
  {
    "id": 2,
    "priority": "medium",
    "description": "Add data export",
    "steps": ["Add export button", "Implement CSV export", "Test export feature"],
    "passes": false,
    "status": "pending"
  }
]
```

**Method B: Spec-Driven (for complex requirements that need refinement)**

If your project has a `docs/` directory with requirement drafts:

```bash
# Generate normalized spec from docs/
/spec-gen

# Convert spec to feature list
/spec-to-features
```

Harness will automatically read `docs/*.md`, invoke LLM to generate a normalized `artifacts/spec.md`, and then convert it into `feature_list.json`.

### 4. Start Self-Driven Development

```bash
# Method 1: Interactive mode
claude
> /run-all

# Method 2: Unattended mode
./run-harness.sh
```

### 5. Check Progress

```bash
./check-progress.sh
```

Output:
```
📊 Progress: 5/11 (45.5%)
✅ Completed: 5
⏳ Pending: 6
🚫 Blocked: 0

⏳ Pending features (sorted by priority):
  - [6] [HIGH] Add data export feature
```

## Project Structure

After transformation, your project structure will be:

```
your-project/
├── docs/                       # Requirement drafts (optional, for Spec-driven)
│   ├── 01-overview.md
│   └── 02-core-features.md
├── artifacts/                  # Generated spec docs (optional)
│   └── spec.md                 # Normalized technical specification
├── CLAUDE.md                   # Project handbook
├── feature_list.json           # Feature list ⭐ Core
├── claude-progress.txt         # Progress log
├── init.sh                     # Environment initialization
├── run-harness.sh              # One-click launch (unattended)
├── check-progress.sh           # Progress check
└── .claude/
    ├── commands/
    │   ├── run-all.md          # Self-driven command ⭐ Core
    │   ├── spec-gen.md         # Generate normalized spec
    │   └── spec-to-features.md # Convert spec to feature list
    └── settings.json
```

## Supported Project Types

| Type | Detection Files | Features |
|------|-----------------|----------|
| Python | requirements.txt, pyproject.toml | venv virtual environment |
| Node.js | package.json | npm install |
| Go | go.mod | go mod tidy |
| Rust | Cargo.toml | cargo check |
| Generic | None | Manual configuration required |

## Core Components

### 1. feature_list.json

Feature list defining all tasks to implement:

```json
{
  "id": 1,
  "category": "Core Features",
  "priority": "critical",
  "description": "Feature description",
  "steps": ["Step 1", "Step 2", "Step 3"],
  "passes": false,
  "status": "pending",
  "assigned_to": "coder",
  "notes": "Notes",
  "blocked_reason": null,
  "completed_at": null
}
```

Field descriptions:
- `id` - Unique feature identifier
- `category` - Feature category
- `priority` - Priority: critical/high/medium/low
- `description` - Feature description
- `steps` - Verification steps
- `passes` - Whether passed
- `status` - Status: pending/done/blocked
- `assigned_to` - Assigned agent
- `notes` - Additional notes
- `blocked_reason` - Blockage reason
- `completed_at` - Completion timestamp

### 2. CLAUDE.md

Project-specific handbook containing:
- Project goals and tech stack
- Common commands
- **Self-driven work loop instructions** (key)
- Agent work rules
- Completion criteria

### 3. run-all Command

Core instruction implementing the self-driven loop:

```
LOOP:
  1. Read feature_list.json
  2. Find first feature where passes=false, sorted by priority
  3. If none found → go to DONE
  4. Implement the feature (auto-decision, no asking)
  5. Verify against steps (retry up to 3 times if failed)
  6. If verified → set passes=true → git commit
  7. Update claude-progress.txt
  8. Go back to step 1

DONE:
  All features completed, output summary report
```

### 4. No-Ask Rules

**No need to ask** in these situations:
- ✅ After completing a feature (directly move to next)
- ✅ When creating new files (create directly)
- ✅ When installing dependencies (install directly)
- ✅ For minor technical decisions (decide and document)

**Need to stop and ask** in these situations:
- ⚠️ Serious ambiguity in requirements
- ⚠️ External credentials/keys needed
- ⚠️ All features completed

## Spec-Driven Development

Harness supports a complete automation pipeline from requirement drafts to code implementation.

### Use Cases

- Complex requirements that need LLM assistance to organize and refine
- Teams already maintaining a `docs/` directory with product documentation
- Want LLM to automatically extract feature points and acceptance criteria

### Workflow

```
1. Write requirement drafts
   └─▶ docs/*.md

2. /spec-gen
   └─▶ Read docs/
   └─▶ LLM generates normalized spec
   └─▶ Write artifacts/spec.md

3. /spec-to-features
   └─▶ Read artifacts/spec.md
   └─▶ LLM extracts features and acceptance criteria
   └─▶ Generate/merge feature_list.json

4. /run-all
   └─▶ Auto-implement all features by priority
```

### docs/ Directory Convention

You can place any `.md` files under `docs/`. Harness reads them in alphabetical order. Suggested naming:

```
docs/
├── 01-project-background.md
├── 02-core-features.md
├── 03-tech-constraints.md
└── 04-acceptance-criteria.md
```

**Content Guidelines:**
- No strict format required; handwritten drafts are fine
- Describe clearly "what to do" and "why"; let LLM figure out "how"
- The more specific the acceptance criteria, the better

### artifacts/spec.md Structure

The normalized spec generated by `/spec-gen` contains the following sections:

| Section | Content |
|---------|---------|
| Project Overview | Background, goals, tech stack, glossary |
| Feature Specs | Priority, description, acceptance criteria, technical notes, dependencies for each feature |
| Non-Functional Requirements | Performance, security, compatibility |
| Data Model | Core entities, interface contracts |
| Implementation Suggestions | Directory structure, key algorithms, third-party libraries |
| Validation Strategy | Testing strategy, acceptance process |

### Merge Strategy

When `feature_list.json` already exists, `/spec-to-features` performs intelligent merging:

- **Preserves** all items where `passes=true`
- **Appends** new features from the spec (deduplicated by `description`)
- **Re-sorts** and ensures continuous `id` values

This means you can repeatedly modify `docs/`, re-run `/spec-gen` and `/spec-to-features`, without losing completed progress.

## Example Projects

Check the [examples/](./examples/) directory for complete examples:

- [Python Web App](./examples/python-web/)
- [Node.js API](./examples/nodejs-api/)
- [Go CLI Tool](./examples/go-cli/)

## Best Practices

### Feature Definition Principles

1. **Verifiable**: Each feature has clear test steps
2. **Independent**: Features are loosely coupled
3. **Reasonable priority**: critical > high > medium > low
4. **Appropriate size**: One feature takes 30 minutes to 2 hours

### Suitable Scenarios

- ✅ New feature development
- ✅ Batch bug fixes
- ✅ Code refactoring
- ✅ Documentation improvements
- ✅ Test coverage

### Unsuitable Scenarios

- ❌ Frequent design decisions requiring human confirmation
- ❌ Sensitive operations (production deployments)
- ❌ Exploratory development with unclear requirements

## Advanced Configuration

### Custom Project Types

Edit `templates/types/custom.json`:

```json
{
  "name": "Custom",
  "tech_stack": "- **Framework:** Your framework",
  "build_commands": "```bash\nmake build\nmake test\n```",
  "init_content": "echo 'Custom initialization logic'",
  "entry_file": "main.py",
  "file_patterns": ["*.py"],
  "detect_files": ["custom.config"]
}
```

### Custom Templates

Copy and modify template files:

```bash
cp templates/CLAUDE.md.template templates/CLAUDE.md.custom
```

Then modify `commands/harness-init.md` to use the new template.

## How It Works

### Basic Mode

```
User                      Claude Code
 |                            |
 | /harness-init              |
 |--------------------------->|
 |                            | 1. Detect project type
 |                            | 2. Read corresponding template
 |                            | 3. Replace variables
 |                            | 4. Create files
 |<---------------------------|
 |      Transformation done   |
 |                            |
 | /run-all                   |
 |--------------------------->|
 |                            | ⚙️ Implement feature 1...
 |                            | ✅ Verified, git commit
 |                            | ⚙️ Implement feature 2...
 |                            | ✅ Verified, git commit
 |                            | ...
 |                            | 🎉 All features completed!
 |<---------------------------|
 |      Summary report        |
```

### Spec-Driven Mode (with docs/ directory)

```
User                      Claude Code
 |                            |
 | /harness-init              |
 |--------------------------->|
 |                            | 1. Detect project type
 |                            | 2. Detect docs/ directory
 |                            | 3. Create Harness files
 |                            |    + artifacts/ directory
 |<---------------------------|
 |      Transformation done   |
 |                            |
 | /spec-gen                  |
 |--------------------------->|
 |                            | 4. Read docs/*.md
 |                            | 5. Invoke LLM to generate spec
 |                            | 6. Write artifacts/spec.md
 |<---------------------------|
 |      Spec generated        |
 |                            |
 | /spec-to-features          |
 |--------------------------->|
 |                            | 7. Read artifacts/spec.md
 |                            | 8. Invoke LLM to extract features
 |                            | 9. Generate feature_list.json
 |<---------------------------|
 |      Feature list ready    |
 |                            |
 | /run-all                   |
 |--------------------------->|
 |                            | ⚙️ Implement feature 1...
 |                            | ✅ Verified, git commit
 |                            | ...
 |                            | 🎉 All features completed!
 |<---------------------------|
 |      Summary report        |
```

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) to learn how to participate.

## License

[MIT](./LICENSE)

## Acknowledgments

Thanks to [Anthropic](https://www.anthropic.com/) for developing Claude Code, making all this possible.

---

**Let AI work for you, not you work for AI.**
