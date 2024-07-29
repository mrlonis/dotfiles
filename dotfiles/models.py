"""Models for dotfiles app."""
from enum import Enum
from typing import Optional

from pydantic import BaseModel


class FileInput(BaseModel):
    """Model for a file input."""

    filename: str
    destination_filename: Optional[str] = None


class FileMode(Enum):
    """Enum for the file mode."""

    COPY = "copy"
    SYMLINK = "symlink"
