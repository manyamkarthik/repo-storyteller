from contextlib import asynccontextmanager

from fastapi import FastAPI, Request

from db import init_db
from settings import load_settings


@asynccontextmanager
async def lifespan(app: FastAPI):
    settings = load_settings()
    app.state.db = init_db(settings)
    yield
    app.state.db.close()


app = FastAPI(lifespan=lifespan)


@app.get("/notes/{owner}")
def list_notes(owner: str, request: Request):
    rows = request.app.state.db.execute(
        "SELECT id, body FROM notes WHERE owner = ?", (owner,)
    ).fetchall()
    return [{"id": r[0], "body": r[1]} for r in rows]
