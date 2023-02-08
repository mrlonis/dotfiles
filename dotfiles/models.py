from enum import Enum
from typing import Optional

from pydantic import BaseModel


class FileInput(BaseModel):
    filename: str
    destination_filename: Optional[str] = None


class FileMode(Enum):
    COPY = "copy"
    SYMLINK = "symlink"
