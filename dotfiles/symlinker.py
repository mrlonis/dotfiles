"""This module contains the logic for creating symlinks for the dotfiles."""

import os
from pathlib import Path
from typing import Union

from dotfiles.models import FileInput


def create_symlinks(
    destination_folder: Union[str, Path],
    filenames: list[FileInput],
    log: bool = False,
    test: bool = False,
):
    """Create symlinks for the dotfiles."""
    # pylint: disable=too-many-branches
    if log:
        print(f"Creating symlinks in folder: {destination_folder}")
    dir_path_exists = os.path.exists(destination_folder)
    if not dir_path_exists:
        # Create a new directory because it does not exist
        os.makedirs(destination_folder)
        print(f"The new directory ({destination_folder}) is created!")

    for file in filenames:
        if log:
            print("")
            print(f"Processing File: {file}")
        src_file_path = Path(os.path.join(Path("./files").resolve(), os.path.basename(file.filename))).resolve()

        # Check if file exists in ./files
        if os.path.exists(src_file_path):
            destination_file_path = Path(
                os.path.join(
                    destination_folder,
                    os.path.basename(file.destination_filename if file.destination_filename else file.filename),
                )
            ).absolute()

            # Check if file exists in folder directory
            if os.path.exists(destination_file_path) or os.path.islink(destination_file_path):
                if log:
                    print(f"Removing {destination_file_path}")
                if not test:
                    os.remove(destination_file_path)
                    if log:
                        print(f"Removed {destination_file_path}")
                else:
                    print("TEST: Not removing file")

            # Create symlink in folder directory
            if log:
                print(f"Creating symlink for {src_file_path} to {destination_file_path}")
            if not test:
                target_is_directory = os.path.isdir(src_file_path)
                os.symlink(src_file_path, destination_file_path, target_is_directory=target_is_directory)
                if log:
                    print(f"Created symlink for {src_file_path} to {destination_file_path}")
            else:
                print("TEST: Not creating symlink")
        else:
            if log:
                print(f"{src_file_path} does not exist")
