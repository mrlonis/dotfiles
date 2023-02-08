# To Run - python util.py
import os
from pathlib import Path

from dotfiles.constants import get_file_inputs
from dotfiles.copier import copy_dot_files
from dotfiles.models import FileMode
from dotfiles.symlinker import create_symlinks

LOG = True
OVERWRITE = False

HOME = os.getenv("HOME")
assert HOME is not None

DESTINATION = Path("./files").resolve()
print(f"Destination: {DESTINATION}")

copy_dot_files(
    source_folder=HOME,
    destination_folder=DESTINATION,
    filenames=get_file_inputs(file_mode=FileMode.COPY),
    overwrite=OVERWRITE,
    log=LOG,
)
print("----------------------------------")
print("")
create_symlinks(destination_folder=HOME, filenames=get_file_inputs(file_mode=FileMode.SYMLINK), log=LOG)
