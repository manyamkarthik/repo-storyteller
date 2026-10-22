# tiny-notes-api (demo target)

A deliberately tiny FastAPI + SQLite app used to show what **repo-storyteller** produces.

Prompt used:

```text
explain the lifespan in app.py like I'm 5 and trace every function it calls
```

Output: [`docs/demo/startup-story.html`](../../docs/demo/startup-story.html) · [live page](https://manyamkarthik.github.io/repo-storyteller/demo/startup-story.html)

Run it yourself:

```bash
pip install fastapi uvicorn
uvicorn app:app --reload
```
