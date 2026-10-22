import os
from dataclasses import dataclass


@dataclass(frozen=True)
class Settings:
    db_path: str
    max_retries: int


def load_settings() -> Settings:
    return Settings(
        db_path=os.getenv("NOTES_DB", "notes.db"),
        max_retries=int(os.getenv("NOTES_DB_RETRIES", "3")),
    )
