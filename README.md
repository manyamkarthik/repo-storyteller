# 📖 repo-storyteller

**Understand any codebase like it's a bedtime story, then learn the real engineering behind it.**

`repo-storyteller` is an [Agent Skill](https://agentskills.io) for AI coding agents (Claude Code, Codex, OpenCode, Cursor, Gemini CLI, GitHub Copilot and more). Ask your agent to explain a file, a function, a flow or a concept, and instead of a dry summary you get:

- 🧸 **A kid-level story.** Your repo becomes a world (a restaurant, a factory, a detective agency) with named characters that stay the same across every explanation.
- 🔍 **A deep trace.** It starts at a line (say `lifespan` in `app.py`), follows every call into your own functions **all the way down**, shows what goes in and what comes out at each step, then climbs back up. Every claim cites `file:line`.
- 🧩 **Term Cards** for every concept (DB index, connection pool, async, middleware, JWT…):
  1. 📖 **The story**: the idea as a scene in the story world
  2. 🔧 **What it really is**: the real definition, and where it shows up in *your* code
  3. 🎯 **Why we need it**: the problem it solves here
  4. 💥 **What breaks without it**: what you'd actually see go wrong
- 🎢 **Built to keep you engaged:** short chapters, hooks and cliffhangers, "predict what happens" quizzes, a *you are here* breadcrumb and a *choose your next path* menu.
- 🌐 **An interactive HTML story page** with a clickable flow map (tap a box to jump to its chapter), expandable nested function traces, annotated code, a progress bar, and dark mode.
- ✏️ **Excalidraw drawings**, if you have an Excalidraw MCP server connected. Without one, it falls back to Mermaid diagrams.

---

## 🚀 Install

### Any agent (recommended): `npx skills`

Uses the open [`skills`](https://github.com/vercel-labs/skills) CLI (Node.js 22+).

```bash
# Interactive: pick your agent(s)
npx skills add manyamkarthik/repo-storyteller

# Global install (every project) for a specific agent
npx skills add manyamkarthik/repo-storyteller -g -a claude-code
npx skills add manyamkarthik/repo-storyteller -g -a codex
npx skills add manyamkarthik/repo-storyteller -g -a opencode
npx skills add manyamkarthik/repo-storyteller -g -a cursor
npx skills add manyamkarthik/repo-storyteller -g -a gemini-cli
npx skills add manyamkarthik/repo-storyteller -g -a github-copilot

# Several agents at once
npx skills add manyamkarthik/repo-storyteller -g -a claude-code -a codex -a opencode
```

Leave out `-g` to install just for the current project.

### Claude Code: plugin marketplace

Inside Claude Code:

```
/plugin marketplace add manyamkarthik/repo-storyteller
/plugin install repo-storyteller@repo-storyteller
```

### One-line shell installer (no Node needed)

```bash
curl -fsSL https://raw.githubusercontent.com/manyamkarthik/repo-storyteller/main/install.sh | bash
```

This installs for every agent it finds on your machine. To pick specific ones:

```bash
curl -fsSL https://raw.githubusercontent.com/manyamkarthik/repo-storyteller/main/install.sh | bash -s -- claude codex opencode
```

### Manual install

Copy `skills/repo-storyteller/` into your agent's skills folder:

| Agent | Global (all projects) | Project only |
|---|---|---|
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `~/.codex/skills/` | `.agents/skills/` |
| OpenCode | `~/.config/opencode/skills/` | `.opencode/skills/` or `.agents/skills/` |
| Cursor | `~/.cursor/skills/` | `.agents/skills/` |
| Gemini CLI | `~/.gemini/skills/` | `.agents/skills/` |
| GitHub Copilot | `~/.copilot/skills/` | `.agents/skills/` |

```bash
git clone https://github.com/manyamkarthik/repo-storyteller.git
cp -r repo-storyteller/skills/repo-storyteller ~/.claude/skills/
```

Restart your agent after installing.

---

## 💬 How to use it

Just ask in plain words. The skill triggers on things like *explain*, *ELI5*, *walk me through*, *trace*, or *I don't get it*.

```text
explain this repo like I'm 5
explain the lifespan in app.py and trace every function it calls
what is a db index and why does models.py need one?
walk me through what happens when a user hits POST /chat
I don't get services/auth.py
```

You'll get a short teaser in chat, plus a story page at `.storyteller/<topic>.html` that opens in your browser. Each page ends with **"choose your next path"** buttons. Click one to copy the next prompt.

> 💡 Add `.storyteller/` to your `.gitignore`. It holds your story pages and `world.md`, which keeps the story world the same between sessions.

### Optional: Excalidraw

Connect an Excalidraw MCP server to your agent. The skill detects it automatically and draws:
- the call-stack journey (boxes and arrows, labeled with what data gets passed)
- the story-world map
- term scenes (e.g. *a pantry with labels vs without* for DB indexes)

---

## 🗂️ Repo layout

```
repo-storyteller/
├── skills/
│   └── repo-storyteller/
│       ├── SKILL.md            # the skill instructions
│       └── assets/
│           └── template.html   # interactive story-page template
├── .claude-plugin/
│   ├── plugin.json             # Claude Code plugin manifest
│   └── marketplace.json        # lets /plugin marketplace add work
├── install.sh                  # curl | bash installer
├── LICENSE
└── README.md
```

## 🤝 Contributing

PRs are welcome, especially new story worlds, better term-card examples, and template improvements. Keep `SKILL.md` portable: no agent-specific tool names without a fallback.

## 📄 License

MIT
