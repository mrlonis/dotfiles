# To Run - python3 util.py
import os
import shutil
from pathlib import Path
from typing import Union

LOG = True

HOME = os.getenv("HOME")
assert HOME is not None

FILES = [
    f"{HOME}/fun.py",
    f"{HOME}/setup_all.sh",
    f"{HOME}/requirements.in",
    f"{HOME}/requirements.txt",
    f"{HOME}/.bashrc",
    f"{HOME}/.gitconfig",
    f"{HOME}/.netrc",
    f"{HOME}/.npmrc",
    f"{HOME}/.profile",
    f"{HOME}/.pypirc",
    f"{HOME}/.zshrc",
]

DESTINATION = Path("./").resolve()
print(f"Destination: {DESTINATION}")


def copy_specific_files_to_specific_folder(
    folder: Union[str, Path], files: list[str], log: bool = False
):
    if log:
        print(f"Copying files to folder: {folder}")

    if os.path.isdir(folder):
        print(f"Folder exists: {folder}")

        for file in files:
            file_path = Path(file).resolve()

            if os.path.exists(file_path):
                if log:
                    print(f"Copying file: {file}")
                file_destination = os.path.join(folder, os.path.basename(file))
                if os.path.exists(file_destination):
                    if log:
                        print(f"Removing file: {file_destination}")
                    os.remove(file_destination)
                shutil.copy(Path(file).resolve(), file_destination)


# copy_folders_to_destination(DIRECTORIES, LOG)
copy_specific_files_to_specific_folder(DESTINATION, FILES, LOG)
