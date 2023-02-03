# To Run - python3 util.py
import os
from pathlib import Path

from dotfiles.constants import FILENAMES
from dotfiles.copier import copy_dot_files
from dotfiles.symlinker import create_symlinks

LOG = True
OVERWRITE = False

HOME = os.getenv("HOME")
assert HOME is not None

DESTINATION = Path("./files").resolve()
print(f"Destination: {DESTINATION}")

copy_dot_files(source_folder=HOME, destination_folder=DESTINATION, filenames=FILENAMES, overwrite=OVERWRITE, log=LOG)
print("----------------------------------")
print("")
create_symlinks(destination_folder=HOME, filenames=FILENAMES, log=LOG)
