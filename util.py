# To Run - python3 util.py
import os
import shutil
from pathlib import Path
from typing import Union

LOG = True
OVERWRITE = False

HOME = os.getenv("HOME")
assert HOME is not None

FILENAMES = [
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


def _copy_dot_file(destination_folder: Union[str, Path], file: str, overwrite: bool = False, log: bool = False):
    if log:
        print(f"File: {file}")
    source_file_path = Path(os.path.join(HOME, os.path.basename(file))).absolute()

    if os.path.exists(source_file_path) and not os.path.islink(source_file_path):
        destination_file_path = Path(os.path.join(destination_folder, os.path.basename(file))).resolve()

        if os.path.exists(destination_file_path):
            if overwrite:
                if log:
                    print(f"Removing file: {destination_file_path}")
                os.remove(destination_file_path)
                if log:
                    print(f"Copying {source_file_path} to {destination_file_path}")
                shutil.copy(source_file_path, destination_file_path)
            else:
                if log:
                    print(f"{file} exists and overwrite is False")
        else:
            if log:
                print(f"Copying {source_file_path} to {destination_file_path}")
            shutil.copy(source_file_path, destination_file_path)
    else:
        if log:
            print(f"{source_file_path} does not exist or is a symlink")

    if log:
        print("")


def copy_dot_files(destination_folder: Union[str, Path], filenames: list[str], overwrite: bool = False, log: bool = False):
    if log:
        print(f"Copying files to folder: {destination_folder}")

    if os.path.isdir(destination_folder):
        if log:
            print(f"Folder exists: {destination_folder}")

        for file in filenames:
            _copy_dot_file(destination_folder=destination_folder, file=file, overwrite=overwrite, log=log)


def create_symlinks(destination_folder: Union[str, Path], filenames: list[str], log: bool = False):
    if log:
        print(f"Creating symlinks in folder: {destination_folder}")

    for file in filenames:
        if log:
            print(f"File: {file}")
        src_file_path = Path(os.path.join(Path("./files").resolve(), os.path.basename(file))).resolve()

        # Check if file exists in ./files
        if os.path.exists(src_file_path):
            destination_file_path = Path(os.path.join(destination_folder, os.path.basename(file))).absolute()

            # Check if file exists in folder directory
            if os.path.exists(destination_file_path) or os.path.islink(destination_file_path):
                if log:
                    print(f"Removing {destination_file_path}")
                os.remove(destination_file_path)

            # Create symlink in folder directory
            if log:
                print(f"Creating symlink for {src_file_path} to {destination_file_path}")
            os.symlink(src_file_path, destination_file_path)
        else:
            if log:
                print(f"{src_file_path} does not exist")

        if log:
            print("")


copy_dot_files(destination_folder=DESTINATION, filenames=FILENAMES, overwrite=OVERWRITE, log=LOG)
print("----------------------------------")
print("")
create_symlinks(destination_folder=HOME, filenames=FILENAMES, log=LOG)
