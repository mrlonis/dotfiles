import os
from pathlib import Path
from typing import Union


def create_symlinks(destination_folder: Union[str, Path], filenames: list[str], log: bool = False, test: bool = False):
    # pylint: disable=too-many-branches
    if log:
        print(f"Creating symlinks in folder: {destination_folder}")

    for file in filenames:
        if log:
            print("")
            print(f"Processing File: {file}")
        src_file_path = Path(os.path.join(Path("./files").resolve(), os.path.basename(file))).resolve()

        # Check if file exists in ./files
        if os.path.exists(src_file_path):
            destination_file_path = Path(os.path.join(destination_folder, os.path.basename(file))).absolute()

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
                os.symlink(src_file_path, destination_file_path)
                if log:
                    print(f"Created symlink for {src_file_path} to {destination_file_path}")
            else:
                print("TEST: Not creating symlink")
        else:
            if log:
                print(f"{src_file_path} does not exist")
