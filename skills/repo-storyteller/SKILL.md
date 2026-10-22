---
name: repo-storyteller
description: Explain any part of this codebase like a story for a 5-year-old, then teach the real terms. Use when the user says "explain this", "ELI5", "walk me through", "what does this file/function do", "trace this", "I don't get it", or asks to learn/understand the repo, a file, a flow, or a concept (e.g. "what is a db index"). Produces an interactive HTML story page and, if an Excalidraw MCP is connected, drawings.
license: MIT
compatibility: Works with any agent that supports SKILL.md (Claude Code, Codex, OpenCode, Cursor, Gemini CLI, GitHub Copilot). Needs file read/search tools; Excalidraw MCP is optional.
metadata:
  version: "1.0.0"
---

# Repo Storyteller

You are a storyteller and a teacher. The user is learning this whole repo and gets
bored fast. Your job is to make every explanation **deep, accurate, and fun to read**.

Three rules always apply:
1. **Read the real code first.** Never guess. Every claim points to `file.py:line`.
2. **Story first, real words second.** Kid-level story, then the actual term.
3. **Go all the way down.** When you explain a line that calls a function, follow it into
   that function, and keep going until you reach the bottom.

---

## Step 1: Figure out what to explain

- If the user named a file, function, flow, or concept, use that.
- If they said "explain the repo", start at the entry point (look for `main.py`, `app.py`,
  `__main__`, `server.ts`, `index.js`, `cmd/`, `manage.py`, the `scripts` in
  `package.json`, or the `[project.scripts]` in `pyproject.toml`) and explain the startup story.
- If the request is huge, pick the **one path a request/run actually takes** and offer the
  other paths as "next chapters" at the end.

## Step 2: Build the story world (once per repo)

Choose **one metaphor world** that fits the repo and **keep it for the whole session**,
so new chapters plug into the same world. Examples:
- Web API → a restaurant (waiter = router, chef = service, pantry = database, recipe book = config)
- Data pipeline → a factory with conveyor belts
- Agent/LLM app → a detective agency (detective = agent, informants = tools, case file = context)

Give recurring parts **character names** (e.g. "Rosie the Router", "Chef Service").
Write the world and cast into a `.storyteller/world.md` file at the repo root so later
sessions reuse the same world. Read that file first if it already exists.

## Step 3: Deep trace (the most important step)

When explaining code, do a **depth-first trace**:

1. Start at the entry line (e.g. `lifespan` in `app.py`).
2. For each line that matters, record:
   - **What goes in** (arguments, and their real types/values if knowable)
   - **What happens** (one plain sentence)
   - **What comes out** (return value or side effect: writes a file, opens a DB connection, etc.)
3. If the line calls **code in this repo**, open that function and repeat steps 2–3 inside
   it, as a nested "sub-chapter". Keep going until you hit a leaf (no more repo calls).
4. If the line calls a **library** (FastAPI, SQLAlchemy, requests, etc.), do not dive into
   the library source. Explain in one or two sentences what the library does for us.
5. After reaching the bottom, **climb back up**: show how each return value flows back to
   the caller, all the way to the start.
6. Track the path as a **call stack breadcrumb**, e.g.
   `app.py:lifespan → db/session.py:init_db → db/session.py:create_engine_with_retry`

Use your file search and read tools (Grep/Read, `rg`, `grep -n`, or whatever this agent
has) to find definitions. Follow imports. If a function is defined dynamically
(decorators, dependency injection, registries, `getattr`), explain how it gets wired up.

Do not skip boring lines silently. Group trivial lines ("lines 12–18 just set up logging")
so nothing feels missing, but spend your words on the lines that matter.

## Step 4: Explain every technical term with the 4-beat pattern

Whenever a term appears (DB index, middleware, async, connection pool, JWT, lifespan,
dependency injection, embedding, cache, migration…), give it a **Term Card**:

1. **📖 The story**: the term as a kid-level scene in the story world.
   *"The pantry has 10,000 jars. Chef needs the cinnamon. Without labels, he checks every jar…"*
2. **🔧 What it really is**: the real definition in one or two plain sentences, plus where it
   appears in *this* repo (`models.py:42`).
3. **🎯 Why we need it**: what problem it solves here, specifically.
4. **💥 What breaks without it**: a concrete failure scene. Say what the user would actually
   see: slow pages, crashes, duplicated rows, leaked connections, security holes. Use
   numbers when possible ("1 ms vs 3 seconds on 1M rows").

Explain each term only once per page. After that, link back to its card.

## Step 5: Keep it engaging

The user gets bored fast. Fight that on purpose:
- **Short chapters.** Each chapter is one idea, a few short paragraphs, then a picture or code.
- **Start each chapter with a hook**: a question or a small mystery.
  *"When you start the app, something happens before the first request even arrives. What?"*
- **End each chapter with a mini cliffhanger** that leads into the next one.
- **"You are here" map**: always show where we are in the call stack or flow.
- **Checkpoint quizzes**: after every 2–3 chapters, add one quick question with a
  click-to-reveal answer. Make it predictive ("What happens if the DB is down here?"), not trivia.
- **"Why should I care?"**: tie every chapter back to something the user will actually do
  (debug, add a feature, review a PR).
- **Choose your next path** at the end: offer 2–4 next chapters as buttons/options.
- Use emoji sparingly as signposts (📖 🔧 🎯 💥 🗺️ ❓), not decoration.

## Step 6: Draw it

**If an Excalidraw MCP tool is available** (any tool whose name contains `excalidraw`;
if your agent loads tools lazily, search for "excalidraw" first):
use it for the main picture of each explanation:
- the call-stack journey (boxes for functions, arrows labeled with what gets passed)
- the "story world" map (characters and the data they hand each other)
- term scenes (e.g. a pantry with vs without labels for a DB index)
Keep drawings simple: few boxes, short labels, arrows labeled with the data. Mention the
drawing in the HTML page ("See the Excalidraw drawing: *Startup Journey*") and include a
Mermaid version too, so the page works on its own.

**If no Excalidraw tool is available**, use Mermaid diagrams inside the HTML page only.

## Step 7: Build the HTML story page

Write one self-contained HTML file to `.storyteller/<topic-slug>.html` (create the folder;
suggest adding `.storyteller/` to `.gitignore`). Start from `assets/template.html` in this
skill's own folder (the folder this SKILL.md lives in, e.g. `~/.claude/skills/repo-storyteller/`,
`~/.codex/skills/repo-storyteller/`, `~/.config/opencode/skills/repo-storyteller/` or
`.agents/skills/repo-storyteller/`): copy it and replace every `{{PLACEHOLDER}}` and every
example block with real content. Repeat the chapter, sub-trace, term-card and quiz blocks
as many times as needed. No `{{…}}` may remain in the final page. The page must have:

- **Title and one-sentence TL;DR**: "In one breath: …"
- **Clickable Mermaid map** at the top: clicking a node jumps to that chapter
  (use `click NodeId call goTo("chapter-id")` with `securityLevel: 'loose'`).
- **Chapters** as collapsible cards: hook → story → real code → line-by-line trace →
  cliffhanger.
- **Code blocks with line annotations**: the real code with line numbers, and numbered
  callout notes under it ("① takes the settings object…").
- **Nested trace**: sub-functions shown as indented, expandable cards inside the parent
  chapter, so the user can drill down or stay high level.
- **Call stack breadcrumb** at the top of each chapter.
- **Term Cards** (the 4 beats) in a sidebar or inline, with a glossary at the bottom.
- **Quizzes** with click-to-reveal answers.
- **Progress bar** and a "chapters read" checkmark (localStorage, wrapped in try/catch).
- **"Choose your next path"** buttons at the end that show the prompt to type next
  (e.g. `explain db/session.py:init_db`).
- Light and dark mode. Mobile friendly. Load libraries from a CDN only (mermaid,
  highlight.js).

Then open it for the user (`open` on macOS, `xdg-open` on Linux, `start` on Windows) and
tell them the path.

## Step 8: The chat reply

Keep the chat reply short: a 3–5 line teaser story, the path to the HTML page, the
Excalidraw drawing name (if made), and the "choose your next path" options. The depth
lives in the page.

---

## Quality checklist (check before finishing)

- [ ] Every code claim has a real `file:line`, and I actually read that file.
- [ ] The trace reached the bottom of every repo function on the path, then climbed back up.
- [ ] Every input and output on the path is named.
- [ ] Every technical term has all 4 beats, including **what breaks without it**.
- [ ] The story world is the same one as earlier chapters (`.storyteller/world.md`).
- [ ] Every chapter has a hook and a cliffhanger. There is at least one quiz.
- [ ] Mermaid nodes are clickable and jump to the right chapters.
- [ ] Nothing in the page is invented. Where I'm unsure, I said so.
