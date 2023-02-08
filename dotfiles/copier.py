import os
import shutil
from pathlib import Path

from dotfiles.models import FileInput


def copy_dot_files(
    source_folder: str | Path,
    destination_folder: str | Path,
    filenames: list[FileInput],
    overwrite: bool = False,
    log: bool = False,
    test: bool = False,
):
    if os.path.isdir(destination_folder):
        if log:
            print(f"Copying files to folder: {destination_folder}")

        for file in filenames:
            _copy_dot_file(
                source_folder=source_folder,
                destination_folder=destination_folder,
                file=file,
                overwrite=overwrite,
                log=log,
                test=test,
            )
    else:
        if log:
            print(f"Destination folder {destination_folder} does not exist")


def _copy_dot_file(
    source_folder: str | Path,
    destination_folder: str | Path,
    file: FileInput,
    overwrite: bool = False,
    log: bool = False,
    test: bool = False,
):
    # pylint: disable=too-many-branches
    if log:
        print("")
        print(f"Processing File: {file}")
    source_file_path = Path(os.path.join(source_folder, os.path.basename(file.filename))).absolute()

    exists = os.path.exists(source_file_path)
    is_symlink = os.path.islink(source_file_path)
    if exists and not is_symlink:
        destination_file_path = Path(
            os.path.join(
                destination_folder,
                os.path.basename(file.destination_filename if file.destination_filename else file.filename),
            )
        ).resolve()

        if os.path.exists(destination_file_path):
            if overwrite:
                if log:
                    print(f"Removing file: {destination_file_path}")
                if not test:
                    os.remove(destination_file_path)
                else:
                    print("TEST: Not removing file")
                if log:
                    print(f"Copying {source_file_path} to {destination_file_path}")
                if not test:
                    shutil.copy(source_file_path, destination_file_path)
                    if log:
                        print(f"Successfully copied {source_file_path} to {destination_file_path}")
                else:
                    print("TEST: Not copying file")
            else:
                if log:
                    print(f"{file} exists and overwrite is False")
        else:
            if log:
                print(f"Copying {source_file_path} to {destination_file_path}")
            if not test:
                shutil.copy(source_file_path, destination_file_path)
                if log:
                    print(f"Successfully copied {source_file_path} to {destination_file_path}")
            else:
                print("TEST: Not copying file")
    else:
        if log:
            if not exists:
                print(f"{source_file_path} does not exist")
            elif is_symlink:
                print(f"{source_file_path} is a symlink")
            else:
                print(f"{source_file_path} had processing errors. exists: {exists}, is_symlink: {is_symlink}")
