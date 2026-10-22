import sqlite3
import time

from settings import Settings


def connect_with_retry(path: str, retries: int) -> sqlite3.Connection:
    for attempt in range(1, retries + 1):
        try:
            conn = sqlite3.connect(path, check_same_thread=False)
            conn.execute("SELECT 1")
            return conn
        except sqlite3.OperationalError:
            if attempt == retries:
                raise
            time.sleep(0.5 * attempt)


def create_tables(conn: sqlite3.Connection) -> None:
    conn.execute(
        "CREATE TABLE IF NOT EXISTS notes ("
        "id INTEGER PRIMARY KEY, owner TEXT NOT NULL, body TEXT NOT NULL)"
    )
    conn.execute("CREATE INDEX IF NOT EXISTS idx_notes_owner ON notes(owner)")
    conn.commit()


def init_db(settings: Settings) -> sqlite3.Connection:
    conn = connect_with_retry(settings.db_path, settings.max_retries)
    create_tables(conn)
    return conn
