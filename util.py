# To Run - python3 util.py
import os
import shutil
from pathlib import Path
from typing import Union

LOG = True

HOME = os.getenv("HOME")
assert HOME is not None

FILES = [
    "fun.py",
    "setup_all.sh",
    "requirements.in",
    "requirements.txt",
    ".bashrc",
    ".gitconfig",
    ".netrc",
    ".npmrc",
    ".profile",
    ".pypirc",
    ".zshrc",
]

DESTINATION = Path("./files").resolve()
print(f"Destination: {DESTINATION}")


def copy_dot_files(folder: Union[str, Path], files: list[str], log: bool = False):
    if log:
        print(f"Copying files to folder: {folder}")

    if os.path.isdir(folder):
        print(f"Folder exists: {folder}")

        for file in files:
            source_file_path = Path(os.path.join(HOME, os.path.basename(file))).absolute()
            if os.path.exists(source_file_path) and not os.path.islink(source_file_path):
                destination_file_path = Path(os.path.join(folder, os.path.basename(file))).resolve()
                if log:
                    print(f"Copying file: {file}")
                if os.path.exists(destination_file_path):
                    if log:
                        print(f"Removing file: {destination_file_path}")
                    os.remove(destination_file_path)
                shutil.copy(source_file_path, destination_file_path)


def create_symlinks(folder: Union[str, Path], files: list[str], log: bool = False):
    if log:
        print(f"Creating symlinks in folder: {folder}")

    for file in files:
        src_file_path = Path(os.path.join(Path("./files").resolve(), os.path.basename(file))).resolve()

        # Check if file exists in ./files
        if os.path.exists(src_file_path):
            destination_file_path = Path(os.path.join(folder, os.path.basename(file))).absolute()
            print(f"Destination file path: {destination_file_path}")

            # Check if file exists in folder directory
            if os.path.exists(destination_file_path) or os.path.islink(destination_file_path):
                if log:
                    print(f"Removing file: {destination_file_path}")
                os.remove(destination_file_path)

            # Create symlink in folder directory
            if log:
                print(f"Creating symlink: {os.path.basename(file)}")
            os.symlink(src_file_path, destination_file_path)


copy_dot_files(DESTINATION, FILES, LOG)
print("")
create_symlinks(HOME, FILES, LOG)
